"""
Unit and integration test script for Appointment Board backend.
Tests:
1. End time validation (end_time > start_time)
2. Conflict detection:
   - Overlap rejection (409)
   - Back-to-back allowance
   - Cancelled appointment exclusion
3. State transitions (Complete, Cancel, disallow Cancelled -> Completed)
4. Update conflict detection (excluding self)
"""

import sys
from pathlib import Path
import unittest
from datetime import date, time, timedelta

# Add backend directory to sys.path
backend_dir = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(backend_dir))

from fastapi.exceptions import HTTPException
from app.database import SessionLocal, engine, Base
from app.models.appointment import Appointment, AppointmentStatus
from app.schemas.appointment import AppointmentCreate, AppointmentUpdate
from app.services import appointment_service


class TestAppointmentLogic(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        Base.metadata.create_all(bind=engine)

    def setUp(self):
        self.db = SessionLocal()
        # Clean up existing test records with title starting with '[TEST]'
        self.db.query(Appointment).filter(Appointment.title.like("[TEST]%")).delete()
        self.db.commit()
        self.test_date = date(2027, 1, 15)

    def tearDown(self):
        self.db.query(Appointment).filter(Appointment.title.like("[TEST]%")).delete()
        self.db.commit()
        self.db.close()

    def test_end_time_must_be_after_start_time(self):
        """Validates that end_time <= start_time raises 400."""
        with self.assertRaises(HTTPException) as ctx:
            appointment_service.create_appointment(
                self.db,
                AppointmentCreate(
                    title="[TEST] Invalid Time",
                    date=self.test_date,
                    start_time=time(11, 0),
                    end_time=time(10, 0),
                ),
            )
        self.assertEqual(ctx.exception.status_code, 400)
        self.assertIn("End time must be after start time", ctx.exception.detail)

    def test_conflict_detection_overlap_rejected(self):
        """Validates that overlapping appointment raises 409 Conflict."""
        # 1. Create initial appointment 10:00 - 11:00
        app1 = appointment_service.create_appointment(
            self.db,
            AppointmentCreate(
                title="[TEST] Slot 1",
                date=self.test_date,
                start_time=time(10, 0),
                end_time=time(11, 0),
            ),
        )
        self.assertIsNotNone(app1.id)

        # 2. Attempt overlapping appointment 10:30 - 11:30
        with self.assertRaises(HTTPException) as ctx:
            appointment_service.create_appointment(
                self.db,
                AppointmentCreate(
                    title="[TEST] Overlapping Slot",
                    date=self.test_date,
                    start_time=time(10, 30),
                    end_time=time(11, 30),
                ),
            )
        self.assertEqual(ctx.exception.status_code, 409)
        self.assertIn("conflicts with an existing appointment", ctx.exception.detail)

    def test_back_to_back_appointments_allowed(self):
        """Validates that back-to-back appointment (10-11 and 11-12) is allowed."""
        app1 = appointment_service.create_appointment(
            self.db,
            AppointmentCreate(
                title="[TEST] Morning Session",
                date=self.test_date,
                start_time=time(10, 0),
                end_time=time(11, 0),
            ),
        )
        app2 = appointment_service.create_appointment(
            self.db,
            AppointmentCreate(
                title="[TEST] Next Session",
                date=self.test_date,
                start_time=time(11, 0),
                end_time=time(12, 0),
            ),
        )
        self.assertIsNotNone(app1.id)
        self.assertIsNotNone(app2.id)

    def test_cancelled_appointment_does_not_block_slot(self):
        """Validates that a cancelled appointment does not block the same time slot."""
        app1 = appointment_service.create_appointment(
            self.db,
            AppointmentCreate(
                title="[TEST] Cancelled Slot",
                date=self.test_date,
                start_time=time(14, 0),
                end_time=time(15, 0),
            ),
        )
        # Cancel app1
        appointment_service.cancel_appointment(self.db, app1.id)

        # Now create new appointment in the exact same slot 14:00 - 15:00
        app2 = appointment_service.create_appointment(
            self.db,
            AppointmentCreate(
                title="[TEST] New Slot Over Cancelled",
                date=self.test_date,
                start_time=time(14, 0),
                end_time=time(15, 0),
            ),
        )
        self.assertIsNotNone(app2.id)

    def test_update_allows_same_time_without_self_conflict(self):
        """Updating title/description without changing time shouldn't conflict with itself."""
        app1 = appointment_service.create_appointment(
            self.db,
            AppointmentCreate(
                title="[TEST] Original",
                date=self.test_date,
                start_time=time(16, 0),
                end_time=time(17, 0),
            ),
        )
        updated = appointment_service.update_appointment(
            self.db,
            app1.id,
            AppointmentUpdate(
                title="[TEST] Updated Title",
                description="New note",
                date=self.test_date,
                start_time=time(16, 0),
                end_time=time(17, 0),
            ),
        )
        self.assertEqual(updated.title, "[TEST] Updated Title")

    def test_conflict_when_new_appointment_encloses_existing(self):
        """Enclosing appointment (starts before and ends after) must be rejected."""
        appointment_service.create_appointment(
            self.db,
            AppointmentCreate(
                title="[TEST] Existing Inner Slot",
                date=self.test_date,
                start_time=time(10, 30),
                end_time=time(11, 0),
            ),
        )
        with self.assertRaises(HTTPException) as ctx:
            appointment_service.create_appointment(
                self.db,
                AppointmentCreate(
                    title="[TEST] Enclosing Slot",
                    date=self.test_date,
                    start_time=time(10, 0),
                    end_time=time(11, 30),
                ),
            )
        self.assertEqual(ctx.exception.status_code, 409)

    def test_conflict_when_new_appointment_is_inside_existing(self):
        """Interior appointment (starts after and ends before) must be rejected."""
        appointment_service.create_appointment(
            self.db,
            AppointmentCreate(
                title="[TEST] Existing Outer Slot",
                date=self.test_date,
                start_time=time(14, 0),
                end_time=time(15, 30),
            ),
        )
        with self.assertRaises(HTTPException) as ctx:
            appointment_service.create_appointment(
                self.db,
                AppointmentCreate(
                    title="[TEST] Inside Slot",
                    date=self.test_date,
                    start_time=time(14, 15),
                    end_time=time(14, 45),
                ),
            )
    def test_cannot_complete_cancelled_appointment(self):
        """Transitioning Cancelled -> Completed must raise 400 Bad Request."""
        app = appointment_service.create_appointment(
            self.db,
            AppointmentCreate(
                title="[TEST] To Cancel",
                date=self.test_date,
                start_time=time(17, 0),
                end_time=time(18, 0),
            ),
        )
        appointment_service.cancel_appointment(self.db, app.id)

        with self.assertRaises(HTTPException) as ctx:
            appointment_service.complete_appointment(self.db, app.id)
        self.assertEqual(ctx.exception.status_code, 400)


if __name__ == "__main__":
    unittest.main()


