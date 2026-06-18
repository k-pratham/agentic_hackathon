"""
Centralized database and Elasticsearch schema constants.

Single source of truth for all table names, column names, and
Elasticsearch field names used across the application.
"""


# =============================================================================
# Oracle Database — Table Names
# =============================================================================

class Tables:
    """Oracle table names."""

    DEPARTMENT_MASTER = "department_master"
    PERSON_MASTER = "person_master"
    INSPECTION_MASTER = "inspection_master"
    INGESTION_JOBS = "ingestion_jobs"
    DOCUMENT_METADATA = "document_metadata"
    KRI_DATA = "kri_data"


# =============================================================================
# Oracle Database — Column Names (per table)
# =============================================================================

class DepartmentColumns:
    """Columns for department_master table."""

    DEPT_ID = "dept_id"
    DEPT_NAME = "dept_name"
    CREATED_AT = "created_at"

    ALL = [DEPT_ID, DEPT_NAME, CREATED_AT]


class PersonColumns:
    """Columns for person_master table."""

    PERSON_ID = "person_id"
    PERSON_NAME = "person_name"
    PERSON_EMAIL = "person_email"
    DEPT_ID = "dept_id"
    IS_ACTIVE = "is_active"
    CREATED_AT = "created_at"

    ALL = [PERSON_ID, PERSON_NAME, PERSON_EMAIL, DEPT_ID, IS_ACTIVE, CREATED_AT]


class InspectionColumns:
    """Columns for inspection_master table."""

    INSP_ID = "insp_id"
    INSP_REFERENCE_CODE = "insp_reference_code"
    DEPT_ID = "dept_id"
    ENTITY_NAME = "entity_name"
    EVALUATION_YEAR = "evaluation_year"
    EVALUATION_DATE = "evaluation_date"
    CREATED_AT = "created_at"

    ALL = [INSP_ID, INSP_REFERENCE_CODE, DEPT_ID, ENTITY_NAME,
           EVALUATION_YEAR, EVALUATION_DATE, CREATED_AT]


class JobColumns:
    """Columns for ingestion_jobs table."""

    JOB_ID = "job_id"
    FILENAME = "filename"
    FILE_SIZE_BYTES = "file_size_bytes"
    STATUS = "status"
    ERROR_LOG = "error_log"
    STARTED_AT = "started_at"
    COMPLETED_AT = "completed_at"
    CREATED_AT = "created_at"


class DocumentColumns:
    """Columns for document_metadata table."""

    DOC_ID = "doc_id"
    JOB_ID = "job_id"
    INSP_ID = "insp_id"
    DEPT_ID = "dept_id"
    DOCUMENT_TYPE = "document_type"
    DOCUMENT_CATEGORY = "document_category"
    FILE_EXTENSION = "file_extension"
    STORAGE_PATH = "storage_path"
    UPLOADED_AT = "uploaded_at"



class KriColumns:
    """Columns for kri_data table."""

    KRI_ID = "kri_id"
    DOC_ID = "doc_id"
    INDICATOR_CODE = "indicator_code"
    INDICATOR_NAME = "indicator_name"
    ACTUAL_VALUE = "actual_value"
    THRESHOLD_LIMIT = "threshold_limit"
    BREACH_FLAG = "breach_flag"
    REPORT_DATE = "report_date"


# =============================================================================
# Job Status Values
# =============================================================================

class JobStatus:
    """Valid status values for ingestion_jobs.status."""

    PENDING = "PENDING"
    PROCESSING = "PROCESSING"
    SUCCESS = "SUCCESS"
    FAILED = "FAILED"


# =============================================================================
# Document Type Values
# =============================================================================

class DocumentType:
    """Supported document type identifiers."""

    PDF = "PDF"
    EXCEL = "EXCEL"


# =============================================================================
# Document Category Values
# =============================================================================

class DocumentCategory:
    """Standard document categories based on subfolder structure."""

    INSPECTION_REPORT = "INSPECTION_REPORT"
    LETTER = "LETTER"
    PROOF = "PROOF"
    KRI = "KRI"
    COMPLIANCE_REPORT = "COMPLIANCE_REPORT"
    ALERT_ADVISORY = "ALERT_ADVISORY"


# =============================================================================
# Elasticsearch — Field Names
# =============================================================================

class EsFields:
    """Elasticsearch index field names for regulatory_documents_index."""

    DOC_ID = "doc_id"
    INSP_ID = "insp_id"
    DEPT_ID = "dept_id"
    DOCUMENT_TYPE = "document_type"
    DOCUMENT_CATEGORY = "document_category"
    FILE_EXTENSION = "file_extension"
    ENTITY_NAME = "entity_name"
    REPORT_YEAR = "report_year"
    SECTION_INDEX = "section_index"
    TEXT_CONTENT = "text_content"
    CONTENT_VECTOR = "content_vector"

