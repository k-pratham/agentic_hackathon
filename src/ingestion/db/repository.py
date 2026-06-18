"""
Data access repository — Oracle database operations.

Provides typed methods for all database interactions:
  - Ingestion job lifecycle (create, update status)
  - Inspection lookup by reference code
  - Document metadata insertion
  - KRI data batch insertion
  - Master table CRUD (departments, persons, inspections)

All table and column names are referenced from db.constants.
"""

import logging
from datetime import datetime
from typing import Any

from ingestion.db.connection import OracleConnectionPool
from ingestion.db.constants import (
    Tables,
    DepartmentColumns,
    PersonColumns,
    InspectionColumns,
    JobColumns,
    DocumentColumns,
    KriColumns,
    JobStatus,
)

logger = logging.getLogger(__name__)


# ---------------------------------------------------------------------------
# Data classes for return types
# ---------------------------------------------------------------------------

class InspectionRecord:
    """Represents a row from inspection_master."""

    def __init__(self, insp_id: int, dept_id: int, entity_name: str,
                 evaluation_year: int, insp_reference_code: str):
        self.insp_id = insp_id
        self.dept_id = dept_id
        self.entity_name = entity_name
        self.evaluation_year = evaluation_year
        self.insp_reference_code = insp_reference_code


# ---------------------------------------------------------------------------
# Repository class
# ---------------------------------------------------------------------------

class IngestionRepository:
    """
    Data access layer for the ingestion pipeline.

    All methods acquire connections from the pool internally.
    """

    def __init__(self, pool: OracleConnectionPool):
        self._pool = pool

    # -----------------------------------------------------------------------
    # Ingestion Jobs
    # -----------------------------------------------------------------------

    def create_ingestion_job(self, filename: str, file_size_bytes: int) -> int:
        """
        Create a new ingestion job record with PENDING status.

        Returns:
            The generated job_id.
        """
        sql = f"""
            INSERT INTO {Tables.INGESTION_JOBS}
                ({JobColumns.FILENAME}, {JobColumns.FILE_SIZE_BYTES}, {JobColumns.STATUS})
            VALUES (:filename, :file_size, '{JobStatus.PENDING}')
            RETURNING {JobColumns.JOB_ID} INTO :job_id
        """
        with self._pool.connection() as conn:
            with conn.cursor() as cur:
                job_id_var = cur.var(int)
                cur.execute(sql, {
                    "filename": filename,
                    "file_size": file_size_bytes,
                    "job_id": job_id_var,
                })
                job_id = job_id_var.getvalue()[0]

        logger.info("Created ingestion job %d for file: %s", job_id, filename)
        return job_id

    def update_job_status(
        self, job_id: int, status: str, error_log: str | None = None
    ) -> None:
        """
        Update the status of an ingestion job.

        Args:
            job_id: The job identifier.
            status: New status (PENDING, PROCESSING, SUCCESS, FAILED).
            error_log: Optional error message for FAILED status.
        """
        t = Tables.INGESTION_JOBS
        jc = JobColumns

        if status == JobStatus.PROCESSING:
            sql = f"""
                UPDATE {t}
                SET {jc.STATUS} = :status, {jc.STARTED_AT} = CURRENT_TIMESTAMP
                WHERE {jc.JOB_ID} = :job_id
            """
            params: dict[str, Any] = {"status": status, "job_id": job_id}
        elif status in (JobStatus.SUCCESS, JobStatus.FAILED):
            sql = f"""
                UPDATE {t}
                SET {jc.STATUS} = :status, {jc.ERROR_LOG} = :error_log,
                    {jc.COMPLETED_AT} = CURRENT_TIMESTAMP
                WHERE {jc.JOB_ID} = :job_id
            """
            params = {
                "status": status,
                "error_log": error_log,
                "job_id": job_id,
            }
        else:
            sql = f"""
                UPDATE {t}
                SET {jc.STATUS} = :status
                WHERE {jc.JOB_ID} = :job_id
            """
            params = {"status": status, "job_id": job_id}

        with self._pool.connection() as conn:
            with conn.cursor() as cur:
                cur.execute(sql, params)

        logger.info("Job %d status updated to %s", job_id, status)

    # -----------------------------------------------------------------------
    # Inspection Lookup
    # -----------------------------------------------------------------------

    def lookup_inspection(self, insp_reference_code: str) -> InspectionRecord | None:
        """
        Look up an inspection by its reference code.

        Args:
            insp_reference_code: The human-readable inspection code (folder name).

        Returns:
            InspectionRecord if found, None otherwise.
        """
        ic = InspectionColumns
        sql = f"""
            SELECT {ic.INSP_ID}, {ic.DEPT_ID}, {ic.ENTITY_NAME},
                   {ic.EVALUATION_YEAR}, {ic.INSP_REFERENCE_CODE}
            FROM {Tables.INSPECTION_MASTER}
            WHERE {ic.INSP_REFERENCE_CODE} = :ref_code
        """
        with self._pool.connection() as conn:
            with conn.cursor() as cur:
                cur.execute(sql, {"ref_code": insp_reference_code})
                row = cur.fetchone()

        if row is None:
            logger.warning(
                "No inspection found for reference code: %s", insp_reference_code
            )
            return None

        return InspectionRecord(
            insp_id=row[0],
            dept_id=row[1],
            entity_name=row[2],
            evaluation_year=row[3],
            insp_reference_code=row[4],
        )

    # -----------------------------------------------------------------------
    # Document Metadata
    # -----------------------------------------------------------------------

    def insert_document_metadata(
        self,
        job_id: int,
        insp_id: int,
        dept_id: int,
        document_type: str,
        document_category: str,
        file_extension: str,
        storage_path: str,
    ) -> str:
        """
        Insert a document metadata record.

        The doc_id is auto-generated by Oracle as a UUID.

        Returns:
            The generated doc_id (UUID string).
        """
        dc = DocumentColumns
        sql = f"""
            INSERT INTO {Tables.DOCUMENT_METADATA}
                ({dc.JOB_ID}, {dc.INSP_ID}, {dc.DEPT_ID},
                 {dc.DOCUMENT_TYPE}, {dc.DOCUMENT_CATEGORY},
                 {dc.FILE_EXTENSION}, {dc.STORAGE_PATH})
            VALUES
                (:job_id, :insp_id, :dept_id, :doc_type, :doc_category,
                 :file_ext, :storage_path)
            RETURNING {dc.DOC_ID} INTO :doc_id
        """
        with self._pool.connection() as conn:
            with conn.cursor() as cur:
                doc_id_var = cur.var(str)
                cur.execute(sql, {
                    "job_id": job_id,
                    "insp_id": insp_id,
                    "dept_id": dept_id,
                    "doc_type": document_type,
                    "doc_category": document_category,
                    "file_ext": file_extension,
                    "storage_path": storage_path,
                    "doc_id": doc_id_var,
                })
                doc_id = doc_id_var.getvalue()[0]

        logger.info("Inserted document metadata — doc_id=%s", doc_id)
        return doc_id

    # -----------------------------------------------------------------------
    # KRI Data (Excel)
    # -----------------------------------------------------------------------

    def insert_kri_batch(self, doc_id: str, kri_records: list[dict]) -> int:
        """
        Batch insert KRI records for a document.

        Args:
            doc_id: The document ID this KRI data belongs to.
            kri_records: List of dicts with keys:
                indicator_code, indicator_name, actual_value,
                threshold_limit, report_date

        Returns:
            Number of records inserted.
        """
        if not kri_records:
            return 0

        kc = KriColumns
        sql = f"""
            INSERT INTO {Tables.KRI_DATA}
                ({kc.DOC_ID}, {kc.INDICATOR_CODE}, {kc.INDICATOR_NAME},
                 {kc.ACTUAL_VALUE}, {kc.THRESHOLD_LIMIT}, {kc.REPORT_DATE})
            VALUES
                (:doc_id, :indicator_code, :indicator_name,
                 :actual_value, :threshold_limit, :report_date)
        """
        rows = []
        for record in kri_records:
            rows.append({
                "doc_id": doc_id,
                "indicator_code": record["indicator_code"],
                "indicator_name": record["indicator_name"],
                "actual_value": record["actual_value"],
                "threshold_limit": record.get("threshold_limit"),
                "report_date": record["report_date"],
            })

        with self._pool.connection() as conn:
            with conn.cursor() as cur:
                cur.executemany(sql, rows)

        logger.info(
            "Inserted %d KRI records for doc_id=%s", len(rows), doc_id
        )
        return len(rows)

    # -----------------------------------------------------------------------
    # Master Data CRUD — Departments
    # -----------------------------------------------------------------------

    def create_department(self, dept_name: str) -> int:
        """Create a department and return the generated dept_id."""
        dc = DepartmentColumns
        sql = f"""
            INSERT INTO {Tables.DEPARTMENT_MASTER} ({dc.DEPT_NAME})
            VALUES (:dept_name)
            RETURNING {dc.DEPT_ID} INTO :dept_id
        """
        with self._pool.connection() as conn:
            with conn.cursor() as cur:
                dept_id_var = cur.var(int)
                cur.execute(sql, {"dept_name": dept_name, "dept_id": dept_id_var})
                return dept_id_var.getvalue()[0]

    def list_departments(self) -> list[dict]:
        """List all departments."""
        dc = DepartmentColumns
        cols = ", ".join(dc.ALL)
        sql = f"SELECT {cols} FROM {Tables.DEPARTMENT_MASTER} ORDER BY {dc.DEPT_ID}"
        with self._pool.connection() as conn:
            with conn.cursor() as cur:
                cur.execute(sql)
                columns = [col[0].lower() for col in cur.description]
                return [dict(zip(columns, row)) for row in cur.fetchall()]

    def get_department(self, dept_id: int) -> dict | None:
        """Get a single department by ID."""
        dc = DepartmentColumns
        cols = ", ".join(dc.ALL)
        sql = f"SELECT {cols} FROM {Tables.DEPARTMENT_MASTER} WHERE {dc.DEPT_ID} = :dept_id"
        with self._pool.connection() as conn:
            with conn.cursor() as cur:
                cur.execute(sql, {"dept_id": dept_id})
                row = cur.fetchone()
                if row is None:
                    return None
                columns = [col[0].lower() for col in cur.description]
                return dict(zip(columns, row))

    def update_department(self, dept_id: int, dept_name: str) -> bool:
        """Update a department name. Returns True if a row was updated."""
        dc = DepartmentColumns
        sql = (
            f"UPDATE {Tables.DEPARTMENT_MASTER} "
            f"SET {dc.DEPT_NAME} = :dept_name "
            f"WHERE {dc.DEPT_ID} = :dept_id"
        )
        with self._pool.connection() as conn:
            with conn.cursor() as cur:
                cur.execute(sql, {"dept_name": dept_name, "dept_id": dept_id})
                return cur.rowcount > 0

    def delete_department(self, dept_id: int) -> bool:
        """Delete a department. Returns True if a row was deleted."""
        dc = DepartmentColumns
        sql = f"DELETE FROM {Tables.DEPARTMENT_MASTER} WHERE {dc.DEPT_ID} = :dept_id"
        with self._pool.connection() as conn:
            with conn.cursor() as cur:
                cur.execute(sql, {"dept_id": dept_id})
                return cur.rowcount > 0

    # -----------------------------------------------------------------------
    # Master Data CRUD — Persons
    # -----------------------------------------------------------------------

    def create_person(
        self, person_name: str, person_email: str, dept_id: int
    ) -> int:
        """Create a person and return the generated person_id."""
        pc = PersonColumns
        sql = f"""
            INSERT INTO {Tables.PERSON_MASTER}
                ({pc.PERSON_NAME}, {pc.PERSON_EMAIL}, {pc.DEPT_ID})
            VALUES (:person_name, :person_email, :dept_id)
            RETURNING {pc.PERSON_ID} INTO :person_id
        """
        with self._pool.connection() as conn:
            with conn.cursor() as cur:
                person_id_var = cur.var(int)
                cur.execute(sql, {
                    "person_name": person_name,
                    "person_email": person_email,
                    "dept_id": dept_id,
                    "person_id": person_id_var,
                })
                return person_id_var.getvalue()[0]

    def list_persons(self) -> list[dict]:
        """List all persons."""
        pc = PersonColumns
        cols = ", ".join(pc.ALL)
        sql = f"SELECT {cols} FROM {Tables.PERSON_MASTER} ORDER BY {pc.PERSON_ID}"
        with self._pool.connection() as conn:
            with conn.cursor() as cur:
                cur.execute(sql)
                columns = [col[0].lower() for col in cur.description]
                return [dict(zip(columns, row)) for row in cur.fetchall()]

    def get_person(self, person_id: int) -> dict | None:
        """Get a single person by ID."""
        pc = PersonColumns
        cols = ", ".join(pc.ALL)
        sql = f"SELECT {cols} FROM {Tables.PERSON_MASTER} WHERE {pc.PERSON_ID} = :person_id"
        with self._pool.connection() as conn:
            with conn.cursor() as cur:
                cur.execute(sql, {"person_id": person_id})
                row = cur.fetchone()
                if row is None:
                    return None
                columns = [col[0].lower() for col in cur.description]
                return dict(zip(columns, row))

    def update_person(
        self, person_id: int, person_name: str | None = None,
        person_email: str | None = None, dept_id: int | None = None,
        is_active: int | None = None,
    ) -> bool:
        """Update person fields. Only non-None fields are updated."""
        pc = PersonColumns
        updates = []
        params: dict[str, Any] = {"person_id": person_id}

        if person_name is not None:
            updates.append(f"{pc.PERSON_NAME} = :person_name")
            params["person_name"] = person_name
        if person_email is not None:
            updates.append(f"{pc.PERSON_EMAIL} = :person_email")
            params["person_email"] = person_email
        if dept_id is not None:
            updates.append(f"{pc.DEPT_ID} = :dept_id")
            params["dept_id"] = dept_id
        if is_active is not None:
            updates.append(f"{pc.IS_ACTIVE} = :is_active")
            params["is_active"] = is_active

        if not updates:
            return False

        sql = (
            f"UPDATE {Tables.PERSON_MASTER} "
            f"SET {', '.join(updates)} "
            f"WHERE {pc.PERSON_ID} = :person_id"
        )
        with self._pool.connection() as conn:
            with conn.cursor() as cur:
                cur.execute(sql, params)
                return cur.rowcount > 0

    def delete_person(self, person_id: int) -> bool:
        """Delete a person. Returns True if a row was deleted."""
        pc = PersonColumns
        sql = f"DELETE FROM {Tables.PERSON_MASTER} WHERE {pc.PERSON_ID} = :person_id"
        with self._pool.connection() as conn:
            with conn.cursor() as cur:
                cur.execute(sql, {"person_id": person_id})
                return cur.rowcount > 0

    # -----------------------------------------------------------------------
    # Master Data CRUD — Inspections
    # -----------------------------------------------------------------------

    def create_inspection(
        self,
        insp_reference_code: str,
        dept_id: int,
        entity_name: str,
        evaluation_year: int,
        evaluation_date: datetime,
    ) -> int:
        """Create an inspection and return the generated insp_id."""
        ic = InspectionColumns
        sql = f"""
            INSERT INTO {Tables.INSPECTION_MASTER}
                ({ic.INSP_REFERENCE_CODE}, {ic.DEPT_ID}, {ic.ENTITY_NAME},
                 {ic.EVALUATION_YEAR}, {ic.EVALUATION_DATE})
            VALUES
                (:ref_code, :dept_id, :entity_name,
                 :eval_year, :eval_date)
            RETURNING {ic.INSP_ID} INTO :insp_id
        """
        with self._pool.connection() as conn:
            with conn.cursor() as cur:
                insp_id_var = cur.var(int)
                cur.execute(sql, {
                    "ref_code": insp_reference_code,
                    "dept_id": dept_id,
                    "entity_name": entity_name,
                    "eval_year": evaluation_year,
                    "eval_date": evaluation_date,
                    "insp_id": insp_id_var,
                })
                return insp_id_var.getvalue()[0]

    def list_inspections(self) -> list[dict]:
        """List all inspections."""
        ic = InspectionColumns
        cols = ", ".join(ic.ALL)
        sql = f"SELECT {cols} FROM {Tables.INSPECTION_MASTER} ORDER BY {ic.INSP_ID}"
        with self._pool.connection() as conn:
            with conn.cursor() as cur:
                cur.execute(sql)
                columns = [col[0].lower() for col in cur.description]
                return [dict(zip(columns, row)) for row in cur.fetchall()]

    def get_inspection(self, insp_id: int) -> dict | None:
        """Get a single inspection by ID."""
        ic = InspectionColumns
        cols = ", ".join(ic.ALL)
        sql = f"SELECT {cols} FROM {Tables.INSPECTION_MASTER} WHERE {ic.INSP_ID} = :insp_id"
        with self._pool.connection() as conn:
            with conn.cursor() as cur:
                cur.execute(sql, {"insp_id": insp_id})
                row = cur.fetchone()
                if row is None:
                    return None
                columns = [col[0].lower() for col in cur.description]
                return dict(zip(columns, row))

    def update_inspection(
        self, insp_id: int, entity_name: str | None = None,
        evaluation_year: int | None = None,
        evaluation_date: datetime | None = None,
    ) -> bool:
        """Update inspection fields. Only non-None fields are updated."""
        ic = InspectionColumns
        updates = []
        params: dict[str, Any] = {"insp_id": insp_id}

        if entity_name is not None:
            updates.append(f"{ic.ENTITY_NAME} = :entity_name")
            params["entity_name"] = entity_name
        if evaluation_year is not None:
            updates.append(f"{ic.EVALUATION_YEAR} = :eval_year")
            params["eval_year"] = evaluation_year
        if evaluation_date is not None:
            updates.append(f"{ic.EVALUATION_DATE} = :eval_date")
            params["eval_date"] = evaluation_date

        if not updates:
            return False

        sql = (
            f"UPDATE {Tables.INSPECTION_MASTER} "
            f"SET {', '.join(updates)} "
            f"WHERE {ic.INSP_ID} = :insp_id"
        )
        with self._pool.connection() as conn:
            with conn.cursor() as cur:
                cur.execute(sql, params)
                return cur.rowcount > 0

    def delete_inspection(self, insp_id: int) -> bool:
        """Delete an inspection. Returns True if a row was deleted."""
        ic = InspectionColumns
        sql = f"DELETE FROM {Tables.INSPECTION_MASTER} WHERE {ic.INSP_ID} = :insp_id"
        with self._pool.connection() as conn:
            with conn.cursor() as cur:
                cur.execute(sql, {"insp_id": insp_id})
                return cur.rowcount > 0
