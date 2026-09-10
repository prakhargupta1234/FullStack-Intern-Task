from datetime import date, time, datetime, timedelta
from typing import List, Optional
from sqlalchemy.orm import Session
from sqlalchemy import and_
from fastapi import HTTPException, status

from app.models.appointment import Appointment, AppointmentStatus
from app.schemas.appointment import AppointmentCreate, AppointmentUpdate


def validate_time_range(start_time: time, end_time: time) -> None:
    """Validate that end_time is strictly after start_time."""
    if end_time <= start_time:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="End time must be after start time."
        )


def check_appointment_conflict(
    db: Session,
    appointment_date: date,
    start_time: time,
    end_time: time,
    exclude_id: Optional[int] = None,
) -> None:
    """
    Check if the requested time slot conflicts with any active (non-cancelled) appointment
    on the specified date.
    
    Conflict logic:
    new_start < existing_end AND new_end > existing_start
    Back-to-back appointments (e.g. 10:00-11:00 and 11:00-12:00) are allowed.
    Only appointments whose status != 'Cancelled' participate.
    """
    query = db.query(Appointment).filter(
        Appointment.date == appointment_date,
        Appointment.status != AppointmentStatus.CANCELLED.value,
        # Overlap condition:
        # existing.start_time < new_end AND existing.end_time > new_start
        and_(
            Appointment.start_time < end_time,
            Appointment.end_time > start_time,
        )
    )

    if exclude_id is not None:
        query = query.filter(Appointment.id != exclude_id)

    conflicting_appointment = query.first()

    if conflicting_appointment:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Selected time slot conflicts with an existing appointment."
        )


def get_appointments(
    db: Session,
    filter_date: Optional[date] = None,
    filter_status: Optional[str] = None,
) -> List[Appointment]:
    """Retrieve appointments with optional date and status filters, ordered by date and start_time."""
    query = db.query(Appointment)

    if filter_date is not None:
        query = query.filter(Appointment.date == filter_date)

    if filter_status and filter_status != "All":
        query = query.filter(Appointment.status == filter_status)

    return query.order_by(Appointment.date.asc(), Appointment.start_time.asc()).all()


def get_appointment_by_id(db: Session, appointment_id: int) -> Appointment:
    """Retrieve an appointment by its ID or raise 404."""
    appointment = db.query(Appointment).filter(Appointment.id == appointment_id).first()
    if not appointment:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Appointment with ID {appointment_id} not found."
        )
    return appointment


def create_appointment(db: Session, appointment_in: AppointmentCreate) -> Appointment:
    """Create a new appointment after validating time range and conflict."""
    validate_time_range(appointment_in.start_time, appointment_in.end_time)
    check_appointment_conflict(
        db=db,
        appointment_date=appointment_in.date,
        start_time=appointment_in.start_time,
        end_time=appointment_in.end_time,
    )

    appointment = Appointment(
        title=appointment_in.title.strip(),
        description=appointment_in.description.strip() if appointment_in.description else None,
        date=appointment_in.date,
        start_time=appointment_in.start_time,
        end_time=appointment_in.end_time,
        status=AppointmentStatus.SCHEDULED.value,
    )

    db.add(appointment)
    db.commit()
    db.refresh(appointment)
    return appointment


def update_appointment(
    db: Session, appointment_id: int, appointment_in: AppointmentUpdate
) -> Appointment:
    """Update an existing appointment, validating times and excluding self from conflict check."""
    appointment = get_appointment_by_id(db, appointment_id)

    validate_time_range(appointment_in.start_time, appointment_in.end_time)
    
    # Conflict check excluding the current appointment
    check_appointment_conflict(
        db=db,
        appointment_date=appointment_in.date,
        start_time=appointment_in.start_time,
        end_time=appointment_in.end_time,
        exclude_id=appointment_id,
    )

    appointment.title = appointment_in.title.strip()
    appointment.description = (
        appointment_in.description.strip() if appointment_in.description else None
    )
    appointment.date = appointment_in.date
    appointment.start_time = appointment_in.start_time
    appointment.end_time = appointment_in.end_time

    db.commit()
    db.refresh(appointment)
    return appointment


def complete_appointment(db: Session, appointment_id: int) -> Appointment:
    """
    Mark an appointment as Completed.
    Disallows transitioning from Cancelled to Completed.
    """
    appointment = get_appointment_by_id(db, appointment_id)

    if appointment.status == AppointmentStatus.CANCELLED.value:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Cannot complete a cancelled appointment."
        )

    appointment.status = AppointmentStatus.COMPLETED.value
    db.commit()
    db.refresh(appointment)
    return appointment


def cancel_appointment(db: Session, appointment_id: int) -> Appointment:
    """Mark an appointment as Cancelled. Cancelled appointments remain in DB but do not block time slots."""
    appointment = get_appointment_by_id(db, appointment_id)

    appointment.status = AppointmentStatus.CANCELLED.value
    db.commit()
    db.refresh(appointment)
    return appointment


def seed_sample_data_if_empty(db: Session) -> None:
    """Seed initial sample appointments only if the appointments table is completely empty."""
    count = db.query(Appointment).count()
    if count > 0:
        return

    today = date.today()
    tomorrow = today + timedelta(days=1)

    sample_appointments = [
        Appointment(
            title="Team Standup",
            description="Daily morning sync on sprint tasks and blockers.",
            date=today,
            start_time=time(9, 0, 0),
            end_time=time(9, 30, 0),
            status=AppointmentStatus.SCHEDULED.value,
        ),
        Appointment(
            title="Client Meeting",
            description="Q3 product demo and roadmap presentation with key stakeholders.",
            date=today,
            start_time=time(10, 0, 0),
            end_time=time(11, 0, 0),
            status=AppointmentStatus.SCHEDULED.value,
        ),
        Appointment(
            title="Project Review",
            description="Post-launch architecture and performance retrospective.",
            date=today,
            start_time=time(11, 30, 0),
            end_time=time(12, 30, 0),
            status=AppointmentStatus.COMPLETED.value,
        ),
        Appointment(
            title="Design Discussion",
            description="Wireframe walkthrough for mobile appointment view (rescheduled).",
            date=today,
            start_time=time(13, 0, 0),
            end_time=time(14, 0, 0),
            status=AppointmentStatus.CANCELLED.value,
        ),
        Appointment(
            title="Candidate Interview",
            description="Technical evaluation session for Full Stack Developer role.",
            date=tomorrow,
            start_time=time(14, 30, 0),
            end_time=time(15, 30, 0),
            status=AppointmentStatus.SCHEDULED.value,
        ),
    ]

    db.add_all(sample_appointments)
    db.commit()
    print(f"Successfully seeded {len(sample_appointments)} sample appointments into the database.")
