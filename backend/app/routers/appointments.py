from datetime import date
from typing import List, Optional
from fastapi import APIRouter, Depends, Query, status
from sqlalchemy.orm import Session

from app.database import get_db
from app.schemas.appointment import (
    AppointmentCreate,
    AppointmentUpdate,
    AppointmentResponse,
)
from app.services import appointment_service

router = APIRouter(
    prefix="/api/appointments",
    tags=["Appointments"],
)


@router.get(
    "",
    response_model=List[AppointmentResponse],
    status_code=status.HTTP_200_OK,
    summary="Get appointments with optional date and status filters"
)
def get_appointments(
    date: Optional[date] = Query(None, description="Filter appointments by date (YYYY-MM-DD)"),
    status: Optional[str] = Query(None, description="Filter appointments by status (Scheduled, Completed, Cancelled)"),
    db: Session = Depends(get_db),
):
    """Retrieve all appointments, optionally filtered by date and/or status."""
    return appointment_service.get_appointments(db, filter_date=date, filter_status=status)


@router.get(
    "/{appointment_id}",
    response_model=AppointmentResponse,
    status_code=status.HTTP_200_OK,
    summary="Get single appointment by ID"
)
def get_appointment(
    appointment_id: int,
    db: Session = Depends(get_db),
):
    """Retrieve details for a single appointment."""
    return appointment_service.get_appointment_by_id(db, appointment_id=appointment_id)


@router.post(
    "",
    response_model=AppointmentResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create a new appointment"
)
def create_appointment(
    appointment_in: AppointmentCreate,
    db: Session = Depends(get_db),
):
    """
    Create a new appointment.
    Validates:
    - Required fields
    - end_time > start_time (400)
    - Conflict with existing non-cancelled appointments (409)
    """
    return appointment_service.create_appointment(db, appointment_in=appointment_in)


@router.put(
    "/{appointment_id}",
    response_model=AppointmentResponse,
    status_code=status.HTTP_200_OK,
    summary="Update an existing appointment"
)
def update_appointment(
    appointment_id: int,
    appointment_in: AppointmentUpdate,
    db: Session = Depends(get_db),
):
    """
    Update appointment details.
    Validates:
    - Existence (404)
    - end_time > start_time (400)
    - Conflict with existing non-cancelled appointments excluding self (409)
    """
    return appointment_service.update_appointment(
        db, appointment_id=appointment_id, appointment_in=appointment_in
    )


@router.patch(
    "/{appointment_id}/complete",
    response_model=AppointmentResponse,
    status_code=status.HTTP_200_OK,
    summary="Mark appointment as completed"
)
def complete_appointment(
    appointment_id: int,
    db: Session = Depends(get_db),
):
    """
    Mark an appointment as Completed.
    Disallows transitioning a Cancelled appointment to Completed (400).
    """
    return appointment_service.complete_appointment(db, appointment_id=appointment_id)


@router.patch(
    "/{appointment_id}/cancel",
    response_model=AppointmentResponse,
    status_code=status.HTTP_200_OK,
    summary="Cancel an appointment"
)
def cancel_appointment(
    appointment_id: int,
    db: Session = Depends(get_db),
):
    """
    Cancel an appointment.
    Does not delete the record; marks it as Cancelled so it remains visible
    and frees its time slot.
    """
    return appointment_service.cancel_appointment(db, appointment_id=appointment_id)
