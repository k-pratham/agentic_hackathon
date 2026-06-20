"""
Elasticsearch client — document indexing and index management.

Provides methods for:
  - Single document indexing
  - Bulk document indexing
  - Index creation with mapping (if not exists)
"""

import json
import logging

import httpx

from ingestion.config.settings import ElasticsearchSettings
from ingestion.db.constants import EsFields

logger = logging.getLogger(__name__)

# Index mapping matching the architecture specification
INDEX_MAPPING = {
    "settings": {
        "index.knn": True,
        "number_of_shards": 1,
        "number_of_replicas": 0,
        "index.refresh_interval": "30s",
    },
    "mappings": {
        "properties": {
            EsFields.DOC_ID: {"type": "keyword"},
            EsFields.INSP_ID: {"type": "integer"},
            EsFields.DEPT_ID: {"type": "integer"},
            EsFields.INSP_CODE: {"type": "keyword"},
            EsFields.DEPT_CODE: {"type": "keyword"},
            EsFields.ENTITY_SHORT_CODE: {"type": "keyword"},
            EsFields.ENTITY_NAME: {"type": "keyword"},
            EsFields.ENTITY_TYPE: {"type": "keyword"},
            EsFields.INSPECTION_REF: {"type": "keyword"},
            EsFields.EXAMINATION_DATES: {"type": "keyword"},
            EsFields.REPORT_YEAR: {"type": "integer"},
            EsFields.SOURCE_FILE: {"type": "keyword"},
            EsFields.SOURCE_SUBFOLDER: {"type": "keyword"},
            EsFields.DOCUMENT_TYPE: {"type": "keyword"},
            EsFields.DOCUMENT_CATEGORY: {"type": "keyword"},
            EsFields.FILE_EXTENSION: {"type": "keyword"},

            EsFields.DOMAIN_NAME: {"type": "keyword"},
            EsFields.DOMAIN_INDEX: {"type": "integer"},
            EsFields.SECTION_INDEX: {"type": "integer"},
            EsFields.SECTION_HEADING: {"type": "keyword"},

            EsFields.OBSERVATION_ID: {"type": "keyword"},
            EsFields.PARA_ID: {"type": "keyword"},
            EsFields.OBSERVATION_TEXT: {
                "type": "text",
                "analyzer": "standard",
                "fields": {
                    "keyword": {"type": "keyword"}
                }
            },

            EsFields.COMPLIANCE_STATUS: {"type": "keyword"},
            EsFields.SE_STATUS: {"type": "keyword"},
            EsFields.ACTUAL_DUE_DATE: {"type": "date", "format": "dd/MM/yyyy"},
            EsFields.EXTENDED_DUE_DATE: {"type": "date", "format": "dd/MM/yyyy"},
            EsFields.RESPONSE_TYPE: {"type": "keyword"},
            EsFields.IS_RESUBMISSION_REQUIRED: {"type": "boolean"},

            EsFields.ANNEX_TYPE: {"type": "keyword"},
            EsFields.PREVIOUS_AUDIT_REF: {"type": "keyword"},
            EsFields.PREVIOUS_FINDING_AREA: {"type": "keyword"},
            EsFields.PREVIOUS_FINDING_TEXT: {"type": "text"},
            EsFields.PREVIOUS_STATUS: {"type": "keyword"},

            EsFields.ADVISORY_REF: {"type": "keyword"},
            EsFields.ADVISORY_ISSUED_DATE: {"type": "date", "format": "dd-MMM-yy"},
            EsFields.ADVISORY_SUBJECT: {"type": "text"},
            EsFields.ADVISORY_STATUS: {"type": "keyword"},

            EsFields.DPSC_PARA_REF: {"type": "keyword"},
            EsFields.DPSC_REQUIREMENT: {"type": "text"},
            EsFields.DPSC_STATUS: {"type": "keyword"},

            EsFields.TABLE_ROW_INDEX: {"type": "integer"},

            EsFields.TEXT_CONTENT: {
                "type": "text",
                "analyzer": "standard",
            },
            EsFields.CONTENT_VECTOR: {
                "type": "dense_vector",
                "dims": 384,
                "index": True,
                "similarity": "cosine",
                "index_options": {
                    "type": "int8_hnsw",
                    "m": 16,
                    "ef_construction": 100,
                },
            },
        }
    },
}


class ElasticsearchClient:
    """
    Client for Elasticsearch document indexing operations.

    Handles authentication, index management, and document ingestion.
    """

    def __init__(self, settings: ElasticsearchSettings, timeout: int = 30):
        self._settings = settings
        self._base_url = f"{settings.host.rstrip('/')}:{settings.port}"
        self._index = settings.index

        auth = None
        if settings.user and settings.password:
            auth = (settings.user, settings.password)

        self._client = httpx.Client(
            timeout=httpx.Timeout(float(timeout)),
            auth=auth,
            verify=settings.use_ssl,
        )

    # -----------------------------------------------------------------------
    # Index Management
    # -----------------------------------------------------------------------

    def ensure_index_exists(self) -> None:
        """
        Create the Elasticsearch index with the production mapping
        if it does not already exist.
        """
        url = f"{self._base_url}/{self._index}"

        # Check if index exists
        response = self._client.head(url)
        if response.status_code == 200:
            logger.info("Elasticsearch index '%s' already exists", self._index)
            return

        # Create index with mapping
        response = self._client.put(url, json=INDEX_MAPPING)
        if response.status_code in (200, 201):
            logger.info("Created Elasticsearch index '%s'", self._index)
        else:
            logger.error(
                "Failed to create index '%s': %s %s",
                self._index,
                response.status_code,
                response.text,
            )
            response.raise_for_status()

    # -----------------------------------------------------------------------
    # Document Indexing
    # -----------------------------------------------------------------------

    def index_document(self, doc_payload: dict) -> None:
        """
        Index a single section document into Elasticsearch.

        Args:
            doc_payload: Document body matching the index mapping schema.
        """
        url = f"{self._base_url}/{self._index}/_doc"

        response = self._client.post(url, json=doc_payload)
        if response.status_code not in (200, 201):
            logger.error(
                "Failed to index document: %s %s",
                response.status_code,
                response.text,
            )
            response.raise_for_status()

        logger.debug(
            "Indexed section %d for doc_id=%s",
            doc_payload.get("section_index", -1),
            doc_payload.get("doc_id", "unknown"),
        )

    def bulk_index(self, documents: list[dict]) -> int:
        """
        Bulk index multiple section documents into Elasticsearch.

        Uses the Elasticsearch _bulk API for efficient batch ingestion.

        Args:
            documents: List of document bodies matching the index mapping.

        Returns:
            Number of successfully indexed documents.
        """
        if not documents:
            return 0

        # Build NDJSON bulk payload
        bulk_lines = []
        for doc in documents:
            action = {"index": {"_index": self._index}}
            bulk_lines.append(json.dumps(action))
            bulk_lines.append(json.dumps(doc))

        bulk_body = "\n".join(bulk_lines) + "\n"

        url = f"{self._base_url}/_bulk"
        response = self._client.post(
            url,
            content=bulk_body,
            headers={"Content-Type": "application/x-ndjson"},
        )
        response.raise_for_status()

        result = response.json()
        error_count = sum(
            1 for item in result.get("items", [])
            if item.get("index", {}).get("error")
        )
        success_count = len(documents) - error_count

        if error_count > 0:
            logger.warning(
                "Bulk index: %d succeeded, %d failed", success_count, error_count
            )
        else:
            logger.info("Bulk indexed %d documents", success_count)

        return success_count

    # -----------------------------------------------------------------------
    # Lifecycle
    # -----------------------------------------------------------------------

    def close(self) -> None:
        """Close the underlying HTTP client."""
        self._client.close()
        logger.debug("Elasticsearch client closed")
