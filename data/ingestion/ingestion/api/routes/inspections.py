"""
Inspection CRUD API routes.

Provides REST endpoints for managing the inspection_master table.
"""

import logging

from fastapi import APIRouter, HTTPException, status

from ingestion.api.schemas import (
    InspectionCreate,
    InspectionUpdate,
    InspectionResponse,
    MessageResponse,
)
from ingestion.db.repository import IngestionRepository

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/inspections", tags=["Inspections"])

# Repository instance — set during app startup
_repo: IngestionRepository | None = None


def set_repository(repo: IngestionRepository) -> None:
    """Inject the repository instance (called during app startup)."""
    global _repo
    _repo = repo


def _get_repo() -> IngestionRepository:
    """Get the repository, raising if not initialized."""
    if _repo is None:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Service not initialized",
        )
    return _repo


@router.post(
    "",
    response_model=InspectionResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_inspection(body: InspectionCreate):
    """Create a new inspection record."""
    repo = _get_repo()
    try:
        insp_id = repo.create_inspection(
            insp_reference_code=body.insp_reference_code,
            dept_id=body.dept_id,
            entity_name=body.entity_name,
            evaluation_year=body.evaluation_year,
            evaluation_date=body.evaluation_date,
        )
        inspection = repo.get_inspection(insp_id)
        logger.info(
            "Created inspection: %d — %s", insp_id, body.insp_reference_code
        )
        return inspection
    except Exception as e:
        logger.error("Failed to create inspection: %s", e)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e),
        )


@router.get("", response_model=list[InspectionResponse])
def list_inspections():
    """List all inspections."""
    repo = _get_repo()
    return repo.list_inspections()


@router.get("/{insp_id}", response_model=InspectionResponse)
def get_inspection(insp_id: int):
    """Get an inspection by ID."""
    repo = _get_repo()
    inspection = repo.get_inspection(insp_id)
    if inspection is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Inspection {insp_id} not found",
        )
    return inspection


@router.put("/{insp_id}", response_model=InspectionResponse)
def update_inspection(insp_id: int, body: InspectionUpdate):
    """Update an inspection's fields. Only non-null fields are updated."""
    repo = _get_repo()
    updated = repo.update_inspection(
        insp_id=insp_id,
        entity_name=body.entity_name,
        evaluation_year=body.evaluation_year,
        evaluation_date=body.evaluation_date,
    )
    if not updated:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Inspection {insp_id} not found",
        )
    return repo.get_inspection(insp_id)


@router.delete("/{insp_id}", response_model=MessageResponse)
def delete_inspection(insp_id: int):
    """Delete an inspection."""
    repo = _get_repo()
    deleted = repo.delete_inspection(insp_id)
    if not deleted:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Inspection {insp_id} not found",
        )
    return MessageResponse(message=f"Inspection {insp_id} deleted successfully")
