from sqlalchemy import Column, Integer, String, Text, Date, Time, DateTime, func, Enum
from app.database import Base
import enum


class AppointmentStatus(str, enum.Enum):
    SCHEDULED = "Scheduled"
    COMPLETED = "Completed"
    CANCELLED = "Cancelled"


class Appointment(Base):
    __tablename__ = "appointments"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    title = Column(String(150), nullable=False)
    description = Column(Text, nullable=True)
    date = Column(Date, nullable=False, index=True)
    start_time = Column(Time, nullable=False)
    end_time = Column(Time, nullable=False)
    status = Column(
        String(20),
        nullable=False,
        default=AppointmentStatus.SCHEDULED.value,
        index=True
    )
    created_at = Column(
        DateTime,
        nullable=False,
        server_default=func.now()
    )
    updated_at = Column(
        DateTime,
        nullable=False,
        server_default=func.now(),
        onupdate=func.now()
    )

    def __repr__(self):
        return f"<Appointment(id={self.id}, title='{self.title}', date={self.date}, status='{self.status}')>"
