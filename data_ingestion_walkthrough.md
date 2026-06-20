# SAMVAD Data Ingestion Pipeline Architecture

This document provides a comprehensive, minute-detail breakdown of how your data ingestion pipeline processes raw files, extracts text and metadata, generates semantic vectors, and indexes them into Elasticsearch and Oracle databases.

## 1. High-Level Folder Structure & Trigger Mechanism

The ingestion pipeline is designed to recursively scan a parent directory and logically map files to specific `DocumentCategories` based on their containing folder name.

> [!TIP]
> **Folder Mapping Strategy**
> The orchestrator (`IngestionOrchestrator`) identifies the purpose of a document strictly based on the name of the folder it sits inside.

When you trigger `process_directory(path)`, the pipeline checks if the directory itself matches an inspection reference code in the Oracle database. If it doesn't, it does a deep recursive scan (`rglob("*")`) looking for subdirectories that match the Oracle `inspection_master` records.

Inside a valid inspection folder, files are categorized by subfolder names:
- `inspection_reports` → `INSPECTION_REPORT`
- `letters` → `LETTER`
- `proof` / `proofs` → `PROOF`
- `kri` → `KRI`
- `compliance_reports` / `compliance_report` → `COMPLIANCE_REPORT`
- `alerts_and_advisories` / `alerts_advisory` → `ALERT_ADVISORY`

If a file exists loosely in the inspection root directory, it natively falls back to being classified as `PROOF`.

---

## 2. Global Pipeline Lifecycle

For every supported file (`.pdf`, `.xlsx`, `.csv`, `.txt`, `.docx`, `.ppt`, `.pptx`), the following lifecycle occurs in `process_single_file`:

1. **Job Tracking Registration:**
   An entry is immediately created in the Oracle `ingestion_jobs` table with a status of `PROCESSING`.
2. **Oracle Metadata Insertion:**
   A UUID is generated (`doc_id`), and document metadata (such as file size, inspection ID, department ID, and category) is stored in Oracle via `insert_document_metadata`.
3. **Dedicated Processing Route:**
   The file is sent to a specific processor class based on its format and category.
4. **Job Tracking Finalization:**
   Upon successful vectorization and Elasticsearch indexing, the job status updates to `SUCCESS`. If it fails, the traceback is stored in Oracle under `error_log` and status updates to `FAILED`.

---

## 3. Dedicated Parsers & Workflows

### A. The PDF Pipeline (VLM extraction)
*Applies to `.pdf` files.*

PDF extraction in SAMVAD is state-of-the-art, bypassing traditional flawed text parsers.
1. **Rendering:** `extract_pages_as_base64` renders PDF pages into high-DPI images.
2. **NuMarkdown Conversion:** The VLM (Vision Language Model) via `AphroditeClient` views the images and converts them flawlessly into Markdown, preserving tables, charts, and hierarchical structures (`convert_pages_to_markdown`).
3. **Metadata Extraction:** The LLM scans the first page's markdown to extract the precise `entity_name` and `evaluation_year`.
4. **Chunking:** `split_into_sections()` divides the markdown into logical semantic chunks.
5. **Embedding:** Each chunk is passed through the `EmbeddingProvider` to generate a 384-dimensional vector.

### B. Structured Excel Pipeline (KRI & Compliance)
*Applies to `.xlsx` files sitting in `kri` or `compliance_reports` folders.*

Instead of blindly dumping Excel data into text chunks, SAMVAD treats them as structured datasets:
1. **KRI Questionnaires (`_process_kri_questionnaire`):** Parses rows natively. Maps Questions and Answers together to create a localized `text_content` context string.
2. **Compliance Reports (`_process_compliance_excel`):** Extracts columns, observations, and bank replies, combining them into unified semantic observations.
3. **Row-by-Row Vectorization:** Rather than chunking an Excel sheet randomly, *every individual observation row* receives its own vector embedding, ensuring highly accurate RAG retrieval.

### C. Unstructured Text Documents
*Applies to `.txt`, `.csv`, `.docx`, `.pptx`, and generic Excel sheets.*

- **PowerPoint:** `parse_pptx_to_markdown_slides` converts slides into Markdown headers and bullet points.
- **Word/TXT:** Parsed line-by-line into strings.
- **Generic Excel (e.g., Proofs):** `parse_generic_excel_to_markdown` converts the tables into markdown-formatted pipes (`| Column A | Column B |`).

All of these are passed through `split_into_sections()` to generate logically divided chunks before embedding.

---

## 4. Embedding Generation

Before any text enters Elasticsearch, it must be vectorized.

> [!NOTE]
> **Embedding Architecture**
> The `EmbeddingProvider` uses `nomic-embed-text-v1.5` architecture natively, loaded locally via ONNX CPU-execution or via API. 

When `embedder.generate(text_content)` is called:
1. It prepends the instruction `"search_document: "` to the text to align with Nomic's contrastive learning training set.
2. It generates the high-dimensional hidden state vector.
3. It applies **Matryoshka Truncation**, cleanly slicing the vector down to exactly **384 dimensions**.
4. Finally, it applies L2 Normalization (`truncated / norm`) so that simple dot-product calculations in Elasticsearch perfectly equal Cosine Similarity!

---

## 5. Elasticsearch Index Mapping

Whether parsing DBIE schema rules or Regulatory Unstructured findings, SAMVAD uses a highly optimized Elasticsearch 8.x schema.

### Standard Vector Mapping
Your index relies heavily on native kNN search architectures.

```json
{
  "mappings": {
    "properties": {
      "entity_name": {"type": "keyword"},
      "dept_id": {"type": "integer"},
      "report_year": {"type": "integer"},
      "document_category": {"type": "keyword"},
      
      "text_content": {
        "type": "text",
        "analyzer": "standard"
      },
      
      "content_vector": {
        "type": "dense_vector",
        "dims": 384,
        "index": true,
        "similarity": "cosine",
        "index_options": {
          "type": "int8_hnsw",
          "m": 16,
          "ef_construction": 100
        }
      }
    }
  }
}
```

> [!IMPORTANT]
> **Vector Search Optimization**
> You are using `int8_hnsw` (Hierarchical Navigable Small World) indexing for the `content_vector`. This means Elasticsearch quantizes the 32-bit floats into 8-bit integers (`int8`), drastically reducing RAM consumption by 75% while maintaining 99% of semantic search accuracy. 

### Final RAG Search (`search_regulatory_vectors`)
When a user asks a question, the Agent generates a query vector for the prompt and hits the index. We implemented a **Hybrid Search** using a `script_score` query. 

It guarantees:
1. **Keyword Match:** Looks for identical words in `text_content` or `entity_name`.
2. **Semantic Match:** Adds the calculated `cosineSimilarity` using the dense vector.
3. **RBAC Filtering:** Hard-filters results out if the `dept_id` does not match the logged-in user's department ID.
