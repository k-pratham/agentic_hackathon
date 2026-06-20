"""
Pipeline orchestrator — main entry point for document ingestion processing.

Wires together all pipeline components:
  - PDF rendering → NuMarkdown → Section splitting → Embedding → Elasticsearch
  - Excel parsing → Oracle KRI table insertion
  - Inspection report DOCX → structured domain/section/table extraction
  - Compliance report XLSX → row-level structured observations with status
  - Job tracking in Oracle ingestion_jobs table
  - Inspection lookup from folder name → Oracle inspection_master
"""

import os
import re
import logging
import traceback
from pathlib import Path

from ingestion.config.settings import AppSettings
from ingestion.clients.aphrodite import AphroditeClient
from ingestion.clients.elasticsearch import ElasticsearchClient
from ingestion.clients.embedding import create_embedding_provider, EmbeddingProvider
from ingestion.db.connection import OracleConnectionPool
from ingestion.db.constants import DocumentType, DocumentCategory, EsFields
from ingestion.db.repository import IngestionRepository
from ingestion.pipeline.pdf_processor import extract_pages_as_base64
from ingestion.pipeline.markdown import convert_pages_to_markdown
from ingestion.pipeline.splitter import split_into_sections
from ingestion.pipeline.metadata import extract_document_metadata
from ingestion.pipeline.excel_processor import (
    parse_excel_to_kri,
    parse_compliance_excel,
    parse_generic_excel_to_markdown,
    parse_kri_questionnaire_excel
)
from ingestion.pipeline.ppt_processor import parse_pptx_to_markdown_slides
from ingestion.pipeline.txt_processor import parse_txt_to_string
from ingestion.pipeline.docx_processor import (
    parse_docx_to_string,
    parse_inspection_docx,
)

logger = logging.getLogger(__name__)

# Supported file extensions
SUPPORTED_EXTENSIONS: set[str] = {
    ".pdf",
    ".xlsx",
    ".xls",
    ".txt",
    ".ppt",
    ".pptx",
    ".docx",
    ".csv",
}

# Subfolder category mapping
FOLDER_CATEGORY_MAP: dict[str, str] = {
    "inspection_reports": DocumentCategory.INSPECTION_REPORT,
    "letters": DocumentCategory.LETTER,
    "proof": DocumentCategory.PROOF,
    "proofs": DocumentCategory.PROOF,
    "kri": DocumentCategory.KRI,
    "compliance_reports": DocumentCategory.COMPLIANCE_REPORT,
    "compliance_report": DocumentCategory.COMPLIANCE_REPORT,
    "alerts_and_advisories": DocumentCategory.ALERT_ADVISORY,
    "alerts_and_advisory": DocumentCategory.ALERT_ADVISORY,
    "alerts_advisory": DocumentCategory.ALERT_ADVISORY,
}

# Pattern to extract entity short code from proofs subfolder path
# e.g. ".../proofs/PNPB/..."  or  ".../proofs/SNCB/..."
ENTITY_SHORT_CODE_PATTERN = re.compile(
    r'proofs?[\\/]+([A-Z0-9_]+)',
    re.IGNORECASE,
)



class IngestionOrchestrator:
    """
    Main pipeline orchestrator.

    Manages the lifecycle of all components and coordinates
    the document processing workflow.
    """

    def __init__(self, settings: AppSettings):
        self._settings = settings

        # Initialize components
        self._pool = OracleConnectionPool(settings.app_oracle)
        self._repo: IngestionRepository | None = None
        self._aphrodite: AphroditeClient | None = None
        self._es_client: ElasticsearchClient | None = None
        self._embedding: EmbeddingProvider | None = None

    def initialize(self) -> None:
        """Initialize all components. Must be called before processing."""
        logger.info("Initializing ingestion pipeline components...")

        # Database
        self._pool.initialize()
        self._repo = IngestionRepository(self._pool)

        # Aphrodite LLM client
        self._aphrodite = AphroditeClient(
            settings=self._settings.aphrodite,
            timeout=self._settings.pipeline.http_timeout,
            connect_timeout=self._settings.pipeline.http_connect_timeout,
        )

        # Elasticsearch
        self._es_client = ElasticsearchClient(
            settings=self._settings.elasticsearch,
            timeout=self._settings.pipeline.http_timeout,
        )
        self._es_client.ensure_index_exists()

        # Embedding provider
        self._embedding = create_embedding_provider(self._settings.embedding)

        logger.info("All pipeline components initialized successfully")

    def close(self) -> None:
        """Release all resources."""
        if self._aphrodite:
            self._aphrodite.close()
        if self._es_client:
            self._es_client.close()
        if self._embedding:
            self._embedding.close()
        self._pool.close()
        logger.info("Pipeline resources released")

    # -----------------------------------------------------------------------
    # Folder Metadata Helpers
    # -----------------------------------------------------------------------

    @staticmethod
    def _extract_folder_metadata(
        file_abs_path: str, inspection,
    ) -> dict:
        """
        Extract enriched metadata from the folder hierarchy.

        Derives dept_code, insp_code, entity_short_code, source_subfolder
        from the file path relative to the evidence root.

        Returns a dict of enriched fields for ES indexing.
        """
        path = Path(file_abs_path).resolve()
        parts = path.parts

        meta = {
            "insp_code": "",
            "dept_code": "",
            "entity_short_code": "",
            "source_subfolder": "",
            "source_file": path.name,
        }

        # Walk path parts to find inspection folder pattern: insp_<N>_<dept>
        insp_code = ""
        dept_code = ""
        for i, part in enumerate(parts):
            if re.match(r'^insp_\d+_', part, re.IGNORECASE):
                insp_code = part
                # dept code is the suffix after insp_<N>_
                parts_suffix = part.split('_', 2)
                if len(parts_suffix) >= 3:
                    dept_code = parts_suffix[2]
                # Look for entity short code in proofs subfolder
                for j in range(i + 1, min(i + 5, len(parts))):
                    m = ENTITY_SHORT_CODE_PATTERN.search(parts[j])
                    if m:
                        meta["entity_short_code"] = m.group(1).upper()
                        break
                    # Also check if there's a proofs/* path further down
                    subpath = '/'.join(parts[i:j+1])
                    sm = ENTITY_SHORT_CODE_PATTERN.search(subpath)
                    if sm:
                        meta["entity_short_code"] = sm.group(1).upper()
                        break
                break

        meta["insp_code"] = insp_code
        meta["dept_code"] = dept_code.upper() if dept_code else ""

        # Derive source_subfolder from the category subfolder name
        for i, part in enumerate(parts):
            lower = part.lower()
            if lower in FOLDER_CATEGORY_MAP:
                meta["source_subfolder"] = part
                break
            # Also check for deeper nesting like proofs/PNPB/04_Network_Security
            if lower in ("proof", "proofs"):
                # Next part might be entity code, then domain subfolder
                remaining = parts[i+2:] if i + 2 < len(parts) else []
                if remaining:
                    meta["source_subfolder"] = f"{parts[i]}/{parts[i+1]}/{remaining[0]}"
                elif i + 1 < len(parts):
                    meta["source_subfolder"] = f"{parts[i]}/{parts[i+1]}"
                break

        return meta

    @staticmethod
    def _extract_entity_short_code_from_path(file_abs_path: str) -> str:
        """Extract entity short code (e.g. PNPB, SNCB) from the file path."""
        path = Path(file_abs_path).resolve()
        parts = path.parts
        # Try proofs/<CODE>/ pattern
        for i, part in enumerate(parts):
            if part.lower() in ("proof", "proofs") and i + 1 < len(parts):
                candidate = parts[i + 1]
                if re.match(r'^[A-Z0-9_]{2,10}$', candidate, re.IGNORECASE):
                    return candidate.upper()
        # Try extracting from filename: ITE_Report_04_PNPB.docx
        m = re.search(r'ITE_Report_\d+_([A-Z0-9_]+)', path.stem, re.IGNORECASE)
        if m:
            return m.group(1).upper()
        return ""

    # -----------------------------------------------------------------------
    # Common ES doc builder
    # -----------------------------------------------------------------------

    def _build_base_es_doc(
        self, doc_id: str, inspection, document_category: str,
        extension: str, extra: dict | None = None,
    ) -> dict:
        """Build base ES document with common enriched fields."""
        return {
            EsFields.DOC_ID: doc_id,
            EsFields.INSP_ID: inspection.insp_id,
            EsFields.DEPT_ID: inspection.dept_id,
            EsFields.DOCUMENT_TYPE: DocumentType.EXCEL if extension in (".xlsx", ".xls") else DocumentType.PDF,
            EsFields.DOCUMENT_CATEGORY: document_category,
            EsFields.FILE_EXTENSION: extension,
            EsFields.ENTITY_NAME: inspection.entity_name,
            EsFields.REPORT_YEAR: inspection.evaluation_year,
            **(extra or {}),
        }

    # -----------------------------------------------------------------------
    # Directory Processing
    # -----------------------------------------------------------------------

    def process_directory(self, directory_path: str) -> dict:
        """
        Process all documents in a directory structure.

        Expects either:
          - A parent directory containing inspection folders
          - A single inspection folder

        If the directory itself is an inspection folder (matches a
        reference code in the DB), processes its files directly.
        Otherwise, iterates over subdirectories as inspection folders.

        Args:
            directory_path: Path to the input directory.

        Returns:
            Summary dict with counts of processed, succeeded, and failed files.
        """
        dir_path = Path(directory_path).resolve()
        if not dir_path.is_dir():
            raise FileNotFoundError(f"Directory not found: {dir_path}")

        summary = {"total": 0, "success": 0, "failed": 0, "skipped": 0}

        # Check if this directory itself is an inspection folder
        folder_name = dir_path.name
        inspection = self._repo.lookup_inspection(folder_name)

        if inspection is not None:
            # Process as a single inspection folder
            logger.info(
                "Processing inspection folder: %s (insp_id=%d)",
                folder_name,
                inspection.insp_id,
            )
            self._process_inspection_folder(dir_path, inspection, summary)
        else:
            # Recursively iterate over subdirectories as inspection folders
            logger.info("Recursively scanning directory for inspection folders: %s", dir_path)
            
            # Find all subdirectories, but we only process ones that match an inspection code
            # We use rglob("*") to find all nested directories
            found_inspections = 0
            for subdir in dir_path.rglob("*"):
                if not subdir.is_dir():
                    continue
                    
                sub_name = subdir.name
                insp = self._repo.lookup_inspection(sub_name)

                if insp is None:
                    continue

                found_inspections += 1
                logger.info(
                    "Processing inspection folder: %s (insp_id=%d)",
                    sub_name,
                    insp.insp_id,
                )
                self._process_inspection_folder(subdir, insp, summary)
                
            if found_inspections == 0:
                logger.warning("No valid inspection folders found in %s", dir_path)

        logger.info(
            "Directory processing complete — total=%d, success=%d, "
            "failed=%d, skipped=%d",
            summary["total"],
            summary["success"],
            summary["failed"],
            summary["skipped"],
        )
        return summary

    def _process_inspection_folder(
        self, folder_path: Path, inspection, summary: dict
    ) -> None:
        """
        Process all subfolders and supported files within an inspection folder.
        
        Scans subdirectories matching defined categories, and falls back to
        scanning root files as Proof documents if no subdirectories are found.
        """
        subdirs_found = False
        for item in folder_path.iterdir():
            if item.is_dir():
                sub_name_lower = item.name.lower()
                category = FOLDER_CATEGORY_MAP.get(sub_name_lower)
                if category is not None:
                    subdirs_found = True
                    logger.info(
                        "Scanning subfolder '%s' for category '%s'",
                        item.name,
                        category,
                    )
                    self._process_files_in_category_folder(item, category, inspection, summary)
                else:
                    logger.warning(
                        "Ignoring unknown subfolder '%s' under inspection '%s'",
                        item.name,
                        folder_path.name,
                    )

        if not subdirs_found:
            logger.info(
                "No category subfolders found. Scanning root folder '%s' directly (Proof fallback)",
                folder_path.name,
            )
            self._process_files_in_category_folder(folder_path, DocumentCategory.PROOF, inspection, summary)

    def _process_files_in_category_folder(
        self, folder_path: Path, category: str, inspection, summary: dict
    ) -> None:
        """Scan and process supported files recursively in a specific category directory."""
        files = sorted(
            f for f in folder_path.rglob("*")
            if f.is_file() and f.suffix.lower() in SUPPORTED_EXTENSIONS
        )

        if not files:
            logger.info("No supported files found in '%s'", folder_path)
            return

        for file_path in files:
            summary["total"] += 1
            try:
                self.process_single_file(str(file_path), inspection, document_category=category)
                summary["success"] += 1
            except Exception:
                summary["failed"] += 1
                logger.error(
                    "Failed to process file '%s' (category=%s)",
                    file_path,
                    category,
                    exc_info=True,
                )

    # -----------------------------------------------------------------------
    # Single File Processing
    # -----------------------------------------------------------------------

    def process_single_file(
        self, file_path: str, inspection, document_category: str = None
    ) -> None:
        """
        Process a single document file through the full pipeline.

        Routes to the appropriate handler based on document category and file format.
        Indexes documents with precise metadata to support high-performance search.

        Args:
            file_path: Absolute path to the document file.
            inspection: InspectionRecord with insp_id, dept_id, etc.
            document_category: Explicit category (e.g. KRI, LETTER, PROOF).
        """
        path = Path(file_path).resolve()
        extension = path.suffix.lower()

        if extension not in SUPPORTED_EXTENSIONS:
            logger.warning("Unsupported file type: %s", extension)
            return

        # Infer category from parent directory if not explicitly provided
        if document_category is None:
            parent_name = path.parent.name.lower()
            document_category = FOLDER_CATEGORY_MAP.get(parent_name, DocumentCategory.PROOF)

        file_size = path.stat().st_size
        filename = path.name

        # Map general document type (Oracle metadata schema compatibility)
        if extension in (".xlsx", ".xls") and document_category == DocumentCategory.KRI:
            document_type = DocumentType.EXCEL
        else:
            document_type = DocumentType.PDF

        logger.info(
            "Processing file: %s (category=%s, type=%s, size=%d bytes)",
            filename,
            document_category,
            document_type,
            file_size,
        )

        # Create job record
        job_id = self._repo.create_ingestion_job(filename, file_size)
        self._repo.update_job_status(job_id, "PROCESSING")

        try:
            # Insert document metadata into Oracle
            doc_id = self._repo.insert_document_metadata(
                job_id=job_id,
                insp_id=inspection.insp_id,
                dept_id=inspection.dept_id,
                document_type=document_type,
                document_category=document_category,
                file_extension=extension,
                storage_path=str(path),
            )

            # Route by category and extension
            if document_category == DocumentCategory.KRI:
                self._process_kri_questionnaire(path, doc_id, inspection)
            elif document_category == DocumentCategory.COMPLIANCE_REPORT:
                self._process_compliance_excel(path, doc_id, inspection)
            elif document_category == DocumentCategory.INSPECTION_REPORT and extension == ".docx":
                self._process_inspection_report_docx(path, doc_id, inspection, document_category)
            elif extension == ".pdf":
                self._process_pdf(path, doc_id, inspection, document_category)
            else:
                # Text, Presentation, Generic/Proof Excel files
                self._process_unstructured_text_doc(
                    path, doc_id, inspection, document_category, extension
                )

            self._repo.update_job_status(job_id, "SUCCESS")
            logger.info("File processed successfully: %s (job_id=%d)", filename, job_id)

        except Exception as e:
            error_msg = f"{type(e).__name__}: {str(e)}\n{traceback.format_exc()}"
            self._repo.update_job_status(job_id, "FAILED", error_log=error_msg)
            logger.error("File processing failed: %s (job_id=%d)", filename, job_id)
            raise

    # -----------------------------------------------------------------------
    # Inspection Report DOCX Processing Pipeline
    # -----------------------------------------------------------------------

    def _process_inspection_report_docx(
        self, docx_path: Path, doc_id: str, inspection, document_category: str
    ) -> None:
        """
        Structured inspection report DOCX pipeline:
        1. Parse into structured sections with domain names, headings, tables
        2. Embed each section
        3. Index in Elasticsearch with enriched metadata

        Each section is indexed as a separate ES document with domain_name,
        section_heading, annex_type, and table data preserved.
        """
        folder_meta = self._extract_folder_metadata(str(docx_path), inspection)
        entity_short = folder_meta.get("entity_short_code") or \
            self._extract_entity_short_code_from_path(str(docx_path))

        sections = parse_inspection_docx(str(docx_path))

        if not sections or all(not s['text'].strip() for s in sections):
            logger.warning("No content extracted from inspection report: %s", docx_path)
            return

        es_documents: list[dict] = []

        for index, section in enumerate(sections):
            text_content = section['text'].strip()
            if not text_content:
                continue

            # Build annex/advisory/DPSC fields based on annex_type
            annex_fields = {}
            annex_type = section.get('annex_type')
            if annex_type:
                annex_fields[EsFields.ANNEX_TYPE] = annex_type
                # For annex tables, we also store the table data
                tables = section.get('tables', [])
                for ti, table in enumerate(tables):
                    table_text = table.get('text', '')
                    if table_text:
                        text_content += f"\n\n--- Table {ti + 1} ---\n{table_text}"

            vector = self._embedding.generate(text_content)

            es_doc = {
                EsFields.DOC_ID: doc_id,
                EsFields.INSP_ID: inspection.insp_id,
                EsFields.DEPT_ID: inspection.dept_id,
                EsFields.INSP_CODE: folder_meta.get("insp_code", ""),
                EsFields.DEPT_CODE: folder_meta.get("dept_code", ""),
                EsFields.ENTITY_SHORT_CODE: entity_short,
                EsFields.ENTITY_NAME: inspection.entity_name,
                EsFields.REPORT_YEAR: inspection.evaluation_year,
                EsFields.SOURCE_FILE: folder_meta.get("source_file", ""),
                EsFields.SOURCE_SUBFOLDER: folder_meta.get("source_subfolder", ""),
                EsFields.DOCUMENT_TYPE: DocumentType.PDF,
                EsFields.DOCUMENT_CATEGORY: document_category,
                EsFields.FILE_EXTENSION: ".docx",
                EsFields.DOMAIN_NAME: section.get('domain_name'),
                EsFields.DOMAIN_INDEX: section.get('domain_index'),
                EsFields.SECTION_INDEX: index,
                EsFields.SECTION_HEADING: section.get('heading', ''),
                EsFields.TEXT_CONTENT: text_content,
                EsFields.CONTENT_VECTOR: vector,
                **annex_fields,
            }
            es_documents.append(es_doc)

        if es_documents:
            self._es_client.bulk_index(es_documents)
            logger.info(
                "Indexed %d sections from inspection report for doc_id=%s",
                len(es_documents), doc_id,
            )

    # -----------------------------------------------------------------------
    # PDF Processing Pipeline
    # -----------------------------------------------------------------------

    def _process_pdf(
        self, pdf_path: Path, doc_id: str, inspection, document_category: str
    ) -> None:
        """
        Full PDF processing pipeline:
        1. Render pages to images
        2. Convert images to Markdown via NuMarkdown
        3. Extract metadata from first page
        4. Split into sections
        5. Generate embeddings
        6. Index in Elasticsearch
        """
        # Step 1: Render PDF pages
        base64_images = extract_pages_as_base64(
            str(pdf_path),
            dpi_scale=self._settings.pipeline.dpi_scale,
        )

        if not base64_images:
            logger.warning("No pages extracted from PDF: %s", pdf_path)
            return

        # Step 2: Convert pages to Markdown
        full_markdown = convert_pages_to_markdown(
            base64_images=base64_images,
            aphrodite_client=self._aphrodite,
            max_workers=1,  # Force sequential page conversion to avoid local GPU overload
        )

        if not full_markdown.strip():
            raise ValueError(f"Empty markdown output generated for PDF: {pdf_path}")

        # Step 3: Extract metadata from first page
        first_page_sections = full_markdown.split("\n\n\n", 1)
        first_page_md = first_page_sections[0] if first_page_sections else ""
        extracted_meta = extract_document_metadata(first_page_md, self._aphrodite)

        # Use extracted metadata or fall back to inspection data
        entity_name = (
            extracted_meta.get("entity_name") or inspection.entity_name
        )
        report_year = (
            extracted_meta.get("evaluation_year") or inspection.evaluation_year
        )

        # Step 4: Split into sections
        sections = split_into_sections(full_markdown)

        if not sections:
            logger.warning("No sections extracted from PDF: %s", pdf_path)
            return

        # Steps 5 & 6: Generate embeddings and index
        folder_meta = self._extract_folder_metadata(str(pdf_path), inspection)
        entity_short = folder_meta.get("entity_short_code") or \
            self._extract_entity_short_code_from_path(str(pdf_path))

        es_documents: list[dict] = []

        for index, section_content in enumerate(sections):
            vector = self._embedding.generate(section_content)

            es_doc = {
                EsFields.DOC_ID: doc_id,
                EsFields.INSP_ID: inspection.insp_id,
                EsFields.DEPT_ID: inspection.dept_id,
                EsFields.INSP_CODE: folder_meta.get("insp_code", ""),
                EsFields.DEPT_CODE: folder_meta.get("dept_code", ""),
                EsFields.ENTITY_SHORT_CODE: entity_short,
                EsFields.ENTITY_NAME: entity_name,
                EsFields.REPORT_YEAR: report_year,
                EsFields.SOURCE_FILE: folder_meta.get("source_file", ""),
                EsFields.SOURCE_SUBFOLDER: folder_meta.get("source_subfolder", ""),
                EsFields.DOCUMENT_TYPE: DocumentType.PDF,
                EsFields.DOCUMENT_CATEGORY: document_category,
                EsFields.FILE_EXTENSION: ".pdf",
                EsFields.SECTION_INDEX: index,
                EsFields.TEXT_CONTENT: section_content,
                EsFields.CONTENT_VECTOR: vector,
            }
            es_documents.append(es_doc)

        # Bulk index all sections
        if es_documents:
            self._es_client.bulk_index(es_documents)
            logger.info(
                "Indexed %d sections for doc_id=%s", len(es_documents), doc_id
            )

    # -----------------------------------------------------------------------
    # KRI Questionnaire Excel Processing Pipeline (Option 1)
    # -----------------------------------------------------------------------

    def _process_kri_questionnaire(self, excel_path: Path, doc_id: str, inspection) -> None:
        """
        KRI Questionnaire processing pipeline:
        1. Parse questionnaire row-by-row mapping Q&A
        2. Embed each Q&A context
        3. Index to Elasticsearch
        """
        kri_records = parse_kri_questionnaire_excel(str(excel_path))

        if not kri_records:
            logger.warning("No KRI records parsed from: %s", excel_path)
            return

        folder_meta = self._extract_folder_metadata(str(excel_path), inspection)
        entity_short = folder_meta.get("entity_short_code") or \
            self._extract_entity_short_code_from_path(str(excel_path))

        es_documents: list[dict] = []

        for index, record in enumerate(kri_records):
            text_context = record["text_content"]
            vector = self._embedding.generate(text_context)

            es_doc = {
                EsFields.DOC_ID: doc_id,
                EsFields.INSP_ID: inspection.insp_id,
                EsFields.DEPT_ID: inspection.dept_id,
                EsFields.INSP_CODE: folder_meta.get("insp_code", ""),
                EsFields.DEPT_CODE: folder_meta.get("dept_code", ""),
                EsFields.ENTITY_SHORT_CODE: entity_short,
                EsFields.ENTITY_NAME: record["se_name"] or inspection.entity_name,
                EsFields.REPORT_YEAR: inspection.evaluation_year,
                EsFields.SOURCE_FILE: folder_meta.get("source_file", ""),
                EsFields.SOURCE_SUBFOLDER: folder_meta.get("source_subfolder", ""),
                EsFields.DOCUMENT_TYPE: DocumentType.EXCEL,
                EsFields.DOCUMENT_CATEGORY: DocumentCategory.KRI,
                EsFields.FILE_EXTENSION: excel_path.suffix.lower(),
                EsFields.SECTION_INDEX: index,
                EsFields.TEXT_CONTENT: text_context,
                EsFields.CONTENT_VECTOR: vector,
            }
            es_documents.append(es_doc)

        # Bulk index all KRI questionnaire records
        if es_documents:
            self._es_client.bulk_index(es_documents)
            logger.info(
                "Indexed %d KRI questionnaire observations in Elasticsearch for doc_id=%s",
                len(es_documents),
                doc_id,
            )

    # -----------------------------------------------------------------------
    # Compliance Report Excel Processing Pipeline
    # -----------------------------------------------------------------------

    def _process_compliance_excel(self, excel_path: Path, doc_id: str, inspection) -> None:
        """
        Compliance Excel processing pipeline:
        1. Parse compliance row-by-row mapping columns and comments
        2. Embed each row context
        3. Index to Elasticsearch
        """
        compliance_records = parse_compliance_excel(str(excel_path))

        if not compliance_records:
            logger.warning("No compliance records parsed from: %s", excel_path)
            return

        folder_meta = self._extract_folder_metadata(str(excel_path), inspection)
        entity_short = folder_meta.get("entity_short_code") or \
            self._extract_entity_short_code_from_path(str(excel_path))

        es_documents: list[dict] = []

        for index, record in enumerate(compliance_records):
            text_context = record["text_content"]
            vector = self._embedding.generate(text_context)

            # Compliance status from structured fields
            compliance_status = record.get("compliance_status", "")
            se_status = record.get("se_status", "")

            es_doc = {
                EsFields.DOC_ID: doc_id,
                EsFields.INSP_ID: inspection.insp_id,
                EsFields.DEPT_ID: inspection.dept_id,
                EsFields.INSP_CODE: folder_meta.get("insp_code", ""),
                EsFields.DEPT_CODE: folder_meta.get("dept_code", ""),
                EsFields.ENTITY_SHORT_CODE: entity_short,
                EsFields.ENTITY_NAME: record.get("supervised_entity_name") or inspection.entity_name,
                EsFields.REPORT_YEAR: inspection.evaluation_year,
                EsFields.SOURCE_FILE: folder_meta.get("source_file", ""),
                EsFields.SOURCE_SUBFOLDER: folder_meta.get("source_subfolder", ""),
                EsFields.DOCUMENT_TYPE: DocumentType.EXCEL,
                EsFields.DOCUMENT_CATEGORY: DocumentCategory.COMPLIANCE_REPORT,
                EsFields.FILE_EXTENSION: excel_path.suffix.lower(),
                EsFields.SECTION_INDEX: index,
                EsFields.TABLE_ROW_INDEX: index,

                EsFields.OBSERVATION_ID: record.get("observation_id", record.get("action_para_id", "")),
                EsFields.PARA_ID: record.get("action_para_id", ""),
                EsFields.OBSERVATION_TEXT: record.get("observation_text", record.get("observation", "")),

                EsFields.COMPLIANCE_STATUS: compliance_status,
                EsFields.SE_STATUS: se_status,
                EsFields.ACTUAL_DUE_DATE: record.get("actual_due_date"),
                EsFields.EXTENDED_DUE_DATE: record.get("extended_due_date"),
                EsFields.RESPONSE_TYPE: record.get("response_type", ""),
                EsFields.IS_RESUBMISSION_REQUIRED: record.get("is_resubmission_required", ""),

                EsFields.TEXT_CONTENT: text_context,
                EsFields.CONTENT_VECTOR: vector,
            }
            es_documents.append(es_doc)

        # Bulk index all compliance records
        if es_documents:
            self._es_client.bulk_index(es_documents)
            logger.info(
                "Indexed %d compliance observations in Elasticsearch for doc_id=%s",
                len(es_documents),
                doc_id,
            )

    # -----------------------------------------------------------------------
    # Unstructured Text Documents Ingestion (TXT, PPT, Proof Excels)
    # -----------------------------------------------------------------------

    def _process_unstructured_text_doc(
        self,
        file_path: Path,
        doc_id: str,
        inspection,
        document_category: str,
        extension: str,
    ) -> None:
        """
        General unstructured document pipeline:
        1. Parse document depending on type (TXT, PPT, Generic Excel sheets)
        2. Split into markdown sections
        3. Embed sections
        4. Index in Elasticsearch
        """
        if extension in (".txt", ".csv"):
            content = parse_txt_to_string(str(file_path))
        elif extension == ".docx":
            content = parse_docx_to_string(str(file_path))
        elif extension in (".ppt", ".pptx"):
            slides = parse_pptx_to_markdown_slides(str(file_path))
            content = "\n\n\n".join(slides)
        elif extension in (".xlsx", ".xls"):
            sheets = parse_generic_excel_to_markdown(str(file_path))
            content = "\n\n\n".join(sheets)
        else:
            logger.warning("No parser defined for extension '%s'. Skipping text content extraction.", extension)
            return

        if not content.strip():
            logger.warning("Empty content extracted from file: %s", file_path)
            return

        # Split content into sections
        sections = split_into_sections(content)
        if not sections:
            # Fallback to single chunk
            sections = [content]

        folder_meta = self._extract_folder_metadata(str(file_path), inspection)
        entity_short = folder_meta.get("entity_short_code") or \
            self._extract_entity_short_code_from_path(str(file_path))

        es_documents: list[dict] = []

        for index, section_content in enumerate(sections):
            vector = self._embedding.generate(section_content)

            es_doc = {
                EsFields.DOC_ID: doc_id,
                EsFields.INSP_ID: inspection.insp_id,
                EsFields.DEPT_ID: inspection.dept_id,
                EsFields.INSP_CODE: folder_meta.get("insp_code", ""),
                EsFields.DEPT_CODE: folder_meta.get("dept_code", ""),
                EsFields.ENTITY_SHORT_CODE: entity_short,
                EsFields.ENTITY_NAME: inspection.entity_name,
                EsFields.REPORT_YEAR: inspection.evaluation_year,
                EsFields.SOURCE_FILE: folder_meta.get("source_file", ""),
                EsFields.SOURCE_SUBFOLDER: folder_meta.get("source_subfolder", ""),
                EsFields.DOCUMENT_TYPE: DocumentType.PDF, # Generic text index
                EsFields.DOCUMENT_CATEGORY: document_category,
                EsFields.FILE_EXTENSION: extension,
                EsFields.SECTION_INDEX: index,
                EsFields.TEXT_CONTENT: section_content,
                EsFields.CONTENT_VECTOR: vector,
            }
            es_documents.append(es_doc)

        # Bulk index sections
        if es_documents:
            self._es_client.bulk_index(es_documents)
            logger.info(
                "Indexed %d sections of format '%s' for doc_id=%s",
                len(es_documents),
                extension,
                doc_id,
            )

