"""
Person CRUD API routes.

Provides REST endpoints for managing the person_master table.
"""

import logging

from fastapi import APIRouter, HTTPException, status

from ingestion.api.schemas import (
    PersonCreate,
    PersonUpdate,
    PersonResponse,
    MessageResponse,
)
from ingestion.db.repository import IngestionRepository

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/persons", tags=["Persons"])

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
    response_model=PersonResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_person(body: PersonCreate):
    """Create a new person."""
    repo = _get_repo()
    try:
        person_id = repo.create_person(
            person_name=body.person_name,
            person_email=body.person_email,
            dept_id=body.dept_id,
        )
        person = repo.get_person(person_id)
        logger.info("Created person: %d — %s", person_id, body.person_name)
        return person
    except Exception as e:
        logger.error("Failed to create person: %s", e)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e),
        )


@router.get("", response_model=list[PersonResponse])
def list_persons():
    """List all persons."""
    repo = _get_repo()
    return repo.list_persons()


@router.get("/{person_id}", response_model=PersonResponse)
def get_person(person_id: int):
    """Get a person by ID."""
    repo = _get_repo()
    person = repo.get_person(person_id)
    if person is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Person {person_id} not found",
        )
    return person


@router.put("/{person_id}", response_model=PersonResponse)
def update_person(person_id: int, body: PersonUpdate):
    """Update a person's fields. Only non-null fields are updated."""
    repo = _get_repo()
    updated = repo.update_person(
        person_id=person_id,
        person_name=body.person_name,
        person_email=body.person_email,
        dept_id=body.dept_id,
        is_active=body.is_active,
    )
    if not updated:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Person {person_id} not found",
        )
    return repo.get_person(person_id)


@router.delete("/{person_id}", response_model=MessageResponse)
def delete_person(person_id: int):
    """Delete a person."""
    repo = _get_repo()
    deleted = repo.delete_person(person_id)
    if not deleted:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Person {person_id} not found",
        )
    return MessageResponse(message=f"Person {person_id} deleted successfully")
