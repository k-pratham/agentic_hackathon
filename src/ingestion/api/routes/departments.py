"""
Department CRUD API routes.

Provides REST endpoints for managing the department_master table.
"""

import logging

from fastapi import APIRouter, HTTPException, status

from ingestion.api.schemas import (
    DepartmentCreate,
    DepartmentUpdate,
    DepartmentResponse,
    MessageResponse,
)
from ingestion.db.repository import IngestionRepository

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/departments", tags=["Departments"])

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
    response_model=DepartmentResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_department(body: DepartmentCreate):
    """Create a new department."""
    repo = _get_repo()
    try:
        dept_id = repo.create_department(body.dept_name)
        dept = repo.get_department(dept_id)
        logger.info("Created department: %d — %s", dept_id, body.dept_name)
        return dept
    except Exception as e:
        logger.error("Failed to create department: %s", e)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e),
        )


@router.get("", response_model=list[DepartmentResponse])
def list_departments():
    """List all departments."""
    repo = _get_repo()
    return repo.list_departments()


@router.get("/{dept_id}", response_model=DepartmentResponse)
def get_department(dept_id: int):
    """Get a department by ID."""
    repo = _get_repo()
    dept = repo.get_department(dept_id)
    if dept is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Department {dept_id} not found",
        )
    return dept


@router.put("/{dept_id}", response_model=DepartmentResponse)
def update_department(dept_id: int, body: DepartmentUpdate):
    """Update a department."""
    repo = _get_repo()
    updated = repo.update_department(dept_id, body.dept_name)
    if not updated:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Department {dept_id} not found",
        )
    return repo.get_department(dept_id)


@router.delete("/{dept_id}", response_model=MessageResponse)
def delete_department(dept_id: int):
    """Delete a department."""
    repo = _get_repo()
    deleted = repo.delete_department(dept_id)
    if not deleted:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Department {dept_id} not found",
        )
    return MessageResponse(message=f"Department {dept_id} deleted successfully")
