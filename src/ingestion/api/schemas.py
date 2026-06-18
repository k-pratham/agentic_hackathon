"""
Pydantic request/response schemas for the Admin API.

Defines typed models for all CRUD operations on master tables:
  - Departments
  - Persons
  - Inspections
"""

from datetime import datetime, date
from typing import Optional

from pydantic import BaseModel, Field, EmailStr


# ---------------------------------------------------------------------------
# Department Schemas
# ---------------------------------------------------------------------------

class DepartmentCreate(BaseModel):
    """Request schema for creating a department."""
    dept_name: str = Field(..., min_length=1, max_length=100)


class DepartmentUpdate(BaseModel):
    """Request schema for updating a department."""
    dept_name: str = Field(..., min_length=1, max_length=100)


class DepartmentResponse(BaseModel):
    """Response schema for a department record."""
    dept_id: int
    dept_name: str
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True


# ---------------------------------------------------------------------------
# Person Schemas
# ---------------------------------------------------------------------------

class PersonCreate(BaseModel):
    """Request schema for creating a person."""
    person_name: str = Field(..., min_length=1, max_length=255)
    person_email: str = Field(..., min_length=1, max_length=255)
    dept_id: int


class PersonUpdate(BaseModel):
    """Request schema for updating a person. All fields are optional."""
    person_name: Optional[str] = Field(None, min_length=1, max_length=255)
    person_email: Optional[str] = Field(None, min_length=1, max_length=255)
    dept_id: Optional[int] = None
    is_active: Optional[int] = Field(None, ge=0, le=1)


class PersonResponse(BaseModel):
    """Response schema for a person record."""
    person_id: int
    person_name: str
    person_email: str
    dept_id: int
    is_active: int
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True


# ---------------------------------------------------------------------------
# Inspection Schemas
# ---------------------------------------------------------------------------

class InspectionCreate(BaseModel):
    """Request schema for creating an inspection."""
    insp_reference_code: str = Field(..., min_length=1, max_length=100)
    dept_id: int
    entity_name: str = Field(..., min_length=1, max_length=255)
    evaluation_year: int = Field(..., ge=2000, le=2100)
    evaluation_date: date


class InspectionUpdate(BaseModel):
    """Request schema for updating an inspection. All fields are optional."""
    entity_name: Optional[str] = Field(None, min_length=1, max_length=255)
    evaluation_year: Optional[int] = Field(None, ge=2000, le=2100)
    evaluation_date: Optional[date] = None


class InspectionResponse(BaseModel):
    """Response schema for an inspection record."""
    insp_id: int
    insp_reference_code: str
    dept_id: int
    entity_name: str
    evaluation_year: int
    evaluation_date: Optional[date] = None
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True


# ---------------------------------------------------------------------------
# Generic Response
# ---------------------------------------------------------------------------

class MessageResponse(BaseModel):
    """Generic message response."""
    message: str
    detail: Optional[str] = None
