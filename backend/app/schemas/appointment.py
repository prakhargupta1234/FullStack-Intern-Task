from datetime import date as dt_date, time as dt_time, datetime as dt_datetime
from typing import Optional
from pydantic import BaseModel, ConfigDict, Field


class AppointmentBase(BaseModel):
    title: str = Field(..., min_length=1, max_length=150, description="Title of the appointment")
    description: Optional[str] = Field(None, description="Optional details or agenda")
    date: dt_date = Field(..., description="Date of the appointment (YYYY-MM-DD)")
    start_time: dt_time = Field(..., description="Start time (HH:MM or HH:MM:SS)")
    end_time: dt_time = Field(..., description="End time (HH:MM or HH:MM:SS)")


class AppointmentCreate(AppointmentBase):
    pass


class AppointmentUpdate(AppointmentBase):
    pass


class AppointmentResponse(AppointmentBase):
    id: int
    status: str
    created_at: dt_datetime
    updated_at: dt_datetime

    model_config = ConfigDict(from_attributes=True)
