import logging
from datetime import date, time, timedelta
from typing import List, Optional
from sqlalchemy.orm import Session
from sqlalchemy import and_
from fastapi import HTTPException, status

from app.models.appointment import Appointment, AppointmentStatus
from app.schemas.appointment import AppointmentCreate, AppointmentUpdate

logger = logging.getLogger("appointment_board.service")


def validate_time_range(start_time: time, end_time: time) -> None:
    """
    Validates that the appointment's end time strictly succeeds its start time.
    Prevents negative or zero-length appointments.
    """
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
    Evaluates whether the given interval overlaps with any active appointment on that date.

    Why we do NOT use SQL BETWEEN:
    Interval [start, end) conflicts with [existing_start, existing_end) if and only if:
        new_start < existing_end AND new_end > existing_start

    Using BETWEEN would treat boundary equality as an overlap, incorrectly forbidding
    back-to-back meetings (e.g. 10:00-11:00 followed immediately by 11:00-12:00).
    Our condition correctly permits adjacent slots while catching true overlaps.
    """
    query = db.query(Appointment).filter(
        Appointment.date == appointment_date,
        Appointment.status != AppointmentStatus.CANCELLED.value,
        and_(
            Appointment.start_time < end_time,
            Appointment.end_time > start_time,
        )
    )

    # When editing, exclude the record itself from triggering a self-conflict
    if exclude_id is not None:
        query = query.filter(Appointment.id != exclude_id)

    conflict = query.first()
    if conflict:
        logger.warning(
            f"Conflict detected on {appointment_date} between requested [{start_time}-{end_time}] "
            f"and existing appointment ID {conflict.id} [{conflict.start_time}-{conflict.end_time}]"
        )
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Selected time slot conflicts with an existing appointment."
        )


def get_appointments(
    db: Session,
    filter_date: Optional[date] = None,
    filter_status: Optional[str] = None,
) -> List[Appointment]:
    """
    Retrieves appointments ordered chronologically by date and start time.
    Supports optional filtering by specific date and/or status.
    """
    query = db.query(Appointment)

    if filter_date is not None:
        query = query.filter(Appointment.date == filter_date)

    if filter_status and filter_status != "All":
        query = query.filter(Appointment.status == filter_status)

    return query.order_by(Appointment.date.asc(), Appointment.start_time.asc()).all()


def get_appointment_by_id(db: Session, appointment_id: int) -> Appointment:
    """Fetches single appointment by ID or raises 404."""
    appointment = db.query(Appointment).filter(Appointment.id == appointment_id).first()
    if not appointment:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Appointment with ID {appointment_id} not found."
        )
    return appointment


def create_appointment(db: Session, appointment_in: AppointmentCreate) -> Appointment:
    """Validates inputs and persists a new Scheduled appointment."""
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
    logger.info(f"Created appointment ID {appointment.id}: '{appointment.title}' on {appointment.date}")
    return appointment


def update_appointment(
    db: Session, appointment_id: int, appointment_in: AppointmentUpdate
) -> Appointment:
    """Updates an existing appointment, validating times and excluding itself from conflict checks."""
    appointment = get_appointment_by_id(db, appointment_id)

    validate_time_range(appointment_in.start_time, appointment_in.end_time)
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
    logger.info(f"Updated appointment ID {appointment.id}: '{appointment.title}'")
    return appointment


def complete_appointment(db: Session, appointment_id: int) -> Appointment:
    """
    Marks an appointment as Completed.
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
    logger.info(f"Marked appointment ID {appointment.id} as Completed.")
    return appointment


def cancel_appointment(db: Session, appointment_id: int) -> Appointment:
    """
    Cancels an appointment. The record is retained for auditing, but the time slot
    is immediately freed for subsequent bookings.
    """
    appointment = get_appointment_by_id(db, appointment_id)

    appointment.status = AppointmentStatus.CANCELLED.value
    db.commit()
    db.refresh(appointment)
    logger.info(f"Cancelled appointment ID {appointment.id}. Slot released.")
    return appointment


def seed_sample_data_if_empty(db: Session) -> None:
    """Seed initial sample appointments if table is empty."""
    existing_count = db.query(Appointment).count()
    if existing_count > 0:
        return

    today = date.today()
    tomorrow = today + timedelta(days=1)

    sample_appointments = [
        Appointment(
            title="Team Sync & Daily Standup",
            description="Morning check-in on current tasks, blockers, and PR reviews.",
            date=today,
            start_time=time(9, 0, 0),
            end_time=time(9, 30, 0),
            status=AppointmentStatus.SCHEDULED.value,
        ),
        Appointment(
            title="Client Onboarding Walkthrough",
            description="Product demonstration and setup session with new client stakeholders.",
            date=today,
            start_time=time(10, 0, 0),
            end_time=time(11, 0, 0),
            status=AppointmentStatus.SCHEDULED.value,
        ),
        Appointment(
            title="Sprint Planning & Backlog Grooming",
            description="Reviewing upcoming user stories and estimations for next release.",
            date=today,
            start_time=time(11, 30, 0),
            end_time=time(12, 30, 0),
            status=AppointmentStatus.COMPLETED.value,
        ),
        Appointment(
            title="UI/UX Design Review",
            description="Discussion on design tokens and responsive layouts (rescheduled).",
            date=today,
            start_time=time(13, 0, 0),
            end_time=time(14, 0, 0),
            status=AppointmentStatus.CANCELLED.value,
        ),
        Appointment(
            title="Technical Interview: Full Stack",
            description="System design and coding discussion with prospective developer.",
            date=tomorrow,
            start_time=time(14, 30, 0),
            end_time=time(15, 30, 0),
            status=AppointmentStatus.SCHEDULED.value,
        ),
    ]

    db.add_all(sample_appointments)
    db.commit()
    logger.info(f"Seeded {len(sample_appointments)} initial sample appointments.")
