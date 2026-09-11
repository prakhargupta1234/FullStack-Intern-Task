[33mcommit c3e7c934a77fdec3007a4a40719fb04211f68cd0[m[33m ([m[1;36mHEAD[m[33m -> [m[1;32mmain[m[33m, [m[1;31morigin/main[m[33m)[m
Author: prakhargupta1234 <guptaprakhar97791@gmail.com>
Date:   Fri Sep 11 00:16:45 2026 +0530

    11 aug

[1mdiff --git a/.gitignore b/.gitignore[m
[1mnew file mode 100644[m
[1mindex 0000000..c5f5e03[m
[1m--- /dev/null[m
[1m+++ b/.gitignore[m
[36m@@ -0,0 +1,35 @@[m
[32m+[m[32m# Environment variables[m
[32m+[m[32m.env[m
[32m+[m[32m*.env.local[m
[32m+[m
[32m+[m[32m# Python[m
[32m+[m[32m__pycache__/[m
[32m+[m[32m*.py[cod][m
[32m+[m[32m*$py.class[m
[32m+[m[32m*.so[m
[32m+[m[32m.Python[m
[32m+[m[32menv/[m
[32m+[m[32mvenv/[m
[32m+[m[32mENV/[m
[32m+[m[32menv.bak/[m
[32m+[m[32mvenv.bak/[m
[32m+[m[32m.pytest_cache/[m
[32m+[m
[32m+[m[32m# Node / Frontend[m
[32m+[m[32mnode_modules/[m
[32m+[m[32mdist/[m
[32m+[m[32mdist-ssr/[m
[32m+[m[32m*.local[m
[32m+[m[32m.vite/[m
[32m+[m[32m.eslintcache[m
[32m+[m
[32m+[m[32m# Logs & OS[m
[32m+[m[32m*.log[m
[32m+[m[32mnpm-debug.log*[m
[32m+[m[32myarn-debug.log*[m
[32m+[m[32myarn-error.log*[m
[32m+[m[32mpnpm-debug.log*[m
[32m+[m[32m.DS_Store[m
[32m+[m[32mThumbs.db[m
[32m+[m[32m.idea/[m
[32m+[m[32m.vscode/[m
[1mdiff --git a/backend/.env.example b/backend/.env.example[m
[1mnew file mode 100644[m
[1mindex 0000000..80afc1f[m
[1m--- /dev/null[m
[1m+++ b/backend/.env.example[m
[36m@@ -0,0 +1,17 @@[m
[32m+[m[32m# Database Configuration[m
[32m+[m[32m# Format: mysql+pymysql://<username>:<password>@<host>:<port>/<database_name>[m
[32m+[m[32m# Note: If your password contains special characters like '@', URL-encode it (e.g. '@' becomes '%40')[m
[32m+[m[32m# or use the individual DB_* variables below:[m
[32m+[m[32mDATABASE_URL=mysql+pymysql://root:password@127.0.0.1:3306/appointment_board[m
[32m+[m
[32m+[m[32m# Optional granular credentials:[m
[32m+[m[32mDB_USER=root[m
[32m+[m[32mDB_PASSWORD=password[m
[32m+[m[32mDB_HOST=127.0.0.1[m
[32m+[m[32mDB_PORT=3306[m
[32m+[m[32mDB_NAME=appointment_board[m
[32m+[m
[32m+[m[32m# Application Settings[m
[32m+[m[32mFRONTEND_URL=http://localhost:5173[m
[32m+[m[32mPORT=8000[m
[32m+[m[32mHOST=0.0.0.0[m
[1mdiff --git a/backend/app/database.py b/backend/app/database.py[m
[1mnew file mode 100644[m
[1mindex 0000000..b625f8c[m
[1m--- /dev/null[m
[1m+++ b/backend/app/database.py[m
[36m@@ -0,0 +1,60 @@[m
[32m+[m[32mimport os[m
[32m+[m[32mfrom pathlib import Path[m
[32m+[m[32mfrom dotenv import load_dotenv[m
[32m+[m[32mfrom sqlalchemy import create_engine[m
[32m+[m[32mfrom sqlalchemy.engine.url import URL, make_url[m
[32m+[m[32mfrom sqlalchemy.orm import declarative_base, sessionmaker[m
[32m+[m
[32m+[m[32m# Locate and load the .env file from the backend folder[m
[32m+[m[32mBASE_DIR = Path(__file__).resolve().parent.parent[m
[32m+[m[32mload_dotenv(dotenv_path=BASE_DIR / ".env")[m
[32m+[m
[32m+[m[32m# Priority 1: Check if granular credentials are provided[m
[32m+[m[32mdb_user = os.getenv("DB_USER")[m
[32m+[m[32mdb_password = os.getenv("DB_PASSWORD")[m
[32m+[m[32mdb_host = os.getenv("DB_HOST", "127.0.0.1")[m
[32m+[m[32mdb_port = int(os.getenv("DB_PORT", "3306"))[m
[32m+[m[32mdb_name = os.getenv("DB_NAME", "appointment_board")[m
[32m+[m
[32m+[m[32mraw_db_url = os.getenv("DATABASE_URL")[m
[32m+[m
[32m+[m[32mif db_user and db_password is not None:[m
[32m+[m[32m    db_url = URL.create([m
[32m+[m[32m        drivername="mysql+pymysql",[m
[32m+[m[32m        username=db_user,[m
[32m+[m[32m        password=db_password,[m
[32m+[m[32m        host=db_host,[m
[32m+[m[32m        port=db_port,[m
[32m+[m[32m        database=db_name,[m
[32m+[m[32m    )[m
[32m+[m[32melif raw_db_url:[m
[32m+[m[32m    db_url = raw_db_url[m
[32m+[m[32melse:[m
[32m+[m[32m    db_url = URL.create([m
[32m+[m[32m        drivername="mysql+pymysql",[m
[32m+[m[32m        username="root",[m
[32m+[m[32m        password="password",[m
[32m+[m[32m        host="127.0.0.1",[m
[32m+[m[32m        port=3306,[m
[32m+[m[32m        database="appointment_board",[m
[32m+[m[32m    )[m
[32m+[m
[32m+[m[32mengine = create_engine([m
[32m+[m[32m    db_url,[m
[32m+[m[32m    pool_pre_ping=True,[m
[32m+[m[32m    pool_recycle=3600,[m
[32m+[m[32m    echo=False[m
[32m+[m[32m)[m
[32m+[m
[32m+[m[32mSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)[m
[32m+[m
[32m+[m[32mBase = declarative_base()[m
[32m+[m
[32m+[m
[32m+[m[32mdef get_db():[m
[32m+[m[32m    """FastAPI dependency to yield a database session per request."""[m
[32m+[m[32m    db = SessionLocal()[m
[32m+[m[32m    try:[m
[32m+[m[32m        yield db[m
[32m+[m[32m    finally:[m
[32m+[m[32m        db.close()[m
[1mdiff --git a/backend/app/main.py b/backend/app/main.py[m
[1mnew file mode 100644[m
[1mindex 0000000..d41f403[m
[1m--- /dev/null[m
[1m+++ b/backend/app/main.py[m
[36m@@ -0,0 +1,93 @@[m
[32m+[m[32mimport os[m
[32m+[m[32mfrom contextlib import asynccontextmanager[m
[32m+[m[32mfrom fastapi import FastAPI, Request, status[m
[32m+[m[32mfrom fastapi.middleware.cors import CORSMiddleware[m
[32m+[m[32mfrom fastapi.responses import JSONResponse[m
[32m+[m[32mfrom fastapi.exceptions import RequestValidationError[m
[32m+[m
[32m+[m[32mfrom app.database import engine, Base, SessionLocal[m
[32m+[m[32mfrom app.routers import appointments_router[m
[32m+[m[32mfrom app.services import seed_sample_data_if_empty[m
[32m+[m
[32m+[m
[32m+[m[32m@asynccontextmanager[m
[32m+[m[32masync def lifespan(app: FastAPI):[m
[32m+[m[32m    """[m
[32m+[m[32m    Application startup and shutdown event handler.[m
[32m+[m[32m    Creates tables if they don't exist and seeds sample appointments if empty.[m
[32m+[m[32m    """[m
[32m+[m[32m    # Create tables[m
[32m+[m[32m    Base.metadata.create_all(bind=engine)[m
[32m+[m
[32m+[m[32m    # Seed sample appointments if table is empty[m
[32m+[m[32m    db = SessionLocal()[m
[32m+[m[32m    try:[m
[32m+[m[32m        seed_sample_data_if_empty(db)[m
[32m+[m[32m    finally:[m
[32m+[m[32m        db.close()[m
[32m+[m
[32m+[m[32m    yield[m
[32m+[m[32m    # Cleanup actions (if any) on shutdown[m
[32m+[m
[32m+[m
[32m+[m[32mapp = FastAPI([m
[32m+[m[32m    title="Appointment Board API",[m
[32m+[m[32m    description="RESTful API for managing team appointments with conflict detection",[m
[32m+[m[32m    version="1.0.0",[m
[32m+[m[32m    lifespan=lifespan,[m
[32m+[m[32m    docs_url="/docs",[m
[32m+[m[32m    redoc_url="/redoc",[m
[32m+[m[32m)[m
[32m+[m
[32m+[m[32m# CORS configuration[m
[32m+[m[32mfrontend_url = os.getenv("FRONTEND_URL", "http://localhost:5173")[m
[32m+[m[32morigins = [[m
[32m+[m[32m    frontend_url,[m
[32m+[m[32m    "http://localhost:5173",[m
[32m+[m[32m    "http://127.0.0.1:5173",[m
[32m+[m[32m    "http://localhost:3000",[m
[32m+[m[32m][m
[32m+[m
[32m+[m[32mapp.add_middleware([m
[32m+[m[32m    CORSMiddleware,[m
[32m+[m[32m    allow_origins=origins,[m
[32m+[m[32m    allow_credentials=True,[m
[32m+[m[32m    allow_methods=["*"],[m
[32m+[m[32m    allow_headers=["*"],[m
[32m+[m[32m)[m
[32m+[m
[32m+[m
[32m+[m[32m@app.exception_handler(RequestValidationError)[m
[32m+[m[32masync def validation_exception_handler(request: Request, exc: RequestValidationError):[m
[32m+[m[32m    """Format Pydantic request validation errors into a clean, human-readable format."""[m
[32m+[m[32m    errors = exc.errors()[m
[32m+[m[32m    messages = [][m
[32m+[m[32m    for err in errors:[m
[32m+[m[32m        loc = " -> ".join(str(l) for l in err.get("loc", []))[m
[32m+[m[32m        msg = err.get("msg", "Invalid input")[m
[32m+[m[32m        messages.append(f"{loc}: {msg}")[m
[32m+[m[32m    return JSONResponse([m
[32m+[m[32m        status_code=status.HTTP_400_BAD_REQUEST,[m
[32m+[m[32m        content={"detail": "Validation error: " + "; ".join(messages)},[m
[32m+[m[32m    )[m
[32m+[m
[32m+[m
[32m+[m[32m@app.exception_handler(Exception)[m
[32m+[m[32masync def generic_exception_handler(request: Request, exc: Exception):[m
[32m+[m[32m    """Catch-all exception handler to avoid raw stack traces leaking to clients."""[m
[32m+[m[32m    # Print internally for server debugging[m
[32m+[m[32m    print(f"Internal Server Error: {exc}")[m
[32m+[m[32m    return JSONResponse([m
[32m+[m[32m        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,[m
[32m+[m[32m        content={"detail": "An unexpected internal server error occurred. Please try again later."},[m
[32m+[m[32m    )[m
[32m+[m
[32m+[m
[32m+[m[32m# Register routers[m
[32m+[m[32mapp.include_router(appointments_router)[m
[32m+[m
[32m+[m
[32m+[m[32m@app.get("/health", tags=["Health"])[m
[32m+[m[32mdef health_check():[m
[32m+[m[32m    """Health check endpoint."""[m
[32m+[m[32m    return {"status": "healthy", "service": "appointment-board-api"}[m
[1mdiff --git a/backend/app/models/__init__.py b/backend/app/models/__init__.py[m
[1mnew file mode 100644[m
[1mindex 0000000..bff16e9[m
[1m--- /dev/null[m
[1m+++ b/backend/app/models/__init__.py[m
[36m@@ -0,0 +1,3 @@[m
[32m+[m[32mfrom app.models.appointment import Appointment, AppointmentStatus[m
[32m+[m
[32m+[m[32m__all__ = ["Appointment", "AppointmentStatus"][m
[1mdiff --git a/backend/app/models/appointment.py b/backend/app/models/appointment.py[m
[1mnew file mode 100644[m
[1mindex 0000000..254f50f[m
[1m--- /dev/null[m
[1m+++ b/backend/app/models/appointment.py[m
[36m@@ -0,0 +1,40 @@[m
[32m+[m[32mfrom sqlalchemy import Column, Integer, String, Text, Date, Time, DateTime, func, Enum[m
[32m+[m[32mfrom app.database import Base[m
[32m+[m[32mimport enum[m
[32m+[m
[32m+[m
[32m+[m[32mclass AppointmentStatus(str, enum.Enum):[m
[32m+[m[32m    SCHEDULED = "Scheduled"[m
[32m+[m[32m    COMPLETED = "Completed"[m
[32m+[m[32m    CANCELLED = "Cancelled"[m
[32m+[m
[32m+[m
[32m+[m[32mclass Appointment(Base):[m
[32m+[m[32m    __tablename__ = "appointments"[m
[32m+[m
[32m+[m[32m    id = Column(Integer, primary_key=True, index=True, autoincrement=True)[m
[32m+[m[32m    title = Column(String(150), nullable=False)[m
[32m+[m[32m    description = Column(Text, nullable=True)[m
[32m+[m[32m    date = Column(Date, nullable=False, index=True)[m
[32m+[m[32m    start_time = Column(Time, nullable=False)[m
[32m+[m[32m    end_time = Column(Time, nullable=False)[m
[32m+[m[32m    status = Column([m
[32m+[m[32m        String(20),[m
[32m+[m[32m        nullable=False,[m
[32m+[m[32m        default=AppointmentStatus.SCHEDULED.value,[m
[32m+[m[32m        index=True[m
[32m+[m[32m    )[m
[32m+[m[32m    created_at = Column([m
[32m+[m[32m        DateTime,[m
[32m+[m[32m        nullable=False,[m
[32m+[m[32m        server_default=func.now()[m
[32m+[m[32m    )[m
[32m+[m[32m    updated_at = Column([m
[32m+[m[32m        DateTime,[m
[32m+[m[32m        nullable=False,[m
[32m+[m[32m        server_default=func.now(),[m
[32m+[m[32m        onupdate=func.now()[m
[32m+[m[32m    )[m
[32m+[m
[32m+[m[32m    def __repr__(self):[m
[32m+[m[32m        return f"<Appointment(id={self.id}, title='{self.title}', date={self.date}, status='{self.status}')>"[m
[1mdiff --git a/backend/app/routers/__init__.py b/backend/app/routers/__init__.py[m
[1mnew file mode 100644[m
[1mindex 0000000..73b5f0c[m
[1m--- /dev/null[m
[1m+++ b/backend/app/routers/__init__.py[m
[36m@@ -0,0 +1,3 @@[m
[32m+[m[32mfrom app.routers.appointments import router as appointments_router[m
[32m+[m
[32m+[m[32m__all__ = ["appointments_router"][m
[1mdiff --git a/backend/app/routers/appointments.py b/backend/app/routers/appointments.py[m
[1mnew file mode 100644[m
[1mindex 0000000..55a5744[m
[1m--- /dev/null[m
[1m+++ b/backend/app/routers/appointments.py[m
[36m@@ -0,0 +1,124 @@[m
[32m+[m[32mfrom datetime import date[m
[32m+[m[32mfrom typing import List, Optional[m
[32m+[m[32mfrom fastapi import APIRouter, Depends, Query, status[m
[32m+[m[32mfrom sqlalchemy.orm import Session[m
[32m+[m
[32m+[m[32mfrom app.database import get_db[m
[32m+[m[32mfrom app.schemas.appointment import ([m
[32m+[m[32m    AppointmentCreate,[m
[32m+[m[32m    AppointmentUpdate,[m
[32m+[m[32m    AppointmentResponse,[m
[32m+[m[32m)[m
[32m+[m[32mfrom app.services import appointment_service[m
[32m+[m
[32m+[m[32mrouter = APIRouter([m
[32m+[m[32m    prefix="/api/appointments",[m
[32m+[m[32m    tags=["Appointments"],[m
[32m+[m[32m)[m
[32m+[m
[32m+[m
[32m+[m[32m@router.get([m
[32m+[m[32m    "",[m
[32m+[m[32m    response_model=List[AppointmentResponse],[m
[32m+[m[32m    status_code=status.HTTP_200_OK,[m
[32m+[m[32m    summary="Get appointments with optional date and status filters"[m
[32m+[m[32m)[m
[32m+[m[32mdef get_appointments([m
[32m+[m[32m    date: Optional[date] = Query(None, description="Filter appointments by date (YYYY-MM-DD)"),[m
[32m+[m[32m    status: Optional[str] = Query(None, description="Filter appointments by status (Scheduled, Completed, Cancelled)"),[m
[32m+[m[32m    db: Session = Depends(get_db),[m
[32m+[m[32m):[m
[32m+[m[32m    """Retrieve all appointments, optionally filtered by date and/or status."""[m
[32m+[m[32m    return appointment_service.get_appointments(db, filter_date=date, filter_status=status)[m
[32m+[m
[32m+[m
[32m+[m[32m@router.get([m
[32m+[m[32m    "/{appointment_id}",[m
[32m+[m[32m    response_model=AppointmentResponse,[m
[32m+[m[32m    status_code=status.HTTP_200_OK,[m
[32m+[m[32m    summary="Get single appointment by ID"[m
[32m+[m[32m)[m
[32m+[m[32mdef get_appointment([m
[32m+[m[32m    appointment_id: int,[m
[32m+[m[32m    db: Session = Depends(get_db),[m
[32m+[m[32m):[m
[32m+[m[32m    """Retrieve details for a single appointment."""[m
[32m+[m[32m    return appointment_service.get_appointment_by_id(db, appointment_id=appointment_id)[m
[32m+[m
[32m+[m
[32m+[m[32m@router.post([m
[32m+[m[32m    "",[m
[32m+[m[32m    response_model=AppointmentResponse,[m
[32m+[m[32m    status_code=status.HTTP_201_CREATED,[m
[32m+[m[32m    summary="Create a new appointment"[m
[32m+[m[32m)[m
[32m+[m[32mdef create_appointment([m
[32m+[m[32m    appointment_in: AppointmentCreate,[m
[32m+[m[32m    db: Session = Depends(get_db),[m
[32m+[m[32m):[m
[32m+[m[32m    """[m
[32m+[m[32m    Create a new appointment.[m
[32m+[m[32m    Validates:[m
[32m+[m[32m    - Required fields[m
[32m+[m[32m    - end_time > start_time (400)[m
[32m+[m[32m    - Conflict with existing non-cancelled appointments (409)[m
[32m+[m[32m    """[m
[32m+[m[32m    return appointment_service.create_appointment(db, appointment_in=appointment_in)[m
[32m+[m
[32m+[m
[32m+[m[32m@router.put([m
[32m+[m[32m    "/{appointment_id}",[m
[32m+[m[32m    response_model=AppointmentResponse,[m
[32m+[m[32m    status_code=status.HTTP_200_OK,[m
[32m+[m[32m    summary="Update an existing appointment"[m
[32m+[m[32m)[m
[32m+[m[32mdef update_appointment([m
[32m+[m[32m    appointment_id: int,[m
[32m+[m[32m    appointment_in: AppointmentUpdate,[m
[32m+[m[32m    db: Session = Depends(get_db),[m
[32m+[m[32m):[m
[32m+[m[32m    """[m
[32m+[m[32m    Update appointment details.[m
[32m+[m[32m    Validates:[m
[32m+[m[32m    - Existence (404)[m
[32m+[m[32m    - end_time > start_time (400)[m
[32m+[m[32m    - Conflict with existing non-cancelled appointments excluding self (409)[m
[32m+[m[32m    """[m
[32m+[m[32m    return appointment_service.update_appointment([m
[32m+[m[32m        db, appointment_id=appointment_id, appointment_in=appointment_in[m
[32m+[m[32m    )[m
[32m+[m
[32m+[m
[32m+[m[32m@router.patch([m
[32m+[m[32m    "/{appointment_id}/complete",[m
[32m+[m[32m    response_model=AppointmentResponse,[m
[32m+[m[32m    status_code=status.HTTP_200_OK,[m
[32m+[m[32m    summary="Mark appointment as completed"[m
[32m+[m[32m)[m
[32m+[m[32mdef complete_appointment([m
[32m+[m[32m    appointment_id: int,[m
[32m+[m[32m    db: Session = Depends(get_db),[m
[32m+[m[32m):[m
[32m+[m[32m    """[m
[32m+[m[32m    Mark an appointment as Completed.[m
[32m+[m[32m    Disallows transitioning a Cancelled appointment to Completed (400).[m
[32m+[m[32m    """[m
[32m+[m[32m    return appointment_service.complete_appointment(db, appointment_id=appointment_id)[m
[32m+[m
[32m+[m
[32m+[m[32m@router.patch([m
[32m+[m[32m    "/{appointment_id}/cancel",[m
[32m+[m[32m    response_model=AppointmentResponse,[m
[32m+[m[32m    status_code=status.HTTP_200_OK,[m
[32m+[m[32m    summary="Cancel an appointment"[m
[32m+[m[32m)[m
[32m+[m[32mdef cancel_appointment([m
[32m+[m[32m    appointment_id: int,[m
[32m+[m[32m    db: Session = Depends(get_db),[m
[32m+[m[32m):[m
[32m+[m[32m    """[m
[32m+[m[32m    Cancel an appointment.[m
[32m+[m[32m    Does not delete the record; marks it as Cancelled so it remains visible[m
[32m+[m[32m    and frees its time slot.[m
[32m+[m[32m    """[m
[32m+[m[32m    return appointment_service.cancel_appointment(db, appointment_id=appointment_id)[m
[1mdiff --git a/backend/app/schemas/__init__.py b/backend/app/schemas/__init__.py[m
[1mnew file mode 100644[m
[1mindex 0000000..56c289b[m
[1m--- /dev/null[m
[1m+++ b/backend/app/schemas/__init__.py[m
[36m@@ -0,0 +1,13 @@[m
[32m+[m[32mfrom app.schemas.appointment import ([m
[32m+[m[32m    AppointmentBase,[m
[32m+[m[32m    AppointmentCreate,[m
[32m+[m[32m    AppointmentUpdate,[m
[32m+[m[32m    AppointmentResponse,[m
[32m+[m[32m)[m
[32m+[m
[32m+[m[32m__all__ = [[m
[32m+[m[32m    "AppointmentBase",[m
[32m+[m[32m    "AppointmentCreate",[m
[32m+[m[32m    "AppointmentUpdate",[m
[32m+[m[32m    "AppointmentResponse",[m
[32m+[m[32m][m
[1mdiff --git a/backend/app/schemas/appointment.py b/backend/app/schemas/appointment.py[m
[1mnew file mode 100644[m
[1mindex 0000000..4228b68[m
[1m--- /dev/null[m
[1m+++ b/backend/app/schemas/appointment.py[m
[36m@@ -0,0 +1,28 @@[m
[32m+[m[32mfrom datetime import date as dt_date, time as dt_time, datetime as dt_datetime[m
[32m+[m[32mfrom typing import Optional[m
[32m+[m[32mfrom pydantic import BaseModel, ConfigDict, Field[m
[32m+[m
[32m+[m
[32m+[m[32mclass AppointmentBase(BaseModel):[m
[32m+[m[32m    title: str = Field(..., min_length=1, max_length=150, description="Title of the appointment")[m
[32m+[m[32m    description: Optional[str] = Field(None, description="Optional details or agenda")[m
[32m+[m[32m    date: dt_date = Field(..., description="Date of the appointment (YYYY-MM-DD)")[m
[32m+[m[32m    start_time: dt_time = Field(..., description="Start time (HH:MM or HH:MM:SS)")[m
[32m+[m[32m    end_time: dt_time = Field(..., description="End time (HH:MM or HH:MM:SS)")[m
[32m+[m
[32m+[m
[32m+[m[32mclass AppointmentCreate(AppointmentBase):[m
[32m+[m[32m    pass[m
[32m+[m
[32m+[m
[32m+[m[32mclass AppointmentUpdate(AppointmentBase):[m
[32m+[m[32m    pass[m
[32m+[m
[32m+[m
[32m+[m[32mclass AppointmentResponse(AppointmentBase):[m
[32m+[m[32m    id: int[m
[32m+[m[32m    status: str[m
[32m+[m[32m    created_at: dt_datetime[m
[32m+[m[32m    updated_at: dt_datetime[m
[32m+[m
[32m+[m[32m    model_config = ConfigDict(from_attributes=True)[m
[1mdiff --git a/backend/app/services/__init__.py b/backend/app/services/__init__.py[m
[1mnew file mode 100644[m
[1mindex 0000000..88043af[m
[1m--- /dev/null[m
[1m+++ b/backend/app/services/__init__.py[m
[36m@@ -0,0 +1,23 @@[m
[32m+[m[32mfrom app.services.appointment_service import ([m
[32m+[m[32m    get_appointments,[m
[32m+[m[32m    get_appointment_by_id,[m
[32m+[m[32m    create_appointment,[m
[32m+[m[32m    update_appointment,[m
[32m+[m[32m    complete_appointment,[m
[32m+[m[32m    cancel_appointment,[m
[32m+[m[32m    seed_sample_data_if_empty,[m
[32m+[m[32m    check_appointment_conflict,[m
[32m+[m[32m    validate_time_range,[m
[32m+[m[32m)[m
[32m+[m
[32m+[m[32m__all__ = [[m
[32m+[m[32m    "get_appointments",[m
[32m+[m[32m    "get_appointment_by_id",[m
[32m+[m[32m    "create_appointment",[m
[32m+[m[32m    "update_appointment",[m
[32m+[m[32m    "complete_appointment",[m
[32m+[m[32m    "cancel_appointment",[m
[32m+[m[32m    "seed_sample_data_if_empty",[m
[32m+[m[32m    "check_appointment_conflict",[m
[32m+[m[32m    "validate_time_range",[m
[32m+[m[32m][m
[1mdiff --git a/backend/app/services/appointment_service.py b/backend/app/services/appointment_service.py[m
[1mnew file mode 100644[m
[1mindex 0000000..b3b162b[m
[1m--- /dev/null[m
[1m+++ b/backend/app/services/appointment_service.py[m
[36m@@ -0,0 +1,225 @@[m
[32m+[m[32mfrom datetime import date, time, datetime, timedelta[m
[32m+[m[32mfrom typing import List, Optional[m
[32m+[m[32mfrom sqlalchemy.orm import Session[m
[32m+[m[32mfrom sqlalchemy import and_[m
[32m+[m[32mfrom fastapi import HTTPException, status[m
[32m+[m
[32m+[m[32mfrom app.models.appointment import Appointment, AppointmentStatus[m
[32m+[m[32mfrom app.schemas.appointment import AppointmentCreate, AppointmentUpdate[m
[32m+[m
[32m+[m
[32m+[m[32mdef validate_time_range(start_time: time, end_time: time) -> None:[m
[32m+[m[32m    """Validate that end_time is strictly after start_time."""[m
[32m+[m[32m    if end_time <= start_time:[m
[32m+[m[32m        raise HTTPException([m
[32m+[m[32m            status_code=status.HTTP_400_BAD_REQUEST,[m
[32m+[m[32m            detail="End time must be after start time."[m
[32m+[m[32m        )[m
[32m+[m
[32m+[m
[32m+[m[32mdef check_appointment_conflict([m
[32m+[m[32m    db: Session,[m
[32m+[m[32m    appointment_date: date,[m
[32m+[m[32m    start_time: time,[m
[32m+[m[32m    end_time: time,[m
[32m+[m[32m    exclude_id: Optional[int] = None,[m
[32m+[m[32m) -> None:[m
[32m+[m[32m    """[m
[32m+[m[32m    Check if the requested time slot conflicts with any active (non-cancelled) appointment[m
[32m+[m[32m    on the specified date.[m
[32m+[m[41m    [m
[32m+[m[32m    Conflict logic:[m
[32m+[m[32m    new_start < existing_end AND new_end > existing_start[m
[32m+[m[32m    Back-to-back appointments (e.g. 10:00-11:00 and 11:00-12:00) are allowed.[m
[32m+[m[32m    Only appointments whose status != 'Cancelled' participate.[m
[32m+[m[32m    """[m
[32m+[m[32m    query = db.query(Appointment).filter([m
[32m+[m[32m        Appointment.date == appointment_date,[m
[32m+[m[32m        Appointment.status != AppointmentStatus.CANCELLED.value,[m
[32m+[m[32m        # Overlap condition:[m
[32m+[m[32m        # existing.start_time < new_end AND existing.end_time > new_start[m
[32m+[m[32m        and_([m
[32m+[m[32m            Appointment.start_time < end_time,[m
[32m+[m[32m            Appointment.end_time > start_time,[m
[32m+[m[32m        )[m
[32m+[m[32m    )[m
[32m+[m
[32m+[m[32m    if exclude_id is not None:[m
[32m+[m[32m        query = query.filter(Appointment.id != exclude_id)[m
[32m+[m
[32m+[m[32m    conflicting_appointment = query.first()[m
[32m+[m
[32m+[m[32m    if conflicting_appointment:[m
[32m+[m[32m        raise HTTPException([m
[32m+[m[32m            status_code=status.HTTP_409_CONFLICT,[m
[32m+[m[32m            detail="Selected time slot conflicts with an existing appointment."[m
[32m+[m[32m        )[m
[32m+[m
[32m+[m
[32m+[m[32mdef get_appointments([m
[32m+[m[32m    db: Session,[m
[32m+[m[32m    filter_date: Optional[date] = None,[m
[32m+[m[32m    filter_status: Optional[str] = None,[m
[32m+[m[32m) -> List[Appointment]:[m
[32m+[m[32m    """Retrieve appointments with optional date and status filters, ordered by date and start_time."""[m
[32m+[m[32m    query = db.query(Appointment)[m
[32m+[m
[32m+[m[32m    if filter_date is not None:[m
[32m+[m[32m        query = query.filter(Appointment.date == filter_date)[m
[32m+[m
[32m+[m[32m    if filter_status and filter_status != "All":[m
[32m+[m[32m        query = query.filter(Appointment.status == filter_status)[m
[32m+[m
[32m+[m[32m    return query.order_by(Appointment.date.asc(), Appointment.start_time.asc()).all()[m
[32m+[m
[32m+[m
[32m+[m[32mdef get_appointment_by_id(db: Session, appointment_id: int) -> Appointment:[m
[32m+[m[32m    """Retrieve an appointment by its ID or raise 404."""[m
[32m+[m[32m    appointment = db.query(Appointment).filter(Appointment.id == appointment_id).first()[m
[32m+[m[32m    if not appointment:[m
[32m+[m[32m        raise HTTPException([m
[32m+[m[32m            status_code=status.HTTP_404_NOT_FOUND,[m
[32m+[m[32m            detail=f"Appointment with ID {appointment_id} not found."[m
[32m+[m[32m        )[m
[32m+[m[32m    return appointment[m
[32m+[m
[32m+[m
[32m+[m[32mdef create_appointment(db: Session, appointment_in: AppointmentCreate) -> Appointment:[m
[32m+[m[32m    """Create a new appointment after validating time range and conflict."""[m
[32m+[m[32m    validate_time_range(appointment_in.start_time, appointment_in.end_time)[m
[32m+[m[32m    check_appointment_conflict([m
[32m+[m[32m        db=db,[m
[32m+[m[32m        appointment_date=appointment_in.date,[m
[32m+[m[32m        start_time=appointment_in.start_time,[m
[32m+[m[32m        end_time=appointment_in.end_time,[m
[32m+[m[32m    )[m
[32m+[m
[32m+[m[32m    appointment = Appointment([m
[32m+[m[32m        title=appointment_in.title.strip(),[m
[32m+[m[32m        description=appointment_in.description.strip() if appointment_in.description else None,[m
[32m+[m[32m        date=appointment_in.date,[m
[32m+[m[32m        start_time=appointment_in.start_time,[m
[32m+[m[32m        end_time=appointment_in.end_time,[m
[32m+[m[32m        status=AppointmentStatus.SCHEDULED.value,[m
[32m+[m[32m    )[m
[32m+[m
[32m+[m[32m    db.add(appointment)[m
[32m+[m[32m    db.commit()[m
[32m+[m[32m    db.refresh(appointment)[m
[32m+[m[32m    return appointment[m
[32m+[m
[32m+[m
[32m+[m[32mdef update_appointment([m
[32m+[m[32m    db: Session, appointment_id: int, appointment_in: AppointmentUpdate[m
[32m+[m[32m) -> Appointment:[m
[32m+[m[32m    """Update an existing appointment, validating times and excluding self from conflict check."""[m
[32m+[m[32m    appointment = get_appointment_by_id(db, appointment_id)[m
[32m+[m
[32m+[m[32m    validate_time_range(appointment_in.start_time, appointment_in.end_time)[m
[32m+[m[41m    [m
[32m+[m[32m    # Conflict check excluding the current appointment[m
[32m+[m[32m    check_appointment_conflict([m
[32m+[m[32m        db=db,[m
[32m+[m[32m        appointment_date=appointment_in.date,[m
[32m+[m[32m        start_time=appointment_in.start_time,[m
[32m+[m[32m        end_time=appointment_in.end_time,[m
[32m+[m[32m        exclude_id=appointment_id,[m
[32m+[m[32m    )[m
[32m+[m
[32m+[m[32m    appointment.title = appointment_in.title.strip()[m
[32m+[m[32m    appointment.description = ([m
[32m+[m[32m        appointment_in.description.strip() if appointment_in.description else None[m
[32m+[m[32m    )[m
[32m+[m[32m    appointment.date = appointment_in.date[m
[32m+[m[32m    appointment.start_time = appointment_in.start_time[m
[32m+[m[32m    appointment.end_time = appointment_in.end_time[m
[32m+[m
[32m+[m[32m    db.commit()[m
[32m+[m[32m    db.refresh(appointment)[m
[32m+[m[32m    return appointment[m
[32m+[m
[32m+[m
[32m+[m[32mdef complete_appointment(db: Session, appointment_id: int) -> Appointment:[m
[32m+[m[32m    """[m
[32m+[m[32m    Mark an appointment as Completed.[m
[32m+[m[32m    Disallows transitioning from Cancelled to Completed.[m
[32m+[m[32m    """[m
[32m+[m[32m    appointment = get_appointment_by_id(db, appointment_id)[m
[32m+[m
[32m+[m[32m    if appointment.status == AppointmentStatus.CANCELLED.value:[m
[32m+[m[32m        raise HTTPException([m
[32m+[m[32m            status_code=status.HTTP_400_BAD_REQUEST,[m
[32m+[m[32m            detail="Cannot complete a cancelled appointment."[m
[32m+[m[32m        )[m
[32m+[m
[32m+[m[32m    appointment.status = AppointmentStatus.COMPLETED.value[m
[32m+[m[32m    db.commit()[m
[32m+[m[32m    db.refresh(appointment)[m
[32m+[m[32m    return appointment[m
[32m+[m
[32m+[m
[32m+[m[32mdef cancel_appointment(db: Session, appointment_id: int) -> Appointment:[m
[32m+[m[32m    """Mark an appointment as Cancelled. Cancelled appointments remain in DB but do not block time slots."""[m
[32m+[m[32m    appointment = get_appointment_by_id(db, appointment_id)[m
[32m+[m
[32m+[m[32m    appointment.status = AppointmentStatus.CANCELLED.value[m
[32m+[m[32m    db.commit()[m
[32m+[m[32m    db.refresh(appointment)[m
[32m+[m[32m    return appointment[m
[32m+[m
[32m+[m
[32m+[m[32mdef seed_sample_data_if_empty(db: Session) -> None:[m
[32m+[m[32m    """Seed initial sample appointments only if the appointments table is completely empty."""[m
[32m+[m[32m    count = db.query(Appointment).count()[m
[32m+[m[32m    if count > 0:[m
[32m+[m[32m        return[m
[32m+[m
[32m+[m[32m    today = date.today()[m
[32m+[m[32m    tomorrow = today + timedelta(days=1)[m
[32m+[m
[32m+[m[32m    sample_appointments = [[m
[32m+[m[32m        Appointment([m
[32m+[m[32m            title="Team Standup",[m
[32m+[m[32m            description="Daily morning sync on sprint tasks and blockers.",[m
[32m+[m[32m            date=today,[m
[32m+[m[32m            start_time=time(9, 0, 0),[m
[32m+[m[32m            end_time=time(9, 30, 0),[m
[32m+[m[32m            status=AppointmentStatus.SCHEDULED.value,[m
[32m+[m[32m        ),[m
[32m+[m[32m        Appointment([m
[32m+[m[32m            title="Client Meeting",[m
[32m+[m[32m            description="Q3 product demo and roadmap presentation with key stakeholders.",[m
[32m+[m[32m            date=today,[m
[32m+[m[32m            start_time=time(10, 0, 0),[m
[32m+[m[32m            end_time=time(11, 0, 0),[m
[32m+[m[32m            status=AppointmentStatus.SCHEDULED.value,[m
[32m+[m[32m        ),[m
[32m+[m[32m        Appointment([m
[32m+[m[32m            title="Project Review",[m
[32m+[m[32m            description="Post-launch architecture and performance retrospective.",[m
[32m+[m[32m            date=today,[m
[32m+[m[32m            start_time=time(11, 30, 0),[m
[32m+[m[32m            end_time=time(12, 30, 0),[m
[32m+[m[32m            status=AppointmentStatus.COMPLETED.value,[m
[32m+[m[32m        ),[m
[32m+[m[32m        Appointment([m
[32m+[m[32m            title="Design Discussion",[m
[32m+[m[32m            description="Wireframe walkthrough for mobile appointment view (rescheduled).",[m
[32m+[m[32m            date=today,[m
[32m+[m[32m            start_time=time(13, 0, 0),[m
[32m+[m[32m            end_time=time(14, 0, 0),[m
[32m+[m[32m            status=AppointmentStatus.CANCELLED.value,[m
[32m+[m[32m        ),[m
[32m+[m[32m        Appointment([m
[32m+[m[32m            title="Candidate Interview",[m
[32m+[m[32m            description="Technical evaluation session for Full Stack Developer role.",[m
[32m+[m[32m            date=tomorrow,[m
[32m+[m[32m            start_time=time(14, 30, 0),[m
[32m+[m[32m            end_time=time(15, 30, 0),[m
[32m+[m[32m            status=AppointmentStatus.SCHEDULED.value,[m
[32m+[m[32m        ),[m
[32m+[m[32m    ][m
[32m+[m
[32m+[m[32m    db.add_all(sample_appointments)[m
[32m+[m[32m    db.commit()[m
[32m+[m[32m    print(f"Successfully seeded {len(sample_appointments)} sample appointments into the database.")[m
[1mdiff --git a/backend/requirements.txt b/backend/requirements.txt[m
[1mnew file mode 100644[m
[1mindex 0000000..6cb96bd[m
[1m--- /dev/null[m
[1m+++ b/backend/requirements.txt[m
[36m@@ -0,0 +1,7 @@[m
[32m+[m[32mfastapi>=0.115.0[m
[32m+[m[32muvicorn[standard]>=0.30.0[m
[32m+[m[32msqlalchemy>=2.0.30[m
[32m+[m[32mpymysql>=1.1.0[m
[32m+[m[32mcryptography>=42.0.0[m
[32m+[m[32mpydantic>=2.7.0[m
[32m+[m[32mpython-dotenv>=1.0.1[m
[1mdiff --git a/backend/tests/test_conflict.py b/backend/tests/test_conflict.py[m
[1mnew file mode 100644[m
[1mindex 0000000..cba8070[m
[1m--- /dev/null[m
[1m+++ b/backend/tests/test_conflict.py[m
[36m@@ -0,0 +1,181 @@[m
[32m+[m[32m"""[m
[32m+[m[32mUnit and integration test script for Appointment Board backend.[m
[32m+[m[32mTests:[m
[32m+[m[32m1. End time validation (end_time > start_time)[m
[32m+[m[32m2. Conflict detection:[m
[32m+[m[32m   - Overlap rejection (409)[m
[32m+[m[32m   - Back-to-back allowance[m
[32m+[m[32m   - Cancelled appointment exclusion[m
[32m+[m[32m3. State transitions (Complete, Cancel, disallow Cancelled -> Completed)[m
[32m+[m[32m4. Update conflict detection (excluding self)[m
[32m+[m[32m"""[m
[32m+[m
[32m+[m[32mimport sys[m
[32m+[m[32mfrom pathlib import Path[m
[32m+[m[32mimport unittest[m
[32m+[m[32mfrom datetime import date, time, timedelta[m
[32m+[m
[32m+[m[32m# Add backend directory to sys.path[m
[32m+[m[32mbackend_dir = Path(__file__).resolve().parent.parent[m
[32m+[m[32msys.path.insert(0, str(backend_dir))[m
[32m+[m
[32m+[m[32mfrom fastapi.exceptions import HTTPException[m
[32m+[m[32mfrom app.database import SessionLocal, engine, Base[m
[32m+[m[32mfrom app.models.appointment import Appointment, AppointmentStatus[m
[32m+[m[32mfrom app.schemas.appointment import AppointmentCreate, AppointmentUpdate[m
[32m+[m[32mfrom app.services import appointment_service[m
[32m+[m
[32m+[m
[32m+[m[32mclass TestAppointmentLogic(unittest.TestCase):[m
[32m+[m[32m    @classmethod[m
[32m+[m[32m    def setUpClass(cls):[m
[32m+[m[32m        Base.metadata.create_all(bind=engine)[m
[32m+[m
[32m+[m[32m    def setUp(self):[m
[32m+[m[32m        self.db = SessionLocal()[m
[32m+[m[32m        # Clean up existing test records with title starting with '[TEST]'[m
[32m+[m[32m        self.db.query(Appointment).filter(Appointment.title.like("[TEST]%")).delete()[m
[32m+[m[32m        self.db.commit()[m
[32m+[m[32m        self.test_date = date(2027, 1, 15)[m
[32m+[m
[32m+[m[32m    def tearDown(self):[m
[32m+[m[32m        self.db.query(Appointment).filter(Appointment.title.like("[TEST]%")).delete()[m
[32m+[m[32m        self.db.commit()[m
[32m+[m[32m        self.db.close()[m
[32m+[m
[32m+[m[32m    def test_end_time_must_be_after_start_time(self):[m
[32m+[m[32m        """Validates that end_time <= start_time raises 400."""[m
[32m+[m[32m        with self.assertRaises(HTTPException) as ctx:[m
[32m+[m[32m            appointment_service.create_appointment([m
[32m+[m[32m                self.db,[m
[32m+[m[32m                AppointmentCreate([m
[32m+[m[32m                    title="[TEST] Invalid Time",[m
[32m+[m[32m                    date=self.test_date,[m
[32m+[m[32m                    start_time=time(11, 0),[m
[32m+[m[32m                    end_time=time(10, 0),[m
[32m+[m[32m                ),[m
[32m+[m[32m            )[m
[32m+[m[32m        self.assertEqual(ctx.exception.status_code, 400)[m
[32m+[m[32m        self.assertIn("End time must be after start time", ctx.exception.detail)[m
[32m+[m
[32m+[m[32m    def test_conflict_detection_overlap_rejected(self):[m
[32m+[m[32m        """Validates that overlapping appointment raises 409 Conflict."""[m
[32m+[m[32m        # 1. Create initial appointment 10:00 - 11:00[m
[32m+[m[32m        app1 = appointment_service.create_appointment([m
[32m+[m[32m            self.db,[m
[32m+[m[32m            AppointmentCreate([m
[32m+[m[32m                title="[TEST] Slot 1",[m
[32m+[m[32m                date=self.test_date,[m
[32m+[m[32m                start_time=time(10, 0),[m
[32m+[m[32m                end_time=time(11, 0),[m
[32m+[m[32m            ),[m
[32m+[m[32m        )[m
[32m+[m[32m        self.assertIsNotNone(app1.id)[m
[32m+[m
[32m+[m[32m        # 2. Attempt overlapping appointment 10:30 - 11:30[m
[32m+[m[32m        with self.assertRaises(HTTPException) as ctx:[m
[32m+[m[32m            appointment_service.create_appointment([m
[32m+[m[32m                self.db,[m
[32m+[m[32m                AppointmentCreate([m
[32m+[m[32m                    title="[TEST] Overlapping Slot",[m
[32m+[m[32m                    date=self.test_date,[m
[32m+[m[32m                    start_time=time(10, 30),[m
[32m+[m[32m                    end_time=time(11, 30),[m
[32m+[m[32m                ),[m
[32m+[m[32m            )[m
[32m+[m[32m        self.assertEqual(ctx.exception.status_code, 409)[m
[32m+[m[32m        self.assertIn("conflicts with an existing appointment", ctx.exception.detail)[m
[32m+[m
[32m+[m[32m    def test_back_to_back_appointments_allowed(self):[m
[32m+[m[32m        """Validates that back-to-back appointment (10-11 and 11-12) is allowed."""[m
[32m+[m[32m        app1 = appointment_service.create_appointment([m
[32m+[m[32m            self.db,[m
[32m+[m[32m            AppointmentCreate([m
[32m+[m[32m                title="[TEST] Morning Session",[m
[32m+[m[32m                date=self.test_date,[m
[32m+[m[32m                start_time=time(10, 0),[m
[32m+[m[32m                end_time=time(11, 0),[m
[32m+[m[32m            ),[m
[32m+[m[32m        )[m
[32m+[m[32m        app2 = appointment_service.create_appointment([m
[32m+[m[32m            self.db,[m
[32m+[m[32m            AppointmentCreate([m
[32m+[m[32m                title="[TEST] Next Session",[m
[32m+[m[32m                date=self.test_date,[m
[32m+[m[32m                start_time=time(11, 0),[m
[32m+[m[32m                end_time=time(12, 0),[m
[32m+[m[32m            ),[m
[32m+[m[32m        )[m
[32m+[m[32m        self.assertIsNotNone(app1.id)[m
[32m+[m[32m        self.assertIsNotNone(app2.id)[m
[32m+[m
[32m+[m[32m    def test_cancelled_appointment_does_not_block_slot(self):[m
[32m+[m[32m        """Validates that a cancelled appointment does not block the same time slot."""[m
[32m+[m[32m        app1 = appointment_service.create_appointment([m
[32m+[m[32m            self.db,[m
[32m+[m[32m            AppointmentCreate([m
[32m+[m[32m                title="[TEST] Cancelled Slot",[m
[32m+[m[32m                date=self.test_date,[m
[32m+[m[32m                start_time=time(14, 0),[m
[32m+[m[32m                end_time=time(15, 0),[m
[32m+[m[32m            ),[m
[32m+[m[32m        )[m
[32m+[m[32m        # Cancel app1[m
[32m+[m[32m        appointment_service.cancel_appointment(self.db, app1.id)[m
[32m+[m
[32m+[m[32m        # Now create new appointment in the exact same slot 14:00 - 15:00[m
[32m+[m[32m        app2 = appointment_service.create_appointment([m
[32m+[m[32m            self.db,[m
[32m+[m[32m            AppointmentCreate([m
[32m+[m[32m                title="[TEST] New Slot Over Cancelled",[m
[32m+[m[32m                date=self.test_date,[m
[32m+[m[32m                start_time=time(14, 0),[m
[32m+[m[32m                end_time=time(15, 0),[m
[32m+[m[32m            ),[m
[32m+[m[32m        )[m
[32m+[m[32m        self.assertIsNotNone(app2.id)[m
[32m+[m
[32m+[m[32m    def test_update_allows_same_time_without_self_conflict(self):[m
[32m+[m[32m        """Updating title/description without changing time shouldn't conflict with itself."""[m
[32m+[m[32m        app1 = appointment_service.create_appointment([m
[32m+[m[32m            self.db,[m
[32m+[m[32m            AppointmentCreate([m
[32m+[m[32m                title="[TEST] Original",[m
[32m+[m[32m                date=self.test_date,[m
[32m+[m[32m                start_time=time(16, 0),[m
[32m+[m[32m                end_time=time(17, 0),[m
[32m+[m[32m            ),[m
[32m+[m[32m        )[m
[32m+[m[32m        updated = appointment_service.update_appointment([m
[32m+[m[32m            self.db,[m
[32m+[m[32m            app1.id,[m
[32m+[m[32m            AppointmentUpdate([m
[32m+[m[32m                title="[TEST] Updated Title",[m
[32m+[m[32m                description="New note",[m
[32m+[m[32m                date=self.test_date,[m
[32m+[m[32m                start_time=time(16, 0),[m
[32m+[m[32m                end_time=time(17, 0),[m
[32m+[m[32m            ),[m
[32m+[m[32m        )[m
[32m+[m[32m        self.assertEqual(updated.title, "[TEST] Updated Title")[m
[32m+[m
[32m+[m[32m    def test_cannot_complete_cancelled_appointment(self):[m
[32m+[m[32m        """Transitioning Cancelled -> Completed must raise 400 Bad Request."""[m
[32m+[m[32m        app = appointment_service.create_appointment([m
[32m+[m[32m            self.db,[m
[32m+[m[32m            AppointmentCreate([m
[32m+[m[32m                title="[TEST] To Cancel",[m
[32m+[m[32m                date=self.test_date,[m
[32m+[m[32m                start_time=time(17, 0),[m
[32m+[m[32m                end_time=time(18, 0),[m
[32m+[m[32m            ),[m
[32m+[m[32m        )[m
[32m+[m[32m        appointment_service.cancel_appointment(self.db, app.id)[m
[32m+[m
[32m+[m[32m        with self.assertRaises(HTTPException) as ctx:[m
[32m+[m[32m            appointment_service.complete_appointment(self.db, app.id)[m
[32m+[m[32m        self.assertEqual(ctx.exception.status_code, 400)[m
[32m+[m
[32m+[m
[32m+[m[32mif __name__ == "__main__":[m
[32m+[m[32m    unittest.main()[m
[1mdiff --git a/frontend/.gitignore b/frontend/.gitignore[m
[1mnew file mode 100644[m
[1mindex 0000000..a547bf3[m
[1m--- /dev/null[m
[1m+++ b/frontend/.gitignore[m
[36m@@ -0,0 +1,24 @@[m
[32m+[m[32m# Logs[m
[32m+[m[32mlogs[m
[32m+[m[32m*.log[m
[32m+[m[32mnpm-debug.log*[m
[32m+[m[32myarn-debug.log*[m
[32m+[m[32myarn-error.log*[m
[32m+[m[32mpnpm-debug.log*[m
[32m+[m[32mlerna-debug.log*[m
[32m+[m
[32m+[m[32mnode_modules[m
[32m+[m[32mdist[m
[32m+[m[32mdist-ssr[m
[32m+[m[32m*.local[m
[32m+[m
[32m+[m[32m# Editor directories and files[m
[32m+[m[32m.vscode/*[m
[32m+[m[32m!.vscode/extensions.json[m
[32m+[m[32m.idea[m
[32m+[m[32m.DS_Store[m
[32m+[m[32m*.suo[m
[32m+[m[32m*.ntvs*[m
[32m+[m[32m*.njsproj[m
[32m+[m[32m*.sln[m
[32m+[m[32m*.sw?[m
[1mdiff --git a/frontend/.oxlintrc.json b/frontend/.oxlintrc.json[m
[1mnew file mode 100644[m
[1mindex 0000000..1255078[m
[1m--- /dev/null[m
[1m+++ b/frontend/.oxlintrc.json[m
[36m@@ -0,0 +1,8 @@[m
[32m+[m[32m{[m
[32m+[m[32m  "$schema": "./node_modules/oxlint/configuration_schema.json",[m
[32m+[m[32m  "plugins": ["react", "oxc"],[m
[32m+[m[32m  "rules": {[m
[32m+[m[32m    "react/rules-of-hooks": "error",[m
[32m+[m[32m    "react/only-export-components": ["warn", { "allowConstantExport": true }][m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[1mdiff --git a/frontend/README.md b/frontend/README.md[m
[1mnew file mode 100644[m
[1mindex 0000000..d937833[m
[1m--- /dev/null[m
[1m+++ b/frontend/README.md[m
[36m@@ -0,0 +1,16 @@[m
[32m+[m[32m# React + Vite[m
[32m+[m
[32m+[m[32mThis template provides a minimal setup to get React working in Vite with HMR and some Oxlint rules.[m
[32m+[m
[32m+[m[32mCurrently, two official plugins are available:[m
[32m+[m
[32m+[m[32m- [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react) uses [Oxc](https://oxc.rs)[m
[32m+[m[32m- [@vitejs/plugin-react-swc](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react-swc) uses [SWC](https://swc.rs/)[m
[32m+[m
[32m+[m[32m## React Compiler[m
[32m+[m
[32m+[m[32mThe React Compiler is not enabled on this template because of its impact on dev & build performances. To add it, see [this documentation](https://react.dev/learn/react-compiler/installation).[m
[32m+[m
[32m+[m[32m## Expanding the Oxlint configuration[m
[32m+[m
[32m+[m[32mIf you are developing a production application, we recommend using TypeScript with type-aware lint rules enabled. Check out the [TS template](https://github.com/vitejs/vite/tree/main/packages/create-vite/template-react-ts) for information on how to integrate TypeScript and Oxlint's TypeScript related rules in your project.[m
[1mdiff --git a/frontend/index.html b/frontend/index.html[m
[1mnew file mode 100644[m
[1mindex 0000000..0440641[m
[1m--- /dev/null[m
[1m+++ b/frontend/index.html[m
[36m@@ -0,0 +1,17 @@[m
[32m+[m[32m<!doctype html>[m
[32m+[m[32m<html lang="en">[m
[32m+[m[32m  <head>[m
[32m+[m[32m    <meta charset="UTF-8" />[m
[32m+[m[32m    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%232563eb' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><rect width='18' height='18' x='3' y='4' rx='2' ry='2'/><line x1='16' x2='16' y1='2' y2='6'/><line x1='8' x2='8' y1='2' y2='6'/><line x1='3' x2='21' y1='10' y2='10'/></svg>" />[m
[32m+[m[32m    <meta name="viewport" content="width=device-width, initial-scale=1.0" />[m
[32m+[m[32m    <meta name="description" content="Professional Appointment Board application for team scheduling with automated conflict detection." />[m
[32m+[m[32m    <link rel="preconnect" href="https://fonts.googleapis.com">[m
[32m+[m[32m    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>[m
[32m+[m[32m    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">[m
[32m+[m[32m    <title>Appointment Board - Team Schedule Management</title>[m
[32m+[m[32m  </head>[m
[32m+[m[32m  <body class="bg-slate-50 font-['Plus_Jakarta_Sans',sans-serif]">[m
[32m+[m[32m    <div id="root"></div>[m
[32m+[m[32m    <script type="module" src="/src/main.jsx"></script>[m
[32m+[m[32m  </body>[m
[32m+[m[32m</html>[m
[1mdiff --git a/frontend/package-lock.json b/frontend/package-lock.json[m
[1mnew file mode 100644[m
[1mindex 0000000..b4c3b06[m
[1m--- /dev/null[m
[1m+++ b/frontend/package-lock.json[m
[36m@@ -0,0 +1,2177 @@[m
[32m+[m[32m{[m
[32m+[m[32m  "name": "frontend",[m
[32m+[m[32m  "version": "0.0.0",[m
[32m+[m[32m  "lockfileVersion": 3,[m
[32m+[m[32m  "requires": true,[m
[32m+[m[32m  "packages": {[m
[32m+[m[32m    "": {[m
[32m+[m[32m      "name": "frontend",[m
[32m+[m[32m      "version": "0.0.0",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@tailwindcss/vite": "^4.3.3",[m
[32m+[m[32m        "axios": "^1.20.0",[m
[32m+[m[32m        "lucide-react": "^1.44.0",[m
[32m+[m[32m        "react": "^19.2.8",[m
[32m+[m[32m        "react-dom": "^19.2.8",[m
[32m+[m[32m        "tailwindcss": "^4.3.3"[m
[32m+[m[32m      },[m
[32m+[m[32m      "devDependencies": {[m
[32m+[m[32m        "@types/react": "^19.2.18",[m
[32m+[m[32m        "@types/react-dom": "^19.2.7",[m
[32m+[m[32m        "@vitejs/plugin-react": "^6.1.1",[m
[32m+[m[32m        "oxlint": "^1.81.0",[m
[32m+[m[32m        "vite": "^8.3.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@jridgewell/gen-mapping": {[m
[32m+[m[32m      "version": "0.3.13",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@jridgewell/gen-mapping/-/gen-mapping-0.3.13.tgz",[m
[32m+[m[32m      "integrity": "sha512-2kkt/7niJ6MgEPxF0bYdQ6etZaA+fQvDcLKckhy1yIQOzaoKjBBjSj63/aLVjYE3qhRt5dvM+uUyfCg6UKCBbA==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@jridgewell/sourcemap-codec": "^1.5.0",[m
[32m+[m[32m        "@jridgewell/trace-mapping": "^0.3.24"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@jridgewell/remapping": {[m
[32m+[m[32m      "version": "2.3.5",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@jridgewell/remapping/-/remapping-2.3.5.tgz",[m
[32m+[m[32m      "integrity": "sha512-LI9u/+laYG4Ds1TDKSJW2YPrIlcVYOwi2fUC6xB43lueCjgxV4lffOCZCtYFiH6TNOX+tQKXx97T4IKHbhyHEQ==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@jridgewell/gen-mapping": "^0.3.5",[m
[32m+[m[32m        "@jridgewell/trace-mapping": "^0.3.24"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@jridgewell/resolve-uri": {[m
[32m+[m[32m      "version": "3.1.2",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.2.tgz",[m
[32m+[m[32m      "integrity": "sha512-bRISgCIjP20/tbWSPWMEi54QVPRZExkuD9lJL+UIxUKtwVJA8wW1Trb1jMs1RFXo1CBTNZ/5hpC9QvmKWdopKw==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">=6.0.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@jridgewell/sourcemap-codec": {[m
[32m+[m[32m      "version": "1.6.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.6.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-T7jf+5zgsZHwNJ4lvQ7/aezbyk0nNX+zJVWpmHA7VYsEx7a7qr5Rg5IbtJFqkgze5Y2sruq1RUY8Q837Od7iFw==",[m
[32m+[m[32m      "license": "MIT"[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@jridgewell/trace-mapping": {[m
[32m+[m[32m      "version": "0.3.31",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.31.tgz",[m
[32m+[m[32m      "integrity": "sha512-zzNR+SdQSDJzc8joaeP8QQoCQr8NuYx2dIIytl1QeBEZHJ9uW6hebsrYgbz8hJwUQao3TWCMtmfV8Nu1twOLAw==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@jridgewell/resolve-uri": "^3.1.0",[m
[32m+[m[32m        "@jridgewell/sourcemap-codec": "^1.4.14"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@oxc-project/types": {[m
[32m+[m[32m      "version": "0.149.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@oxc-project/types/-/types-0.149.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-Efcc+iF0j3Bf67YjEqIqWXbX5XddXoK/Mw4K1/JuXwRCZ8N16VR7iT23nlCc9XrveFVh/E5Rqs2StT0V8v9LdA==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "url": "https://github.com/sponsors/oxc-project"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@oxlint/binding-android-arm-eabi": {[m
[32m+[m[32m      "version": "1.82.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@oxlint/binding-android-arm-eabi/-/binding-android-arm-eabi-1.82.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-a3LB+C5Dsj5b/qtmG/mv5WrzuiXEpg1KF5nXWcEvaoN5TYAqkIvxPOwTPp3Jy/FoGpRo8zsTFhMElMXfeoOEzA==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "android"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@oxlint/binding-android-arm64": {[m
[32m+[m[32m      "version": "1.82.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@oxlint/binding-android-arm64/-/binding-android-arm64-1.82.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-OBlhRgNqFblGpGenno/aqOfJLOkQ2B8Ig3iDAalfn0H8hJGZKXPeexCRTDm6uwv6YUjSA9Xnwt1y/Bgj5ZH8uw==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "android"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@oxlint/binding-darwin-arm64": {[m
[32m+[m[32m      "version": "1.82.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@oxlint/binding-darwin-arm64/-/binding-darwin-arm64-1.82.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-dsopxqtY5ZdyT9uLHyGt1SyiLop6hi7hWI3PKpePodkRQOkLaCm+OE4fR9CAz9qdfjiFO8531tX/QDyP/psjFg==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "darwin"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@oxlint/binding-darwin-x64": {[m
[32m+[m[32m      "version": "1.82.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@oxlint/binding-darwin-x64/-/binding-darwin-x64-1.82.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-94Lu0SgTClKColU66g1VDuigV3HkcbkJBnTtZjGYfE8UPugaWDgKrm2icjC6HJVUYler2OXaHP/X0TBy8+CowQ==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "x64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "darwin"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@oxlint/binding-freebsd-x64": {[m
[32m+[m[32m      "version": "1.82.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@oxlint/binding-freebsd-x64/-/binding-freebsd-x64-1.82.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-hne/V06ewhh1i0w8+l7GDNROAGCGPmyFuOwiP7YTRu0JycyStJ4785dmF8xU5p0uUwt2emvIF9vc7Xjis+cJ0g==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "x64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "freebsd"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@oxlint/binding-linux-arm-gnueabihf": {[m
[32m+[m[32m      "version": "1.82.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@oxlint/binding-linux-arm-gnueabihf/-/binding-linux-arm-gnueabihf-1.82.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-aWY2xtbZf1LneW9Qsv/n2Sp8gOu74JrlQzEtj4coHX2SHFrCfhmAumaU+sI/A5nr+yoTRTSmI/pL2s6ADlNSkw==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@oxlint/binding-linux-arm-musleabihf": {[m
[32m+[m[32m      "version": "1.82.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@oxlint/binding-linux-arm-musleabihf/-/binding-linux-arm-musleabihf-1.82.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-Fe+TtXCXMh/5f7kWlZ2VAwsMumZWtraFlKVk1NJlL52/beGwfDE7ov+/8gVirHzWokzGu7X65hSPq0ucPDskWQ==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@oxlint/binding-linux-arm64-gnu": {[m
[32m+[m[32m      "version": "1.82.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@oxlint/binding-linux-arm64-gnu/-/binding-linux-arm64-gnu-1.82.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-6azCZ6OJudlvipNttXCCQcyeFfcJ/NvUZdSN1z8elo73kCHtyQC7WTiUcSjWYvJ1jaq9KDUyMAoAS/vNzhBomA==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@oxlint/binding-linux-arm64-musl": {[m
[32m+[m[32m      "version": "1.82.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@oxlint/binding-linux-arm64-musl/-/binding-linux-arm64-musl-1.82.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-PLEaSD8IAIIlwW4dwOd9YaxuxeOpwiXL4J24rcnE4iNtyM5j9Q9/3+gti08oXpx0u2ygNjRDx9xjWWpQonuJEw==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@oxlint/binding-linux-ppc64-gnu": {[m
[32m+[m[32m      "version": "1.82.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@oxlint/binding-linux-ppc64-gnu/-/binding-linux-ppc64-gnu-1.82.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-D94em/BwknNTn4vqxjHh5wb2oL566eFhArabqKIr0cNZMHOJuiraFp1A8tXpH05bbE5tqwEfLXTI0MWEGtn3Dw==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "ppc64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@oxlint/binding-linux-riscv64-gnu": {[m
[32m+[m[32m      "version": "1.82.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@oxlint/binding-linux-riscv64-gnu/-/binding-linux-riscv64-gnu-1.82.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-MOprxBaoYU2D4VgxXCl3ghydThWtx7Um1lL51kGYNeQ5Al7WzsH7/tqGdNtbLrIWnjq3bsm13+nz/gRIxjrOXw==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "riscv64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@oxlint/binding-linux-riscv64-musl": {[m
[32m+[m[32m      "version": "1.82.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@oxlint/binding-linux-riscv64-musl/-/binding-linux-riscv64-musl-1.82.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-5h55QsfJ/luDXZzC20k6SNOY1Az+dCP9WvntKtcUWh2JhckAdwApY2ZusaBTwLENnReXU+A2fJtSrYvZJNKNPg==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "riscv64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@oxlint/binding-linux-s390x-gnu": {[m
[32m+[m[32m      "version": "1.82.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@oxlint/binding-linux-s390x-gnu/-/binding-linux-s390x-gnu-1.82.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-IE8NJNLlHr0CaXyGJPGVn0eTkUyoj1I2UfA8x7I4PSOYKsQ/6btVC7Pywrj5onk0cMH25r6Z38SoN3AvE5Zuog==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "s390x"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@oxlint/binding-linux-x64-gnu": {[m
[32m+[m[32m      "version": "1.82.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@oxlint/binding-linux-x64-gnu/-/binding-linux-x64-gnu-1.82.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-XUUUxaBo9XKl+J1B9EmP1cTGQPddzeURvoGkfwh/94PGnbW+hBprDljneoI2M1jzC1bzrIV3ihc7iM9UXl8+tg==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "x64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@oxlint/binding-linux-x64-musl": {[m
[32m+[m[32m      "version": "1.82.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@oxlint/binding-linux-x64-musl/-/binding-linux-x64-musl-1.82.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-SWLSFulX9TDuH6yvbPYp4+VNn6jkkIvvI+KiujDM5rWBRHEfkesCC/pCneIIUr6ovkxZ5fRtpi2v5Cz5FrMJZg==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "x64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@oxlint/binding-openharmony-arm64": {[m
[32m+[m[32m      "version": "1.82.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@oxlint/binding-openharmony-arm64/-/binding-openharmony-arm64-1.82.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-BQy35f6ZUdNr9a6c7B7orxQTcLjByGT2z3WAgmRovpRwmPYAaJ+NTplmMzhdjdJ4qSchfMNZy/Ukg+qRg6zseQ==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "openharmony"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@oxlint/binding-win32-arm64-msvc": {[m
[32m+[m[32m      "version": "1.82.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@oxlint/binding-win32-arm64-msvc/-/binding-win32-arm64-msvc-1.82.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-V4QhSTg5gctZue8RJjsGi7NpQPThr/p1/HfmiMC5kfe1KFEup9SQRVub4A6kijQjdHfxj7bLL1KO3QO7/5bwMQ==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "win32"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@oxlint/binding-win32-ia32-msvc": {[m
[32m+[m[32m      "version": "1.82.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@oxlint/binding-win32-ia32-msvc/-/binding-win32-ia32-msvc-1.82.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-TUSCLaKB2yktpFAJ/r3HAUYsaV/3DT7JS4iNKyoh3a9YNwD0UG7Ezh4D8m23654vQcU6P/RQrCAjRPKe4peP/A==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "ia32"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "win32"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@oxlint/binding-win32-x64-msvc": {[m
[32m+[m[32m      "version": "1.82.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@oxlint/binding-win32-x64-msvc/-/binding-win32-x64-msvc-1.82.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-VTVoRIWJTb+wvUX8EYoPArfFH02whuR10goFXE/LHRRX33ajRrFgqbcONXZMiF4C5rnattfkm87HqYn8jb8hmQ==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "x64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "win32"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@rolldown/binding-android-arm-eabi": {[m
[32m+[m[32m      "version": "1.2.8",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@rolldown/binding-android-arm-eabi/-/binding-android-arm-eabi-1.2.8.tgz",[m
[32m+[m[32m      "integrity": "sha512-tN5aztYkKCte4i5SIrrz5yK/HMjEuCqCSCJa418jOV8tZ1cBY3YF2otxB1ktPxzsLA1BeTqwapK0bfjxNvHJVw==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "android"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@rolldown/binding-android-arm64": {[m
[32m+[m[32m      "version": "1.2.8",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@rolldown/binding-android-arm64/-/binding-android-arm64-1.2.8.tgz",[m
[32m+[m[32m      "integrity": "sha512-dIYTWl9XprMUiQFoc55KUyk/oS8SKYH3zFl0LTR7RT0Xj4hgSVyuJcroH8JUu8RcpF8fTB6E0aOwCkZoYPcDSQ==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "android"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@rolldown/binding-darwin-arm64": {[m
[32m+[m[32m      "version": "1.2.8",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@rolldown/binding-darwin-arm64/-/binding-darwin-arm64-1.2.8.tgz",[m
[32m+[m[32m      "integrity": "sha512-PCSDQGXD2IyTEFrcgPyBM8jJuGmrbCMuoIOXdbEGVemruKACXoLQJrb+A45Z0L5t1RQkdfJprAYPkikbh7dzdA==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "darwin"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@rolldown/binding-darwin-x64": {[m
[32m+[m[32m      "version": "1.2.8",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@rolldown/binding-darwin-x64/-/binding-darwin-x64-1.2.8.tgz",[m
[32m+[m[32m      "integrity": "sha512-Uk7lRsGhPFHVX/sAUC6D5H9Ol30dFHd6iquokll2th3LpdJ3F5CzQB+7DHn0Ri2mG+U7k2zXiPHDrwZenXhwSA==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "x64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "darwin"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@rolldown/binding-freebsd-x64": {[m
[32m+[m[32m      "version": "1.2.8",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@rolldown/binding-freebsd-x64/-/binding-freebsd-x64-1.2.8.tgz",[m
[32m+[m[32m      "integrity": "sha512-DjszaTEVogPqA5bYzsEeqDCQxbcp2fexQwKcRspYji2yzR68fCf+e4fx6kBSRDwX5/brZaHw/hWS9+A/+/w9sQ==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "x64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "freebsd"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@rolldown/binding-linux-arm-gnueabihf": {[m
[32m+[m[32m      "version": "1.2.8",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@rolldown/binding-linux-arm-gnueabihf/-/binding-linux-arm-gnueabihf-1.2.8.tgz",[m
[32m+[m[32m      "integrity": "sha512-zmwa7FTmdzB6aaEEuuls18H6Ap5JmJPSoPTuXixeJZV6tG40SyLkApQtz1g8ptZtiEKqj9OM0oNLPh1AgvE31Q==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@rolldown/binding-linux-arm64-gnu": {[m
[32m+[m[32m      "version": "1.2.8",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@rolldown/binding-linux-arm64-gnu/-/binding-linux-arm64-gnu-1.2.8.tgz",[m
[32m+[m[32m      "integrity": "sha512-KdYQDPHwJVnbFwdTGMgxsI9SqblBlz6STGM+w1We/d5B8OWWidYH0MwkU/uA1wM5fIpO2MkOVxXrNzzuZhw9ew==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@rolldown/binding-linux-arm64-musl": {[m
[32m+[m[32m      "version": "1.2.8",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@rolldown/binding-linux-arm64-musl/-/binding-linux-arm64-musl-1.2.8.tgz",[m
[32m+[m[32m      "integrity": "sha512-jFJTifHnNPY+yzOoNZQfSIysrVyXzEQPhPnOUjmD1bcQGHH6s7c8cViKWar8YplQImE5N9JRqMCLrM2CdxOrZA==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@rolldown/binding-linux-ppc64-gnu": {[m
[32m+[m[32m      "version": "1.2.8",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@rolldown/binding-linux-ppc64-gnu/-/binding-linux-ppc64-gnu-1.2.8.tgz",[m
[32m+[m[32m      "integrity": "sha512-FhiOziBDWPBjbcmRzfLyIJnaP7AVMFXT7YCXPjXxj7wKU3vx24RjrCNN/zjvVa+N2vVoHJwCoUBvsrN/DG3zIA==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "ppc64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@rolldown/binding-linux-s390x-gnu": {[m
[32m+[m[32m      "version": "1.2.8",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@rolldown/binding-linux-s390x-gnu/-/binding-linux-s390x-gnu-1.2.8.tgz",[m
[32m+[m[32m      "integrity": "sha512-WnHfADMzOV2Y55wlx1hzzQnar/wDt/VdvWSD99r18Mz9ylNieIGOkRx3UV21h7m/eJvjySYJkO26VvGNFkwsIQ==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "s390x"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@rolldown/binding-linux-x64-gnu": {[m
[32m+[m[32m      "version": "1.2.8",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@rolldown/binding-linux-x64-gnu/-/binding-linux-x64-gnu-1.2.8.tgz",[m
[32m+[m[32m      "integrity": "sha512-H9tRr5ibfXFVLxbPOseVewewFpl28zcEdjRDt2FTUZU7odxP0gEv1ki4/kGmcGOh78oRwZuuQllGLZ9zTJp84g==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "x64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@rolldown/binding-linux-x64-musl": {[m
[32m+[m[32m      "version": "1.2.8",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@rolldown/binding-linux-x64-musl/-/binding-linux-x64-musl-1.2.8.tgz",[m
[32m+[m[32m      "integrity": "sha512-UefiqfM3D6IVNlZ8tSGs9+Ejjud2T+oxO0IHADU45Y+lyEjD2dVFyZHbkfX0LUb5Zugo/oIv1eCO/KVYhgYJYA==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "x64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@rolldown/binding-openharmony-arm64": {[m
[32m+[m[32m      "version": "1.2.8",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@rolldown/binding-openharmony-arm64/-/binding-openharmony-arm64-1.2.8.tgz",[m
[32m+[m[32m      "integrity": "sha512-637Ke4kWSy6rp9cxQ9gMOXlxPgIw/c1beASV4M//3+9I4uwBVOOl74G+e3zyU3u19U7RkRl/HuewixZ/Z6+Rjg==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "openharmony"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@rolldown/binding-win32-arm64-msvc": {[m
[32m+[m[32m      "version": "1.2.8",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@rolldown/binding-win32-arm64-msvc/-/binding-win32-arm64-msvc-1.2.8.tgz",[m
[32m+[m[32m      "integrity": "sha512-xWBkPOF1Q9k/Gv1nQXnVdLxKu74jXppuOM4Z3mnypVUJJJwLsMl7hNJGRAUJoG8A5MgOI1ACKM+wBFxSJzKy4A==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "win32"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@rolldown/binding-win32-x64-msvc": {[m
[32m+[m[32m      "version": "1.2.8",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@rolldown/binding-win32-x64-msvc/-/binding-win32-x64-msvc-1.2.8.tgz",[m
[32m+[m[32m      "integrity": "sha512-uz2ZvfgXbxqNwijjjbxrnvALwpyODDcgc1T1N8N3rf/DXKQmaFwmB4LX4yyjggpwN2obdQLb2rgirX5ffCWYng==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "x64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "win32"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@rolldown/pluginutils": {[m
[32m+[m[32m      "version": "1.0.1",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@rolldown/pluginutils/-/pluginutils-1.0.1.tgz",[m
[32m+[m[32m      "integrity": "sha512-2j9bGt5Jh8hj+vPtgzPtl72j0yRxHAyumoo6TNfAjsLB04UtpSvPbPcDcBMxz7n+9CYB0c1GxQFxYRg2jimqGw==",[m
[32m+[m[32m      "license": "MIT"[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@tailwindcss/node": {[m
[32m+[m[32m      "version": "4.3.3",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@tailwindcss/node/-/node-4.3.3.tgz",[m
[32m+[m[32m      "integrity": "sha512-/T8IKEsf9VTU6tLjgC7+sv2mOPtQxzE2jMw7u4Tt40Tx+QSZxpzh95/H6cMKoja9XuW7iMdLJYBB0o9G1CaAgg==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@jridgewell/remapping": "^2.3.5",[m
[32m+[m[32m        "enhanced-resolve": "^5.24.1",[m
[32m+[m[32m        "jiti": "^2.7.0",[m
[32m+[m[32m        "lightningcss": "1.32.0",[m
[32m+[m[32m        "magic-string": "^0.30.21",[m
[32m+[m[32m        "source-map-js": "^1.2.1",[m
[32m+[m[32m        "tailwindcss": "4.3.3"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@tailwindcss/oxide": {[m
[32m+[m[32m      "version": "4.3.3",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@tailwindcss/oxide/-/oxide-4.3.3.tgz",[m
[32m+[m[32m      "integrity": "sha512-krXjAikiaFSPaK/FkAQT5UTx3VormQaiZ5hBFlJZ9UFQGB/rwg1MZIhHAG9smMQRTdyJxP6Qt5MwMtdyU5FWrA==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 20"[m
[32m+[m[32m      },[m
[32m+[m[32m      "optionalDependencies": {[m
[32m+[m[32m        "@tailwindcss/oxide-android-arm64": "4.3.3",[m
[32m+[m[32m        "@tailwindcss/oxide-darwin-arm64": "4.3.3",[m
[32m+[m[32m        "@tailwindcss/oxide-darwin-x64": "4.3.3",[m
[32m+[m[32m        "@tailwindcss/oxide-freebsd-x64": "4.3.3",[m
[32m+[m[32m        "@tailwindcss/oxide-linux-arm-gnueabihf": "4.3.3",[m
[32m+[m[32m        "@tailwindcss/oxide-linux-arm64-gnu": "4.3.3",[m
[32m+[m[32m        "@tailwindcss/oxide-linux-arm64-musl": "4.3.3",[m
[32m+[m[32m        "@tailwindcss/oxide-linux-x64-gnu": "4.3.3",[m
[32m+[m[32m        "@tailwindcss/oxide-linux-x64-musl": "4.3.3",[m
[32m+[m[32m        "@tailwindcss/oxide-wasm32-wasi": "4.3.3",[m
[32m+[m[32m        "@tailwindcss/oxide-win32-arm64-msvc": "4.3.3",[m
[32m+[m[32m        "@tailwindcss/oxide-win32-x64-msvc": "4.3.3"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@tailwindcss/oxide-android-arm64": {[m
[32m+[m[32m      "version": "4.3.3",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@tailwindcss/oxide-android-arm64/-/oxide-android-arm64-4.3.3.tgz",[m
[32m+[m[32m      "integrity": "sha512-Y85A2gmPSkl5Ve5qR86GL4HT509cFqQh1aes9p3sSkyTPwt0Pppf3GkwGe4JPACcRYjgJIEhQgM6dBClnr0NYw==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "android"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 20"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@tailwindcss/oxide-darwin-arm64": {[m
[32m+[m[32m      "version": "4.3.3",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@tailwindcss/oxide-darwin-arm64/-/oxide-darwin-arm64-4.3.3.tgz",[m
[32m+[m[32m      "integrity": "sha512-BiaWatpBcERQFDlOjRDpIVXuFK5PJez5SA4JMg6VYZdBYU+qKfV/vqjcIs+IYmtitf1xYQZTwXvU/8y4lfZUGw==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "darwin"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 20"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@tailwindcss/oxide-darwin-x64": {[m
[32m+[m[32m      "version": "4.3.3",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@tailwindcss/oxide-darwin-x64/-/oxide-darwin-x64-4.3.3.tgz",[m
[32m+[m[32m      "integrity": "sha512-fAeUqfV5ndhxRwai8cXGzdLvul9utWOmeTkv69unv4ZXixjn61Z+p9lCWdwOwA3TYboG3BwdVuN/RDjhBRl0mw==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "x64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "darwin"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 20"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@tailwindcss/oxide-freebsd-x64": {[m
[32m+[m[32m      "version": "4.3.3",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@tailwindcss/oxide-freebsd-x64/-/oxide-freebsd-x64-4.3.3.tgz",[m
[32m+[m[32m      "integrity": "sha512-iyf5bV6+wnAlflVeEy7R25dupxTNECZN5QMI0qNT6eT+EgaGdZcKhGkr5SdoaWiLJ3spLqIY9VCeSGrwmtg4kw==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "x64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "freebsd"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 20"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@tailwindcss/oxide-linux-arm-gnueabihf": {[m
[32m+[m[32m      "version": "4.3.3",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@tailwindcss/oxide-linux-arm-gnueabihf/-/oxide-linux-arm-gnueabihf-4.3.3.tgz",[m
[32m+[m[32m      "integrity": "sha512-aAYUprJAJQWWbRrPvtjdroZ56Md+JM8pMiopS6xGEwDfLhqj+2ver2p4nU4Mb3CRqcMmNBjo8KkUgcxhkzVQGQ==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 20"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@tailwindcss/oxide-linux-arm64-gnu": {[m
[32m+[m[32m      "version": "4.3.3",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@tailwindcss/oxide-linux-arm64-gnu/-/oxide-linux-arm64-gnu-4.3.3.tgz",[m
[32m+[m[32m      "integrity": "sha512-nDxldcEENOxZRzC2uu9jrutZdAAQtb+8WWDCSnWL1zvBk1+FN+x6MtDViPB5AJMfttVCUhehGWus3XBPgatM/w==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 20"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@tailwindcss/oxide-linux-arm64-musl": {[m
[32m+[m[32m      "version": "4.3.3",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@tailwindcss/oxide-linux-arm64-musl/-/oxide-linux-arm64-musl-4.3.3.tgz",[m
[32m+[m[32m      "integrity": "sha512-Md44bD6veX/PC5iyF8cDVnw4HBIANZepRZZ7a8DQOvkfo5WUBwcp6iAuCUz23u+4SUkhJlD3eL7hNdW8ezd/kA==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 20"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@tailwindcss/oxide-linux-x64-gnu": {[m
[32m+[m[32m      "version": "4.3.3",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@tailwindcss/oxide-linux-x64-gnu/-/oxide-linux-x64-gnu-4.3.3.tgz",[m
[32m+[m[32m      "integrity": "sha512-tx7us1muwOKAKWao2v/GaafFeQboE6aj88vC6ziN2NCGcRm8gWUhwjzg+YdVB1e4boAtdtma4L43onunI6NS4w==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "x64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 20"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@tailwindcss/oxide-linux-x64-musl": {[m
[32m+[m[32m      "version": "4.3.3",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@tailwindcss/oxide-linux-x64-musl/-/oxide-linux-x64-musl-4.3.3.tgz",[m
[32m+[m[32m      "integrity": "sha512-SJxX60smvHgasZoBy11dX6YRjXJFovwWBoedhbQPOBzgFWBHGB+TVPWB9BxzR7TTxU8FQZAI2AyiNCMzFm8Img==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "x64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 20"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@tailwindcss/oxide-wasm32-wasi": {[m
[32m+[m[32m      "version": "4.3.3",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@tailwindcss/oxide-wasm32-wasi/-/oxide-wasm32-wasi-4.3.3.tgz",[m
[32m+[m[32m      "integrity": "sha512-jx1+rPhY/5Ympkktd656HBWEBLxP7dH06losBLjjf5vgCODXvi9KhtftWcMIwTFIDqBr7cRnQkdLnAG+IOlGvQ==",[m
[32m+[m[32m      "bundleDependencies": [[m
[32m+[m[32m        "@napi-rs/wasm-runtime",[m
[32m+[m[32m        "@emnapi/core",[m
[32m+[m[32m        "@emnapi/runtime",[m
[32m+[m[32m        "@tybys/wasm-util",[m
[32m+[m[32m        "@emnapi/wasi-threads",[m
[32m+[m[32m        "tslib"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "wasm32"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@emnapi/core": "^1.11.1",[m
[32m+[m[32m        "@emnapi/runtime": "^1.11.1",[m
[32m+[m[32m        "@emnapi/wasi-threads": "^1.2.2",[m
[32m+[m[32m        "@napi-rs/wasm-runtime": "^1.1.4",[m
[32m+[m[32m        "@tybys/wasm-util": "^0.10.2",[m
[32m+[m[32m        "tslib": "^2.8.1"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">=14.0.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@tailwindcss/oxide-win32-arm64-msvc": {[m
[32m+[m[32m      "version": "4.3.3",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@tailwindcss/oxide-win32-arm64-msvc/-/oxide-win32-arm64-msvc-4.3.3.tgz",[m
[32m+[m[32m      "integrity": "sha512-3rc292Ca2ceK6Ulcc/bAVnTs/3nDtoPhyEKlgPv+yQJQi/JS/AMJlqzxvlDacL1nekbrcf6bTqp/jV4qgnPxNQ==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "win32"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 20"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@tailwindcss/oxide-win32-x64-msvc": {[m
[32m+[m[32m      "version": "4.3.3",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@tailwindcss/oxide-win32-x64-msvc/-/oxide-win32-x64-msvc-4.3.3.tgz",[m
[32m+[m[32m      "integrity": "sha512-yJ0pwIVc/nYeGoV02WtsN8KYyLQv7kyI2wDnkezyJlGGjkd4QLwDGAwl47YpPJeuI0M0ObaXGSPjvWDPeTPggw==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "x64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "win32"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 20"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@tailwindcss/vite": {[m
[32m+[m[32m      "version": "4.3.3",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@tailwindcss/vite/-/vite-4.3.3.tgz",[m
[32m+[m[32m      "integrity": "sha512-yYU8cogLeSh/ms2jh8Fj7jaba/EWa7Ja6GoUqYZaraEuCI5YS6ms6ObZgjjedm+jm6XZjdNRWBpPP6Z86oOxcw==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@tailwindcss/node": "4.3.3",[m
[32m+[m[32m        "@tailwindcss/oxide": "4.3.3",[m
[32m+[m[32m        "tailwindcss": "4.3.3"[m
[32m+[m[32m      },[m
[32m+[m[32m      "peerDependencies": {[m
[32m+[m[32m        "vite": "^5.2.0 || ^6 || ^7 || ^8"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@types/react": {[m
[32m+[m[32m      "version": "19.3.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@types/react/-/react-19.3.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-N0rFCuH9YoxG9/m61l9MfpJKfmLOVU0em7ipIz6TRgSSkvReLB9vL85GB+yr8Bs5leqpvg96JSwF4ZS1s4viQg==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "peer": true,[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "csstype": "^3.2.2"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@types/react-dom": {[m
[32m+[m[32m      "version": "19.3.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@types/react-dom/-/react-dom-19.3.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-ZI7bU42mZXXKHn/qNLEw2IrbiINU7X5+vfgdixBHkCNpYWXjKgfQ/P+uyGb5CjOLB9UcnTeg3rylQtV2hym44Q==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "peerDependencies": {[m
[32m+[m[32m        "@types/react": "^19.3.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@vitejs/plugin-react": {[m
[32m+[m[32m      "version": "6.1.1",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@vitejs/plugin-react/-/plugin-react-6.1.1.tgz",[m
[32m+[m[32m      "integrity": "sha512-yxLaQV9gkhS8ezJqCM6+ndU7mDY6gqAg75NQ+0IjwEI8IYOmQCgkRwHKVSfWXW076DsqMo0Dk+0FK1U+M5RgFw==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@rolldown/pluginutils": "^1.0.1"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "peerDependencies": {[m
[32m+[m[32m        "@rolldown/plugin-babel": "^0.1.7 || ^0.2.0",[m
[32m+[m[32m        "babel-plugin-react-compiler": "^1.0.0",[m
[32m+[m[32m        "oxc-transform-react": "^0.145.0",[m
[32m+[m[32m        "vite": "^8.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "peerDependenciesMeta": {[m
[32m+[m[32m        "@rolldown/plugin-babel": {[m
[32m+[m[32m          "optional": true[m
[32m+[m[32m        },[m
[32m+[m[32m        "babel-plugin-react-compiler": {[m
[32m+[m[32m          "optional": true[m
[32m+[m[32m        },[m
[32m+[m[32m        "oxc-transform-react": {[m
[32m+[m[32m          "optional": true[m
[32m+[m[32m        }[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/agent-base": {[m
[32m+[m[32m      "version": "6.0.2",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/agent-base/-/agent-base-6.0.2.tgz",[m
[32m+[m[32m      "integrity": "sha512-RZNwNclF7+MS/8bDg70amg32dyeZGZxiDuQmZxKLAlQjr3jGyLx+4Kkk58UO7D2QdgFIQCovuSuZESne6RG6XQ==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "debug": "4"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 6.0.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/asynckit": {[m
[32m+[m[32m      "version": "0.4.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-Oei9OH4tRh0YqU3GxhX79dM/mwVgvbZJaSNaRk+bshkj0S5cfHcgYakreBjrHwatXKbz+IoIdYLxrKim2MjW0Q==",[m
[32m+[m[32m      "license": "MIT"[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/axios": {[m
[32m+[m[32m      "version": "1.20.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/axios/-/axios-1.20.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-r8aOh8j9cGKpgQAqpzrUHnSIc6a59Y3Xf/cv8sy1DrHCkZHzQGEuoq1tARk6qSyDdtQGSDgpb9kFlruzPvrgwg==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "follow-redirects": "^1.16.0",[m
[32m+[m[32m        "form-data": "^4.0.6",[m
[32m+[m[32m        "https-proxy-agent": "^5.0.1",[m
[32m+[m[32m        "proxy-from-env": "^2.1.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/call-bind-apply-helpers": {[m
[32m+[m[32m      "version": "1.0.2",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/call-bind-apply-helpers/-/call-bind-apply-helpers-1.0.2.tgz",[m
[32m+[m[32m      "integrity": "sha512-Sp1ablJ0ivDkSzjcaJdxEunN5/XvksFJ2sMBFfq6x0ryhQV/2b/KwFe21cMpmHtPOSij8K99/wSfoEuTObmuMQ==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "es-errors": "^1.3.0",[m
[32m+[m[32m        "function-bind": "^1.1.2"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 0.4"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/combined-stream": {[m
[32m+[m[32m      "version": "1.0.8",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz",[m
[32m+[m[32m      "integrity": "sha512-FQN4MRfuJeHf7cBbBMJFXhKSDq+2kAArBlmRBvcvFE5BB1HZKXtSFASDhdlz9zOYwxh8lDdnvmMOe/+5cdoEdg==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "delayed-stream": "~1.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 0.8"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/csstype": {[m
[32m+[m[32m      "version": "3.2.3",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/csstype/-/csstype-3.2.3.tgz",[m
[32m+[m[32m      "integrity": "sha512-z1HGKcYy2xA8AGQfwrn0PAy+PB7X/GSj3UVJW9qKyn43xWa+gl5nXmU4qqLMRzWVLFC8KusUX8T/0kCiOYpAIQ==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT"[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/debug": {[m
[32m+[m[32m      "version": "4.4.3",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/debug/-/debug-4.4.3.tgz",[m
[32m+[m[32m      "integrity": "sha512-RGwwWnwQvkVfavKVt22FGLw+xYSdzARwm0ru6DhTVA3umU5hZc28V3kO4stgYryrTlLpuvgI9GiijltAjNbcqA==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "ms": "^2.1.3"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">=6.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "peerDependenciesMeta": {[m
[32m+[m[32m        "supports-color": {[m
[32m+[m[32m          "optional": true[m
[32m+[m[32m        }[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/delayed-stream": {[m
[32m+[m[32m      "version": "1.0.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-ZySD7Nf91aLB0RxL4KGrKHBXl7Eds1DAmEdcoVawXnLD7SDhpNgtuII2aAkg7a7QS41jxPSZ17p4VdGnMHk3MQ==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">=0.4.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/detect-libc": {[m
[32m+[m[32m      "version": "2.1.2",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/detect-libc/-/detect-libc-2.1.2.tgz",[m
[32m+[m[32m      "integrity": "sha512-Btj2BOOO83o3WyH59e8MgXsxEQVcarkUOpEYrubB0urwnN10yQ364rsiByU11nZlqWYZm05i/of7io4mzihBtQ==",[m
[32m+[m[32m      "license": "Apache-2.0",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">=8"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/dunder-proto": {[m
[32m+[m[32m      "version": "1.0.1",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/dunder-proto/-/dunder-proto-1.0.1.tgz",[m
[32m+[m[32m      "integrity": "sha512-KIN/nDJBQRcXw0MLVhZE9iQHmG68qAVIBg9CqmUYjmQIhgij9U5MFvrqkUL5FbtyyzZuOeOt0zdeRe4UY7ct+A==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "call-bind-apply-helpers": "^1.0.1",[m
[32m+[m[32m        "es-errors": "^1.3.0",[m
[32m+[m[32m        "gopd": "^1.2.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 0.4"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/enhanced-resolve": {[m
[32m+[m[32m      "version": "5.24.5",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/enhanced-resolve/-/enhanced-resolve-5.24.5.tgz",[m
[32m+[m[32m      "integrity": "sha512-L1l8TNvomm6UVW5B253AGxQagSQr+vGwhMlrrfRS2qmhx46AMpMVJKQYLvWYbysTMY8VoicOvzHzoHMbyzB+4A==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "graceful-fs": "^4.2.4",[m
[32m+[m[32m        "tapable": "^2.3.3"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">=10.13.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/es-define-property": {[m
[32m+[m[32m      "version": "1.0.1",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/es-define-property/-/es-define-property-1.0.1.tgz",[m
[32m+[m[32m      "integrity": "sha512-e3nRfgfUZ4rNGL232gUgX06QNyyez04KdjFrF+LTRoOXmrOgFKDg4BCdsjW8EnT69eqdYGmRpJwiPVYNrCaW3g==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 0.4"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/es-errors": {[m
[32m+[m[32m      "version": "1.3.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/es-errors/-/es-errors-1.3.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-Zf5H2Kxt2xjTvbJvP2ZWLEICxA6j+hAmMzIlypy4xcBg1vKVnx89Wy0GbS+kf5cwCVFFzdCFh2XSCFNULS6csw==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 0.4"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/es-object-atoms": {[m
[32m+[m[32m      "version": "1.1.2",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/es-object-atoms/-/es-object-atoms-1.1.2.tgz",[m
[32m+[m[32m      "integrity": "sha512-HWcBoN6NileqtSydK2FqHbS/LoDd2pqrnQHLyJzBj4kOp/ky2MWMN694xOfkK8/SnUsW2DH7EfyVlydKCsm1Zw==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "es-errors": "^1.3.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 0.4"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/es-set-tostringtag": {[m
[32m+[m[32m      "version": "2.1.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/es-set-tostringtag/-/es-set-tostringtag-2.1.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-j6vWzfrGVfyXxge+O0x5sh6cvxAog0a/4Rdd2K36zCMV5eJ+/+tOAngRO8cODMNWbVRdVlmGZQL2YS3yR8bIUA==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "es-errors": "^1.3.0",[m
[32m+[m[32m        "get-intrinsic": "^1.2.6",[m
[32m+[m[32m        "has-tostringtag": "^1.0.2",[m
[32m+[m[32m        "hasown": "^2.0.2"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 0.4"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/fdir": {[m
[32m+[m[32m      "version": "6.5.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/fdir/-/fdir-6.5.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-tIbYtZbucOs0BRGqPJkshJUYdL+SDH7dVM8gjy+ERp3WAUjLEFJE+02kanyHtwjWOnwrKYBiwAmM0p4kLJAnXg==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">=12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "peerDependencies": {[m
[32m+[m[32m        "picomatch": "^3 || ^4"[m
[32m+[m[32m      },[m
[32m+[m[32m      "peerDependenciesMeta": {[m
[32m+[m[32m        "picomatch": {[m
[32m+[m[32m          "optional": true[m
[32m+[m[32m        }[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/follow-redirects": {[m
[32m+[m[32m      "version": "1.16.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/follow-redirects/-/follow-redirects-1.16.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-y5rN/uOsadFT/JfYwhxRS5R7Qce+g3zG97+JrtFZlC9klX/W5hD7iiLzScI4nZqUS7DNUdhPgw4xI8W2LuXlUw==",[m
[32m+[m[32m      "funding": [[m
[32m+[m[32m        {[m
[32m+[m[32m          "type": "individual",[m
[32m+[m[32m          "url": "https://github.com/sponsors/RubenVerborgh"[m
[32m+[m[32m        }[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">=4.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "peerDependenciesMeta": {[m
[32m+[m[32m        "debug": {[m
[32m+[m[32m          "optional": true[m
[32m+[m[32m        }[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/form-data": {[m
[32m+[m[32m      "version": "4.0.6",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/form-data/-/form-data-4.0.6.tgz",[m
[32m+[m[32m      "integrity": "sha512-vKatAh4SlVfgbv+YtmhiRjhEMJsYpsG1Y2rMQtR+SVSbytsSD1YGzDIcrAJmdFec88u/+VoGmxnl+80gL1tRCQ==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "asynckit": "^0.4.0",[m
[32m+[m[32m        "combined-stream": "^1.0.8",[m
[32m+[m[32m        "es-set-tostringtag": "^2.1.0",[m
[32m+[m[32m        "hasown": "^2.0.4",[m
[32m+[m[32m        "mime-types": "^2.1.35"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 6"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/fsevents": {[m
[32m+[m[32m      "version": "2.3.3",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz",[m
[32m+[m[32m      "integrity": "sha512-5xoDfX+fL7faATnagmWPpbFtwh/R77WmMMqqHGS65C3vvB0YHrgF+B1YmZ3441tMj5n63k0212XNoJwzlhffQw==",[m
[32m+[m[32m      "hasInstallScript": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "darwin"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^8.16.0 || ^10.6.0 || >=11.0.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/function-bind": {[m
[32m+[m[32m      "version": "1.1.2",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz",[m
[32m+[m[32m      "integrity": "sha512-7XHNxH7qX9xG5mIwxkhumTox/MIRNcOgDrxWsMt2pAr23WHp6MrRlN7FBSFpCpr+oVO0F744iUgR82nJMfG2SA==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "url": "https://github.com/sponsors/ljharb"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/get-intrinsic": {[m
[32m+[m[32m      "version": "1.3.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.3.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-9fSjSaos/fRIVIp+xSJlE6lfwhES7LNtKaCBIamHsjr2na1BiABJPo0mOjjz8GJDURarmCPGqaiVg5mfjb98CQ==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "call-bind-apply-helpers": "^1.0.2",[m
[32m+[m[32m        "es-define-property": "^1.0.1",[m
[32m+[m[32m        "es-errors": "^1.3.0",[m
[32m+[m[32m        "es-object-atoms": "^1.1.1",[m
[32m+[m[32m        "function-bind": "^1.1.2",[m
[32m+[m[32m        "get-proto": "^1.0.1",[m
[32m+[m[32m        "gopd": "^1.2.0",[m
[32m+[m[32m        "has-symbols": "^1.1.0",[m
[32m+[m[32m        "hasown": "^2.0.2",[m
[32m+[m[32m        "math-intrinsics": "^1.1.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 0.4"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "url": "https://github.com/sponsors/ljharb"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/get-proto": {[m
[32m+[m[32m      "version": "1.0.1",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/get-proto/-/get-proto-1.0.1.tgz",[m
[32m+[m[32m      "integrity": "sha512-sTSfBjoXBp89JvIKIefqw7U2CCebsc74kiY6awiGogKtoSGbgjYE/G/+l9sF3MWFPNc9IcoOC4ODfKHfxFmp0g==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "dunder-proto": "^1.0.1",[m
[32m+[m[32m        "es-object-atoms": "^1.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 0.4"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/gopd": {[m
[32m+[m[32m      "version": "1.2.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/gopd/-/gopd-1.2.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-ZUKRh6/kUFoAiTAtTYPZJ3hw9wNxx+BIBOijnlG9PnrJsCcSjs1wyyD6vJpaYtgnzDrKYRSqf3OO6Rfa93xsRg==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 0.4"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "url": "https://github.com/sponsors/ljharb"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/graceful-fs": {[m
[32m+[m[32m      "version": "4.2.11",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.11.tgz",[m
[32m+[m[32m      "integrity": "sha512-RbJ5/jmFcNNCcDV5o9eTnBLJ/HszWV0P73bc+Ff4nS/rJj+YaS6IGyiOL0VoBYX+l1Wrl3k63h/KrH+nhJ0XvQ==",[m
[32m+[m[32m      "license": "ISC"[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/has-symbols": {[m
[32m+[m[32m      "version": "1.1.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/has-symbols/-/has-symbols-1.1.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-1cDNdwJ2Jaohmb3sg4OmKaMBwuC48sYni5HUw2DvsC8LjGTLK9h+eb1X6RyuOHe4hT0ULCW68iomhjUoKUqlPQ==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 0.4"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "url": "https://github.com/sponsors/ljharb"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/has-tostringtag": {[m
[32m+[m[32m      "version": "1.0.2",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/has-tostringtag/-/has-tostringtag-1.0.2.tgz",[m
[32m+[m[32m      "integrity": "sha512-NqADB8VjPFLM2V0VvHUewwwsw0ZWBaIdgo+ieHtK3hasLz4qeCRjYcqfB6AQrBggRKppKF8L52/VqdVsO47Dlw==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "has-symbols": "^1.0.3"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 0.4"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "url": "https://github.com/sponsors/ljharb"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/hasown": {[m
[32m+[m[32m      "version": "2.0.4",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/hasown/-/hasown-2.0.4.tgz",[m
[32m+[m[32m      "integrity": "sha512-T2UbfbBEF32wiepXIsMlTW9+dDYC6wMh/t/vYA4tuOMKqWz/n3vr1NFSxQiyP+zk2mXsoMA/i/7qV6LKut1t1A==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "function-bind": "^1.1.2"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 0.4"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/https-proxy-agent": {[m
[32m+[m[32m      "version": "5.0.1",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz",[m
[32m+[m[32m      "integrity": "sha512-dFcAjpTQFgoLMzC2VwU+C/CbS7uRL0lWmxDITmqm7C+7F0Odmj6s9l6alZc6AELXhrnggM2CeWSXHGOdX2YtwA==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "agent-base": "6",[m
[32m+[m[32m        "debug": "4"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 6"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/jiti": {[m
[32m+[m[32m      "version": "2.7.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/jiti/-/jiti-2.7.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-AC/7JofJvZGrrneWNaEnJeOLUx+JlGt7tNa0wZiRPT4MY1wmfKjt2+6O2p2uz2+skll8OZZmJMNqeke7kKbNgQ==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "bin": {[m
[32m+[m[32m        "jiti": "lib/jiti-cli.mjs"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/lightningcss": {[m
[32m+[m[32m      "version": "1.32.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/lightningcss/-/lightningcss-1.32.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-NXYBzinNrblfraPGyrbPoD19C1h9lfI/1mzgWYvXUTe414Gz/X1FD2XBZSZM7rRTrMA8JL3OtAaGifrIKhQ5yQ==",[m
[32m+[m[32m      "license": "MPL-2.0",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "detect-libc": "^2.0.3"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/parcel"[m
[32m+[m[32m      },[m
[32m+[m[32m      "optionalDependencies": {[m
[32m+[m[32m        "lightningcss-android-arm64": "1.32.0",[m
[32m+[m[32m        "lightningcss-darwin-arm64": "1.32.0",[m
[32m+[m[32m        "lightningcss-darwin-x64": "1.32.0",[m
[32m+[m[32m        "lightningcss-freebsd-x64": "1.32.0",[m
[32m+[m[32m        "lightningcss-linux-arm-gnueabihf": "1.32.0",[m
[32m+[m[32m        "lightningcss-linux-arm64-gnu": "1.32.0",[m
[32m+[m[32m        "lightningcss-linux-arm64-musl": "1.32.0",[m
[32m+[m[32m        "lightningcss-linux-x64-gnu": "1.32.0",[m
[32m+[m[32m        "lightningcss-linux-x64-musl": "1.32.0",[m
[32m+[m[32m        "lightningcss-win32-arm64-msvc": "1.32.0",[m
[32m+[m[32m        "lightningcss-win32-x64-msvc": "1.32.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/lightningcss-android-arm64": {[m
[32m+[m[32m      "version": "1.32.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/lightningcss-android-arm64/-/lightningcss-android-arm64-1.32.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-YK7/ClTt4kAK0vo6w3X+Pnm0D2cf2vPHbhOXdoNti1Ga0al1P4TBZhwjATvjNwLEBCnKvjJc2jQgHXH0NEwlAg==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MPL-2.0",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "android"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/parcel"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/lightningcss-darwin-arm64": {[m
[32m+[m[32m      "version": "1.32.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/lightningcss-darwin-arm64/-/lightningcss-darwin-arm64-1.32.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-RzeG9Ju5bag2Bv1/lwlVJvBE3q6TtXskdZLLCyfg5pt+HLz9BqlICO7LZM7VHNTTn/5PRhHFBSjk5lc4cmscPQ==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MPL-2.0",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "darwin"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/parcel"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/lightningcss-darwin-x64": {[m
[32m+[m[32m      "version": "1.32.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/lightningcss-darwin-x64/-/lightningcss-darwin-x64-1.32.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-U+QsBp2m/s2wqpUYT/6wnlagdZbtZdndSmut/NJqlCcMLTWp5muCrID+K5UJ6jqD2BFshejCYXniPDbNh73V8w==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "x64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MPL-2.0",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "darwin"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/parcel"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/lightningcss-freebsd-x64": {[m
[32m+[m[32m      "version": "1.32.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/lightningcss-freebsd-x64/-/lightningcss-freebsd-x64-1.32.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-JCTigedEksZk3tHTTthnMdVfGf61Fky8Ji2E4YjUTEQX14xiy/lTzXnu1vwiZe3bYe0q+SpsSH/CTeDXK6WHig==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "x64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MPL-2.0",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "freebsd"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/parcel"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/lightningcss-linux-arm-gnueabihf": {[m
[32m+[m[32m      "version": "1.32.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/lightningcss-linux-arm-gnueabihf/-/lightningcss-linux-arm-gnueabihf-1.32.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-x6rnnpRa2GL0zQOkt6rts3YDPzduLpWvwAF6EMhXFVZXD4tPrBkEFqzGowzCsIWsPjqSK+tyNEODUBXeeVHSkw==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MPL-2.0",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/parcel"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/lightningcss-linux-arm64-gnu": {[m
[32m+[m[32m      "version": "1.32.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/lightningcss-linux-arm64-gnu/-/lightningcss-linux-arm64-gnu-1.32.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-0nnMyoyOLRJXfbMOilaSRcLH3Jw5z9HDNGfT/gwCPgaDjnx0i8w7vBzFLFR1f6CMLKF8gVbebmkUN3fa/kQJpQ==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MPL-2.0",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/parcel"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/lightningcss-linux-arm64-musl": {[m
[32m+[m[32m      "version": "1.32.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/lightningcss-linux-arm64-musl/-/lightningcss-linux-arm64-musl-1.32.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-UpQkoenr4UJEzgVIYpI80lDFvRmPVg6oqboNHfoH4CQIfNA+HOrZ7Mo7KZP02dC6LjghPQJeBsvXhJod/wnIBg==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MPL-2.0",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/parcel"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/lightningcss-linux-x64-gnu": {[m
[32m+[m[32m      "version": "1.32.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/lightningcss-linux-x64-gnu/-/lightningcss-linux-x64-gnu-1.32.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-V7Qr52IhZmdKPVr+Vtw8o+WLsQJYCTd8loIfpDaMRWGUZfBOYEJeyJIkqGIDMZPwPx24pUMfwSxxI8phr/MbOA==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "x64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MPL-2.0",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/parcel"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/lightningcss-linux-x64-musl": {[m
[32m+[m[32m      "version": "1.32.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/lightningcss-linux-x64-musl/-/lightningcss-linux-x64-musl-1.32.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-bYcLp+Vb0awsiXg/80uCRezCYHNg1/l3mt0gzHnWV9XP1W5sKa5/TCdGWaR/zBM2PeF/HbsQv/j2URNOiVuxWg==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "x64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MPL-2.0",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/parcel"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/lightningcss-win32-arm64-msvc": {[m
[32m+[m[32m      "version": "1.32.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/lightningcss-win32-arm64-msvc/-/lightningcss-win32-arm64-msvc-1.32.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-8SbC8BR40pS6baCM8sbtYDSwEVQd4JlFTOlaD3gWGHfThTcABnNDBda6eTZeqbofalIJhFx0qKzgHJmcPTnGdw==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MPL-2.0",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "win32"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/parcel"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/lightningcss-win32-x64-msvc": {[m
[32m+[m[32m      "version": "1.32.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/lightningcss-win32-x64-msvc/-/lightningcss-win32-x64-msvc-1.32.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-Amq9B/SoZYdDi1kFrojnoqPLxYhQ4Wo5XiL8EVJrVsB8ARoC1PWW6VGtT0WKCemjy8aC+louJnjS7U18x3b06Q==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "x64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MPL-2.0",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "win32"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/parcel"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/lucide-react": {[m
[32m+[m[32m      "version": "1.44.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/lucide-react/-/lucide-react-1.44.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-2egNApH4hX4j/qdCgRublh88+9u3mEhz9iSlW5ckm4kaQEqZbXbMr0l5u5JZLy8nmWRx2dbHGQkEDYz6C9aCgw==",[m
[32m+[m[32m      "license": "ISC",[m
[32m+[m[32m      "peerDependencies": {[m
[32m+[m[32m        "react": "^16.5.1 || ^17.0.0 || ^18.0.0 || ^19.0.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/magic-string": {[m
[32m+[m[32m      "version": "0.30.21",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/magic-string/-/magic-string-0.30.21.tgz",[m
[32m+[m[32m      "integrity": "sha512-vd2F4YUyEXKGcLHoq+TEyCjxueSeHnFxyyjNp80yg0XV4vUhnDer/lvvlqM/arB5bXQN5K2/3oinyCRyx8T2CQ==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@jridgewell/sourcemap-codec": "^1.5.5"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/math-intrinsics": {[m
[32m+[m[32m      "version": "1.1.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/math-intrinsics/-/math-intrinsics-1.1.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-/IXtbwEk5HTPyEwyKX6hGkYXxM9nbj64B+ilVJnC/R6B0pH5G4V3b0pVbL7DBj4tkhBAppbQUlf6F6Xl9LHu1g==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 0.4"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/mime-db": {[m
[32m+[m[32m      "version": "1.52.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/mime-db/-/mime-db-1.52.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-sPU4uV7dYlvtWJxwwxHD0PuihVNiE7TyAbQ5SWxDCB9mUYvOgroQOwYQQOKPJ8CIbE+1ETVlOoK1UC2nU3gYvg==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 0.6"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/mime-types": {[m
[32m+[m[32m      "version": "2.1.35",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/mime-types/-/mime-types-2.1.35.tgz",[m
[32m+[m[32m      "integrity": "sha512-ZDY+bPm5zTTF+YpCrAU9nK0UgICYPT0QtT1NZWFv4s++TNkcgVaT0g6+4R2uI4MjQjzysHB1zxuWL50hzaeXiw==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "mime-db": "1.52.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 0.6"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/ms": {[m
[32m+[m[32m      "version": "2.1.3",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/ms/-/ms-2.1.3.tgz",[m
[32m+[m[32m      "integrity": "sha512-6FlzubTLZG3J2a/NVCAleEhjzq5oxgHyaCU9yYXvcLsvoVaHJq/s5xXI6/XXP6tz7R9xAOtHnSO/tXtF3WRTlA==",[m
[32m+[m[32m      "license": "MIT"[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/nanoid": {[m
[32m+[m[32m      "version": "3.3.19",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/nanoid/-/nanoid-3.3.19.tgz",[m
[32m+[m[32m      "integrity": "sha512-Y2tUNy4ouw6tq5oDSKeQYGOyhkUBhNOcGV/02KC+6kd9eDGqdZd++mjMiIDilrBYvjEnCYvVtsuHCuP+okSfug==",[m
[32m+[m[32m      "funding": [[m
[32m+[m[32m        {[m
[32m+[m[32m          "type": "github",[m
[32m+[m[32m          "url": "https://github.com/sponsors/ai"[m
[32m+[m[32m        }[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "bin": {[m
[32m+[m[32m        "nanoid": "bin/nanoid.cjs"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^10 || ^12 || ^13.7 || ^14 || >=15.0.1"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/oxlint": {[m
[32m+[m[32m      "version": "1.82.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/oxlint/-/oxlint-1.82.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-+iFM1BGw1ntYJt3QngbJmjbrGxPaKMUADOXOijpWGnYcBPq8YZnQftSS1C+pVcDYy9YxqDVJKQqQkTazTQMboQ==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "bin": {[m
[32m+[m[32m        "oxlint": "bin/oxlint"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "url": "https://github.com/sponsors/oxc-project"[m
[32m+[m[32m      },[m
[32m+[m[32m      "optionalDependencies": {[m
[32m+[m[32m        "@oxlint/binding-android-arm-eabi": "1.82.0",[m
[32m+[m[32m        "@oxlint/binding-android-arm64": "1.82.0",[m
[32m+[m[32m        "@oxlint/binding-darwin-arm64": "1.82.0",[m
[32m+[m[32m        "@oxlint/binding-darwin-x64": "1.82.0",[m
[32m+[m[32m        "@oxlint/binding-freebsd-x64": "1.82.0",[m
[32m+[m[32m        "@oxlint/binding-linux-arm-gnueabihf": "1.82.0",[m
[32m+[m[32m        "@oxlint/binding-linux-arm-musleabihf": "1.82.0",[m
[32m+[m[32m        "@oxlint/binding-linux-arm64-gnu": "1.82.0",[m
[32m+[m[32m        "@oxlint/binding-linux-arm64-musl": "1.82.0",[m
[32m+[m[32m        "@oxlint/binding-linux-ppc64-gnu": "1.82.0",[m
[32m+[m[32m        "@oxlint/binding-linux-riscv64-gnu": "1.82.0",[m
[32m+[m[32m        "@oxlint/binding-linux-riscv64-musl": "1.82.0",[m
[32m+[m[32m        "@oxlint/binding-linux-s390x-gnu": "1.82.0",[m
[32m+[m[32m        "@oxlint/binding-linux-x64-gnu": "1.82.0",[m
[32m+[m[32m        "@oxlint/binding-linux-x64-musl": "1.82.0",[m
[32m+[m[32m        "@oxlint/binding-openharmony-arm64": "1.82.0",[m
[32m+[m[32m        "@oxlint/binding-win32-arm64-msvc": "1.82.0",[m
[32m+[m[32m        "@oxlint/binding-win32-ia32-msvc": "1.82.0",[m
[32m+[m[32m        "@oxlint/binding-win32-x64-msvc": "1.82.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "peerDependencies": {[m
[32m+[m[32m        "oxlint-tsgolint": ">=7.0.2001",[m
[32m+[m[32m        "vite-plus": "*"[m
[32m+[m[32m      },[m
[32m+[m[32m      "peerDependenciesMeta": {[m
[32m+[m[32m        "oxlint-tsgolint": {[m
[32m+[m[32m          "optional": true[m
[32m+[m[32m        },[m
[32m+[m[32m        "vite-plus": {[m
[32m+[m[32m          "optional": true[m
[32m+[m[32m        }[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/picocolors": {[m
[32m+[m[32m      "version": "1.1.1",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/picocolors/-/picocolors-1.1.1.tgz",[m
[32m+[m[32m      "integrity": "sha512-xceH2snhtb5M9liqDsmEw56le376mTZkEX/jEb/RxNFyegNul7eNslCXP9FDj/Lcu0X8KEyMceP2ntpaHrDEVA==",[m
[32m+[m[32m      "license": "ISC"[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/picomatch": {[m
[32m+[m[32m      "version": "4.0.7",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/picomatch/-/picomatch-4.0.7.tgz",[m
[32m+[m[32m      "integrity": "sha512-qcJu88Q2IWqJsDD529JKMdwGm/dvInW4HvQnRwiH9JtihJvzGOscDtHE3x1pBKeUOTysQ8kVmLnJ2kJu7yhcGA==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "peer": true,[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">=12"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "url": "https://github.com/sponsors/jonschlinkert"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/postcss": {[m
[32m+[m[32m      "version": "8.5.28",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/postcss/-/postcss-8.5.28.tgz",[m
[32m+[m[32m      "integrity": "sha512-RRuzqDtt5Y9h3quz5hWhK+TPnsmVs6WwSU6LkJMeY4HstUEDuYTG8UJSdawMRzmzAtV+KEoG8N3Qg2qLy5vM/A==",[m
[32m+[m[32m      "funding": [[m
[32m+[m[32m        {[m
[32m+[m[32m          "type": "opencollective",[m
[32m+[m[32m          "url": "https://opencollective.com/postcss/"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m          "type": "tidelift",[m
[32m+[m[32m          "url": "https://tidelift.com/funding/github/npm/postcss"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m          "type": "github",[m
[32m+[m[32m          "url": "https://github.com/sponsors/ai"[m
[32m+[m[32m        }[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "nanoid": "^3.3.18",[m
[32m+[m[32m        "picocolors": "^1.1.1",[m
[32m+[m[32m        "source-map-js": "^1.2.1"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^10 || ^12 || >=14"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/proxy-from-env": {[m
[32m+[m[32m      "version": "2.1.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/proxy-from-env/-/proxy-from-env-2.1.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-cJ+oHTW1VAEa8cJslgmUZrc+sjRKgAKl3Zyse6+PV38hZe/V6Z14TbCuXcan9F9ghlz4QrFr2c92TNF82UkYHA==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">=10"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/react": {[m
[32m+[m[32m      "version": "19.3.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/react/-/react-19.3.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-E8LUcbtBWt20bbl2YoHfx4ZDBdxVTfOKtCZn9cDSJ4l6/nuoApcpIBcj47t2wZoVX8g2ZHuMHbiShgCR1T5Sog==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "peer": true,[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">=0.10.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/react-dom": {[m
[32m+[m[32m      "version": "19.3.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/react-dom/-/react-dom-19.3.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-JDk8dgif51OjFoDE70+OT9ICyYr+69HlmihNwp1+Nsfbna3t5sIiCa9ZJktDmQ4/1b/rn26hIAR2uYXDMr5r0Q==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "scheduler": "^0.28.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "peerDependencies": {[m
[32m+[m[32m        "react": "^19.3.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/rolldown": {[m
[32m+[m[32m      "version": "1.2.8",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/rolldown/-/rolldown-1.2.8.tgz",[m
[32m+[m[32m      "integrity": "sha512-Z67nTmhZe7anqnM/EjI392w5i/ANUinjip7QYsOyN37oayduxt3ksdX0hf5OOamkAd53BiIHfbfSzfUmzKFQqQ==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@oxc-project/types": "=0.149.0",[m
[32m+[m[32m        "@rolldown/pluginutils": "^1.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "bin": {[m
[32m+[m[32m        "rolldown": "bin/cli.mjs"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "optionalDependencies": {[m
[32m+[m[32m        "@rolldown/binding-android-arm-eabi": "1.2.8",[m
[32m+[m[32m        "@rolldown/binding-android-arm64": "1.2.8",[m
[32m+[m[32m        "@rolldown/binding-darwin-arm64": "1.2.8",[m
[32m+[m[32m        "@rolldown/binding-darwin-x64": "1.2.8",[m
[32m+[m[32m        "@rolldown/binding-freebsd-x64": "1.2.8",[m
[32m+[m[32m        "@rolldown/binding-linux-arm-gnueabihf": "1.2.8",[m
[32m+[m[32m        "@rolldown/binding-linux-arm64-gnu": "1.2.8",[m
[32m+[m[32m        "@rolldown/binding-linux-arm64-musl": "1.2.8",[m
[32m+[m[32m        "@rolldown/binding-linux-ppc64-gnu": "1.2.8",[m
[32m+[m[32m        "@rolldown/binding-linux-s390x-gnu": "1.2.8",[m
[32m+[m[32m        "@rolldown/binding-linux-x64-gnu": "1.2.8",[m
[32m+[m[32m        "@rolldown/binding-linux-x64-musl": "1.2.8",[m
[32m+[m[32m        "@rolldown/binding-openharmony-arm64": "1.2.8",[m
[32m+[m[32m        "@rolldown/binding-win32-arm64-msvc": "1.2.8",[m
[32m+[m[32m        "@rolldown/binding-win32-x64-msvc": "1.2.8"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/scheduler": {[m
[32m+[m[32m      "version": "0.28.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/scheduler/-/scheduler-0.28.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-juorfCmIkIw8tT+p5BXSm6PJjQF/ycEYmKyzURCIt/RaZIhL+PulbQ9Yu2z1HdOJDdqDTlxA1+xKBmHXJsczAw==",[m
[32m+[m[32m      "license": "MIT"[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/source-map-js": {[m
[32m+[m[32m      "version": "1.2.1",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/source-map-js/-/source-map-js-1.2.1.tgz",[m
[32m+[m[32m      "integrity": "sha512-UXWMKhLOwVKb728IUtQPXxfYU+usdybtUrK/8uGE8CQMvrhOpwvzDBwj0QhSL7MQc7vIsISBG8VQ8+IDQxpfQA==",[m
[32m+[m[32m      "license": "BSD-3-Clause",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">=0.10.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/tailwindcss": {[m
[32m+[m[32m      "version": "4.3.3",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/tailwindcss/-/tailwindcss-4.3.3.tgz",[m
[32m+[m[32m      "integrity": "sha512-gOhV3P7ufE62QDGg1zVaTgCR+EtPv92k2nIhVcVKcLmxT1sUBsQGhnZj175j+MqRt4zLF7ic+sCYjfhxMxj7YQ==",[m
[32m+[m[32m      "license": "MIT"[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/tapable": {[m
[32m+[m[32m      "version": "2.3.3",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/tapable/-/tapable-2.3.3.tgz",[m
[32m+[m[32m      "integrity": "sha512-uxc/zpqFg6x7C8vOE7lh6Lbda8eEL9zmVm/PLeTPBRhh1xCgdWaQ+J1CUieGpIfm2HdtsUpRv+HshiasBMcc6A==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">=6"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/webpack"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/tinyglobby": {[m
[32m+[m[32m      "version": "0.2.17",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/tinyglobby/-/tinyglobby-0.2.17.tgz",[m
[32m+[m[32m      "integrity": "sha512-wXR/dYpcqKmfWpEdZjiKJOwCNFndD0DMnrW/cYjVGttEkBfVgcLFHoNrlj47mjOVic9yyNu65alsgF4NQyTa2g==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "fdir": "^6.5.0",[m
[32m+[m[32m        "picomatch": "^4.0.4"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">=12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "url": "https://github.com/sponsors/SuperchupuDev"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/vite": {[m
[32m+[m[32m      "version": "8.3.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/vite/-/vite-8.3.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-lhZBVvEHefgE+HQZC9O7EBJgCU/nVzFNl7vkS4RE0APtWLP02/8QVIkQtzBxPquh7lq5/78NHipTj7ODQ6XuyQ==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "peer": true,[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "lightningcss": "^1.33.0",[m
[32m+[m[32m        "picomatch": "^4.0.7",[m
[32m+[m[32m        "postcss": "^8.5.28",[m
[32m+[m[32m        "rolldown": "~1.2.6",[m
[32m+[m[32m        "tinyglobby": "^0.2.17"[m
[32m+[m[32m      },[m
[32m+[m[32m      "bin": {[m
[32m+[m[32m        "vite": "bin/vite.js"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || >=22.12.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "url": "https://github.com/vitejs/vite?sponsor=1"[m
[32m+[m[32m      },[m
[32m+[m[32m      "optionalDependencies": {[m
[32m+[m[32m        "fsevents": "~2.3.3"[m
[32m+[m[32m      },[m
[32m+[m[32m      "peerDependencies": {[m
[32m+[m[32m        "@types/node": "^20.19.0 || >=22.12.0",[m
[32m+[m[32m        "@vitejs/devtools": "^0.7.1",[m
[32m+[m[32m        "esbuild": "^0.27.0 || ^0.28.0",[m
[32m+[m[32m        "jiti": ">=1.21.0",[m
[32m+[m[32m        "less": "^4.0.0",[m
[32m+[m[32m        "sass": "^1.70.0",[m
[32m+[m[32m        "sass-embedded": "^1.70.0",[m
[32m+[m[32m        "stylus": ">=0.54.8",[m
[32m+[m[32m        "sugarss": "^5.0.0",[m
[32m+[m[32m        "terser": "^5.16.0",[m
[32m+[m[32m        "tsx": "^4.8.1",[m
[32m+[m[32m        "yaml": "^2.4.2"[m
[32m+[m[32m      },[m
[32m+[m[32m      "peerDependenciesMeta": {[m
[32m+[m[32m        "@types/node": {[m
[32m+[m[32m          "optional": true[m
[32m+[m[32m        },[m
[32m+[m[32m        "@vitejs/devtools": {[m
[32m+[m[32m          "optional": true[m
[32m+[m[32m        },[m
[32m+[m[32m        "esbuild": {[m
[32m+[m[32m          "optional": true[m
[32m+[m[32m        },[m
[32m+[m[32m        "jiti": {[m
[32m+[m[32m          "optional": true[m
[32m+[m[32m        },[m
[32m+[m[32m        "less": {[m
[32m+[m[32m          "optional": true[m
[32m+[m[32m        },[m
[32m+[m[32m        "sass": {[m
[32m+[m[32m          "optional": true[m
[32m+[m[32m        },[m
[32m+[m[32m        "sass-embedded": {[m
[32m+[m[32m          "optional": true[m
[32m+[m[32m        },[m
[32m+[m[32m        "stylus": {[m
[32m+[m[32m          "optional": true[m
[32m+[m[32m        },[m
[32m+[m[32m        "sugarss": {[m
[32m+[m[32m          "optional": true[m
[32m+[m[32m        },[m
[32m+[m[32m        "terser": {[m
[32m+[m[32m          "optional": true[m
[32m+[m[32m        },[m
[32m+[m[32m        "tsx": {[m
[32m+[m[32m          "optional": true[m
[32m+[m[32m        },[m
[32m+[m[32m        "yaml": {[m
[32m+[m[32m          "optional": true[m
[32m+[m[32m        }[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/vite/node_modules/lightningcss": {[m
[32m+[m[32m      "version": "1.33.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/lightningcss/-/lightningcss-1.33.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-WkUDrojuJs0xkgGf2udWxa3yGBRxPtxUkB79i6aCZLRgc7PM8fZe9TosfPDcvEpQZbuFASnHYmRLBLUbmLOIIA==",[m
[32m+[m[32m      "license": "MPL-2.0",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "detect-libc": "^2.0.3"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/parcel"[m
[32m+[m[32m      },[m
[32m+[m[32m      "optionalDependencies": {[m
[32m+[m[32m        "lightningcss-android-arm64": "1.33.0",[m
[32m+[m[32m        "lightningcss-darwin-arm64": "1.33.0",[m
[32m+[m[32m        "lightningcss-darwin-x64": "1.33.0",[m
[32m+[m[32m        "lightningcss-freebsd-x64": "1.33.0",[m
[32m+[m[32m        "lightningcss-linux-arm-gnueabihf": "1.33.0",[m
[32m+[m[32m        "lightningcss-linux-arm64-gnu": "1.33.0",[m
[32m+[m[32m        "lightningcss-linux-arm64-musl": "1.33.0",[m
[32m+[m[32m        "lightningcss-linux-x64-gnu": "1.33.0",[m
[32m+[m[32m        "lightningcss-linux-x64-musl": "1.33.0",[m
[32m+[m[32m        "lightningcss-win32-arm64-msvc": "1.33.0",[m
[32m+[m[32m        "lightningcss-win32-x64-msvc": "1.33.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/vite/node_modules/lightningcss-android-arm64": {[m
[32m+[m[32m      "version": "1.33.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/lightningcss-android-arm64/-/lightningcss-android-arm64-1.33.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-gEpRTalKdosp4Bb8qWtc2iOgE5SeIHlpS1up9bFq2wAyYhl1UdTObYiHe98zEM9SQvSoqQZ1IQD0JNpg3Ml5pg==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MPL-2.0",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "android"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/parcel"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/vite/node_modules/lightningcss-darwin-arm64": {[m
[32m+[m[32m      "version": "1.33.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/lightningcss-darwin-arm64/-/lightningcss-darwin-arm64-1.33.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-Sciaz8eenNTKn9b3t7+xr0ipTp9YxKQY4npwQ3mrRuL0BAVHBLyZxofhaKBAVtzmtRZ/zTyo0/to4B1uWG/Djg==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MPL-2.0",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "darwin"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/parcel"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/vite/node_modules/lightningcss-darwin-x64": {[m
[32m+[m[32m      "version": "1.33.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/lightningcss-darwin-x64/-/lightningcss-darwin-x64-1.33.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-Z5UPAxzrjlWNNyGy6i65cJzzvgJ5D3T6wMvs+gWpY9d7qRhANrxqAp6LhxIgZhWEw18RfJTGcRxjuLIBr+m8XQ==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "x64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MPL-2.0",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "darwin"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/parcel"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/vite/node_modules/lightningcss-freebsd-x64": {[m
[32m+[m[32m      "version": "1.33.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/lightningcss-freebsd-x64/-/lightningcss-freebsd-x64-1.33.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-QQM/Ti/hQajJwCY+RiWuCZ9sdtI/XQk7nDK5vC8kkdwixezOlDgvDx7+RT+QjK6FcFT4MpsuoBnHIo/O3StRRg==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "x64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MPL-2.0",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "freebsd"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/parcel"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/vite/node_modules/lightningcss-linux-arm-gnueabihf": {[m
[32m+[m[32m      "version": "1.33.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/lightningcss-linux-arm-gnueabihf/-/lightningcss-linux-arm-gnueabihf-1.33.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-N7FVBe6iS24MlM6R/4RBTxGhQheZGs7tiQ9U32UtF75NzP5Q7xWPRqLBCKxlRQRk3rY1jCIPLzx7WzOhuUIRLQ==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MPL-2.0",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/parcel"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/vite/node_modules/lightningcss-linux-arm64-gnu": {[m
[32m+[m[32m      "version": "1.33.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/lightningcss-linux-arm64-gnu/-/lightningcss-linux-arm64-gnu-1.33.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-j2v/itmy4HlNxlc6voKXYgBqNi0Ng2LShg4z7GufpEgs05P+2suBVyi9I6YHq5uoVFx9ETin3eCEhLVyXGQnKg==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MPL-2.0",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/parcel"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/vite/node_modules/lightningcss-linux-arm64-musl": {[m
[32m+[m[32m      "version": "1.33.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/lightningcss-linux-arm64-musl/-/lightningcss-linux-arm64-musl-1.33.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-yiO5ROMuYQgXbC60yjZU5CYSFZGKXL0HFATXt9mHJn1+zW55oCtMI9NfcVhYLMFDL7gV7oBPon/EmMMGg2OvtQ==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MPL-2.0",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/parcel"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/vite/node_modules/lightningcss-linux-x64-gnu": {[m
[32m+[m[32m      "version": "1.33.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/lightningcss-linux-x64-gnu/-/lightningcss-linux-x64-gnu-1.33.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-ar+Ju7LmcN0Jo4FpL4hpFybwNG9/3A/Br5KW2n2jyODg3MEZXaDYADdemoNS+BDNfMgKvylJLj4S5tyRActuAg==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "x64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MPL-2.0",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/parcel"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/vite/node_modules/lightningcss-linux-x64-musl": {[m
[32m+[m[32m      "version": "1.33.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/lightningcss-linux-x64-musl/-/lightningcss-linux-x64-musl-1.33.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-RYiYbkokw0trfKqqzfF55lginwEPrD3OJDfTuJzFs1MK6iFnDenaz1fqLLtX4ITG3OktJQXOeTaw1awrBAlZPw==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "x64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MPL-2.0",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/parcel"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/vite/node_modules/lightningcss-win32-arm64-msvc": {[m
[32m+[m[32m      "version": "1.33.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/lightningcss-win32-arm64-msvc/-/lightningcss-win32-arm64-msvc-1.33.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-1K+MPfLSFVpphzpdbfkhlWk6wBrTObBzS2T6db10PNOZgR9GoVsAWzwNyuhUYYbTp23j+4RrncfujZ4uAzXvwA==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MPL-2.0",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "win32"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/parcel"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/vite/node_modules/lightningcss-win32-x64-msvc": {[m
[32m+[m[32m      "version": "1.33.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/lightningcss-win32-x64-msvc/-/lightningcss-win32-x64-msvc-1.33.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-OlEICDx/Xl0FqSp4bry8zFnCvGpig3Gl4gCquvYwHuqJKEC1+n9NgDniFvqHGmMv1ZkqDJrDqKKSykTDX+ehuA==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "x64"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "license": "MPL-2.0",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "win32"[m
[32m+[m[32m      ],[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 12.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/parcel"[m
[32m+[m[32m      }[m
[32m+[m[32m    }[m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[1mdiff --git a/frontend/package.json b/frontend/package.json[m
[1mnew file mode 100644[m
[1mindex 0000000..80b8ad3[m
[1m--- /dev/null[m
[1m+++ b/frontend/package.json[m
[36m@@ -0,0 +1,27 @@[m
[32m+[m[32m{[m
[32m+[m[32m  "name": "frontend",[m
[32m+[m[32m  "private": true,[m
[32m+[m[32m  "version": "0.0.0",[m
[32m+[m[32m  "type": "module",[m
[32m+[m[32m  "scripts": {[m
[32m+[m[32m    "dev": "vite",[m
[32m+[m[32m    "build": "vite build",[m
[32m+[m[32m    "lint": "oxlint",[m
[32m+[m[32m    "preview": "vite preview"[m
[32m+[m[32m  },[m
[32m+[m[32m  "dependencies": {[m
[32m+[m[32m    "@tailwindcss/vite": "^4.3.3",[m
[32m+[m[32m    "axios": "^1.20.0",[m
[32m+[m[32m    "lucide-react": "^1.44.0",[m
[32m+[m[32m    "react": "^19.2.8",[m
[32m+[m[32m    "react-dom": "^19.2.8",[m
[32m+[m[32m    "tailwindcss": "^4.3.3"[m
[32m+[m[32m  },[m
[32m+[m[32m  "devDependencies": {[m
[32m+[m[32m    "@types/react": "^19.2.18",[m
[32m+[m[32m    "@types/react-dom": "^19.2.7",[m
[32m+[m[32m    "@vitejs/plugin-react": "^6.1.1",[m
[32m+[m[32m    "oxlint": "^1.81.0",[m
[32m+[m[32m    "vite": "^8.3.0"[m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[1mdiff --git a/frontend/public/favicon.svg b/frontend/public/favicon.svg[m
[1mnew file mode 100644[m
[1mindex 0000000..6893eb1[m
[1m--- /dev/null[m
[1m+++ b/frontend/public/favicon.svg[m
[36m@@ -0,0 +1 @@[m
[32m+[m[32m<svg xmlns="http://www.w3.org/2000/svg" width="48" height="46" fill="none" viewBox="0 0 48 46"><path fill="#863bff" d="M25.946 44.938c-.664.845-2.021.375-2.021-.698V33.937a2.26 2.26 0 0 0-2.262-2.262H10.287c-.92 0-1.456-1.04-.92-1.788l7.48-10.471c1.07-1.497 0-3.578-1.842-3.578H1.237c-.92 0-1.456-1.04-.92-1.788L10.013.474c.214-.297.556-.474.92-.474h28.894c.92 0 1.456 1.04.92 1.788l-7.48 10.471c-1.07 1.498 0 3.579 1.842 3.579h11.377c.943 0 1.473 1.088.89 1.83L25.947 44.94z" style="fill:#863bff;fill:color(display-p3 .5252 .23 1);fill-opacity:1"/><mask id="a" width="48" height="46" x="0" y="0" maskUnits="userSpaceOnUse" style="mask-type:alpha"><path fill="#000" d="M25.842 44.938c-.664.844-2.021.375-2.021-.698V33.937a2.26 2.26 0 0 0-2.262-2.262H10.183c-.92 0-1.456-1.04-.92-1.788l7.48-10.471c1.07-1.498 0-3.579-1.842-3.579H1.133c-.92 0-1.456-1.04-.92-1.787L9.91.473c.214-.297.556-.474.92-.474h28.894c.92 0 1.456 1.04.92 1.788l-7.48 10.471c-1.07 1.498 0 3.578 1.842 3.578h11.377c.943 0 1.473 1.088.89 1.832L25.843 44.94z" style="fill:#000;fill-opacity:1"/></mask><g mask="url(#a)"><g filter="url(#b)"><ellipse cx="5.508" cy="14.704" fill="#ede6ff" rx="5.508" ry="14.704" style="fill:#ede6ff;fill:color(display-p3 .9275 .9033 1);fill-opacity:1" transform="matrix(.00324 1 1 -.00324 -4.47 31.516)"/></g><g filter="url(#c)"><ellipse cx="10.399" cy="29.851" fill="#ede6ff" rx="10.399" ry="29.851" style="fill:#ede6ff;fill:color(display-p3 .9275 .9033 1);fill-opacity:1" transform="matrix(.00324 1 1 -.00324 -39.328 7.883)"/></g><g filter="url(#d)"><ellipse cx="5.508" cy="30.487" fill="#7e14ff" rx="5.508" ry="30.487" style="fill:#7e14ff;fill:color(display-p3 .4922 .0767 1);fill-opacity:1" transform="rotate(89.814 -25.913 -14.639)scale(1 -1)"/></g><g filter="url(#e)"><ellipse cx="5.508" cy="30.599" fill="#7e14ff" rx="5.508" ry="30.599" style="fill:#7e14ff;fill:color(display-p3 .4922 .0767 1);fill-opacity:1" transform="rotate(89.814 -32.644 -3.334)scale(1 -1)"/></g><g filter="url(#f)"><ellipse cx="5.508" cy="30.599" fill="#7e14ff" rx="5.508" ry="30.599" style="fill:#7e14ff;fill:color(display-p3 .4922 .0767 1);fill-opacity:1" transform="matrix(.00324 1 1 -.00324 -34.34 30.47)"/></g><g filter="url(#g)"><ellipse cx="14.072" cy="22.078" fill="#ede6ff" rx="14.072" ry="22.078" style="fill:#ede6ff;fill:color(display-p3 .9275 .9033 1);fill-opacity:1" transform="rotate(93.35 24.506 48.493)scale(-1 1)"/></g><g filter="url(#h)"><ellipse cx="3.47" cy="21.501" fill="#7e14ff" rx="3.47" ry="21.501" style="fill:#7e14ff;fill:color(display-p3 .4922 .0767 1);fill-opacity:1" transform="rotate(89.009 28.708 47.59)scale(-1 1)"/></g><g filter="url(#i)"><ellipse cx="3.47" cy="21.501" fill="#7e14ff" rx="3.47" ry="21.501" style="fill:#7e14ff;fill:color(display-p3 .4922 .0767 1);fill-opacity:1" transform="rotate(89.009 28.708 47.59)scale(-1 1)"/></g><g filter="url(#j)"><ellipse cx=".387" cy="8.972" fill="#7e14ff" rx="4.407" ry="29.108" style="fill:#7e14ff;fill:color(display-p3 .4922 .0767 1);fill-opacity:1" transform="rotate(39.51 .387 8.972)"/></g><g filter="url(#k)"><ellipse cx="47.523" cy="-6.092" fill="#7e14ff" rx="4.407" ry="29.108" style="fill:#7e14ff;fill:color(display-p3 .4922 .0767 1);fill-opacity:1" transform="rotate(37.892 47.523 -6.092)"/></g><g filter="url(#l)"><ellipse cx="41.412" cy="6.333" fill="#47bfff" rx="5.971" ry="9.665" style="fill:#47bfff;fill:color(display-p3 .2799 .748 1);fill-opacity:1" transform="rotate(37.892 41.412 6.333)"/></g><g filter="url(#m)"><ellipse cx="-1.879" cy="38.332" fill="#7e14ff" rx="4.407" ry="29.108" style="fill:#7e14ff;fill:color(display-p3 .4922 .0767 1);fill-opacity:1" transform="rotate(37.892 -1.88 38.332)"/></g><g filter="url(#n)"><ellipse cx="-1.879" cy="38.332" fill="#7e14ff" rx="4.407" ry="29.108" style="fill:#7e14ff;fill:color(display-p3 .4922 .0767 1);fill-opacity:1" transform="rotate(37.892 -1.88 38.332)"/></g><g filter="url(#o)"><ellipse cx="35.651" cy="29.907" fill="#7e14ff" rx="4.407" ry="29.108" style="fill:#7e14ff;fill:color(display-p3 .4922 .0767 1);fill-opacity:1" transform="rotate(37.892 35.651 29.907)"/></g><g filter="url(#p)"><ellipse cx="38.418" cy="32.4" fill="#47bfff" rx="5.971" ry="15.297" style="fill:#47bfff;fill:color(display-p3 .2799 .748 1);fill-opacity:1" transform="rotate(37.892 38.418 32.4)"/></g></g><defs><filter id="b" width="60.045" height="41.654" x="-19.77" y="16.149" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17158" stdDeviation="7.659"/></filter><filter id="c" width="90.34" height="51.437" x="-54.613" y="-7.533" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17158" stdDeviation="7.659"/></filter><filter id="d" width="79.355" height="29.4" x="-49.64" y="2.03" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17158" stdDeviation="4.596"/></filter><filter id="e" width="79.579" height="29.4" x="-45.045" y="20.029" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17158" stdDeviation="4.596"/></filter><filter id="f" width="79.579" height="29.4" x="-43.513" y="21.178" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17158" stdDeviation="4.596"/></filter><filter id="g" width="74.749" height="58.852" x="15.756" y="-17.901" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17158" stdDeviation="7.659"/></filter><filter id="h" width="61.377" height="25.362" x="23.548" y="2.284" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17158" stdDeviation="4.596"/></filter><filter id="i" width="61.377" height="25.362" x="23.548" y="2.284" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17158" stdDeviation="4.596"/></filter><filter id="j" width="56.045" height="63.649" x="-27.636" y="-22.853" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17158" stdDeviation="4.596"/></filter><filter id="k" width="54.814" height="64.646" x="20.116" y="-38.415" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17158" stdDeviation="4.596"/></filter><filter id="l" width="33.541" height="35.313" x="24.641" y="-11.323" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17158" stdDeviation="4.596"/></filter><filter id="m" width="54.814" height="64.646" x="-29.286" y="6.009" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17158" stdDeviation="4.596"/></filter><filter id="n" width="54.814" height="64.646" x="-29.286" y="6.009" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17158" stdDeviation="4.596"/></filter><filter id="o" width="54.814" height="64.646" x="8.244" y="-2.416" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17158" stdDeviation="4.596"/></filter><filter id="p" width="39.409" height="43.623" x="18.713" y="10.588" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17158" stdDeviation="4.596"/></filter></defs></svg>[m
\ No newline at end of file[m
[1mdiff --git a/frontend/public/icons.svg b/frontend/public/icons.svg[m
[1mnew file mode 100644[m
[1mindex 0000000..e952219[m
[1m--- /dev/null[m
[1m+++ b/frontend/public/icons.svg[m
[36m@@ -0,0 +1,24 @@[m
[32m+[m[32m<svg xmlns="http://www.w3.org/2000/svg">[m
[32m+[m[32m  <symbol id="bluesky-icon" viewBox="0 0 16 17">[m
[32m+[m[32m    <g clip-path="url(#bluesky-clip)"><path fill="#08060d" d="M7.75 7.735c-.693-1.348-2.58-3.86-4.334-5.097-1.68-1.187-2.32-.981-2.74-.79C.188 2.065.1 2.812.1 3.251s.241 3.602.398 4.13c.52 1.744 2.367 2.333 4.07 2.145-2.495.37-4.71 1.278-1.805 4.512 3.196 3.309 4.38-.71 4.987-2.746.608 2.036 1.307 5.91 4.93 2.746 2.72-2.746.747-4.143-1.747-4.512 1.702.189 3.55-.4 4.07-2.145.156-.528.397-3.691.397-4.13s-.088-1.186-.575-1.406c-.42-.19-1.06-.395-2.741.79-1.755 1.24-3.64 3.752-4.334 5.099"/></g>[m
[32m+[m[32m    <defs><clipPath id="bluesky-clip"><path fill="#fff" d="M.1.85h15.3v15.3H.1z"/></clipPath></defs>[m
[32m+[m[32m  </symbol>[m
[32m+[m[32m  <symbol id="discord-icon" viewBox="0 0 20 19">[m
[32m+[m[32m    <path fill="#08060d" d="M16.224 3.768a14.5 14.5 0 0 0-3.67-1.153c-.158.286-.343.67-.47.976a13.5 13.5 0 0 0-4.067 0c-.128-.306-.317-.69-.476-.976A14.4 14.4 0 0 0 3.868 3.77C1.546 7.28.916 10.703 1.231 14.077a14.7 14.7 0 0 0 4.5 2.306q.545-.748.965-1.587a9.5 9.5 0 0 1-1.518-.74q.191-.14.372-.293c2.927 1.369 6.107 1.369 8.999 0q.183.152.372.294-.723.437-1.52.74.418.838.963 1.588a14.6 14.6 0 0 0 4.504-2.308c.37-3.911-.63-7.302-2.644-10.309m-9.13 8.234c-.878 0-1.599-.82-1.599-1.82 0-.998.705-1.82 1.6-1.82.894 0 1.614.82 1.599 1.82.001 1-.705 1.82-1.6 1.82m5.91 0c-.878 0-1.599-.82-1.599-1.82 0-.998.705-1.82 1.6-1.82.893 0 1.614.82 1.599 1.82 0 1-.706 1.82-1.6 1.82"/>[m
[32m+[m[32m  </symbol>[m
[32m+[m[32m  <symbol id="documentation-icon" viewBox="0 0 21 20">[m
[32m+[m[32m    <path fill="none" stroke="#aa3bff" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.35" d="m15.5 13.333 1.533 1.322c.645.555.967.833.967 1.178s-.322.623-.967 1.179L15.5 18.333m-3.333-5-1.534 1.322c-.644.555-.966.833-.966 1.178s.322.623.966 1.179l1.534 1.321"/>[m
[32m+[m[32m    <path fill="none" stroke="#aa3bff" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.35" d="M17.167 10.836v-4.32c0-1.41 0-2.117-.224-2.68-.359-.906-1.118-1.621-2.08-1.96-.599-.21-1.349-.21-2.848-.21-2.623 0-3.935 0-4.983.369-1.684.591-3.013 1.842-3.641 3.428C3 6.449 3 7.684 3 10.154v2.122c0 2.558 0 3.838.706 4.726q.306.383.713.671c.76.536 1.79.64 3.581.66"/>[m
[32m+[m[32m    <path fill="none" stroke="#aa3bff" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.35" d="M3 10a2.78 2.78 0 0 1 2.778-2.778c.555 0 1.209.097 1.748-.047.48-.129.854-.503.982-.982.145-.54.048-1.194.048-1.749a2.78 2.78 0 0 1 2.777-2.777"/>[m
[32m+[m[32m  </symbol>[m
[32m+[m[32m  <symbol id="github-icon" viewBox="0 0 19 19">[m
[32m+[m[32m    <path fill="#08060d" fill-rule="evenodd" d="M9.356 1.85C5.05 1.85 1.57 5.356 1.57 9.694a7.84 7.84 0 0 0 5.324 7.44c.387.079.528-.168.528-.376 0-.182-.013-.805-.013-1.454-2.165.467-2.616-.935-2.616-.935-.349-.91-.864-1.143-.864-1.143-.71-.48.051-.48.051-.48.787.051 1.2.805 1.2.805.695 1.194 1.817.857 2.268.649.064-.507.27-.857.49-1.052-1.728-.182-3.545-.857-3.545-3.87 0-.857.31-1.558.8-2.104-.078-.195-.349-1 .077-2.078 0 0 .657-.208 2.14.805a7.5 7.5 0 0 1 1.946-.26c.657 0 1.328.092 1.946.26 1.483-1.013 2.14-.805 2.14-.805.426 1.078.155 1.883.078 2.078.502.546.799 1.247.799 2.104 0 3.013-1.818 3.675-3.558 3.87.284.247.528.714.528 1.454 0 1.052-.012 1.896-.012 2.156 0 .208.142.455.528.377a7.84 7.84 0 0 0 5.324-7.441c.013-4.338-3.48-7.844-7.773-7.844" clip-rule="evenodd"/>[m
[32m+[m[32m  </symbol>[m
[32m+[m[32m  <symbol id="social-icon" viewBox="0 0 20 20">[m
[32m+[m[32m    <path fill="none" stroke="#aa3bff" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.35" d="M12.5 6.667a4.167 4.167 0 1 0-8.334 0 4.167 4.167 0 0 0 8.334 0"/>[m
[32m+[m[32m    <path fill="none" stroke="#aa3bff" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.35" d="M2.5 16.667a5.833 5.833 0 0 1 8.75-5.053m3.837.474.513 1.035c.07.144.257.282.414.309l.93.155c.596.1.736.536.307.965l-.723.73a.64.64 0 0 0-.152.531l.207.903c.164.715-.213.991-.84.618l-.872-.52a.63.63 0 0 0-.577 0l-.872.52c-.624.373-1.003.094-.84-.618l.207-.903a.64.64 0 0 0-.152-.532l-.723-.729c-.426-.43-.289-.864.306-.964l.93-.156a.64.64 0 0 0 .412-.31l.513-1.034c.28-.562.735-.562 1.012 0"/>[m
[32m+[m[32m  </symbol>[m
[32m+[m[32m  <symbol id="x-icon" viewBox="0 0 19 19">[m
[32m+[m[32m    <path fill="#08060d" fill-rule="evenodd" d="M1.893 1.98c.052.072 1.245 1.769 2.653 3.77l2.892 4.114c.183.261.333.48.333.486s-.068.089-.152.183l-.522.593-.765.867-3.597 4.087c-.375.426-.734.834-.798.905a1 1 0 0 0-.118.148c0 .01.236.017.664.017h.663l.729-.83c.4-.457.796-.906.879-.999a692 692 0 0 0 1.794-2.038c.034-.037.301-.34.594-.675l.551-.624.345-.392a7 7 0 0 1 .34-.374c.006 0 .93 1.306 2.052 2.903l2.084 2.965.045.063h2.275c1.87 0 2.273-.003 2.266-.021-.008-.02-1.098-1.572-3.894-5.547-2.013-2.862-2.28-3.246-2.273-3.266.008-.019.282-.332 2.085-2.38l2-2.274 1.567-1.782c.022-.028-.016-.03-.65-.03h-.674l-.3.342a871 871 0 0 1-1.782 2.025c-.067.075-.405.458-.75.852a100 100 0 0 1-.803.91c-.148.172-.299.344-.99 1.127-.304.343-.32.358-.345.327-.015-.019-.904-1.282-1.976-2.808L6.365 1.85H1.8zm1.782.91 8.078 11.294c.772 1.08 1.413 1.973 1.425 1.984.016.017.241.02 1.05.017l1.03-.004-2.694-3.766L7.796 5.75 5.722 2.852l-1.039-.004-1.039-.004z" clip-rule="evenodd"/>[m
[32m+[m[32m  </symbol>[m
[32m+[m[32m</svg>[m
[1mdiff --git a/frontend/src/App.css b/frontend/src/App.css[m
[1mnew file mode 100644[m
[1mindex 0000000..f90339d[m
[1m--- /dev/null[m
[1m+++ b/frontend/src/App.css[m
[36m@@ -0,0 +1,184 @@[m
[32m+[m[32m.counter {[m
[32m+[m[32m  font-size: 16px;[m
[32m+[m[32m  padding: 5px 10px;[m
[32m+[m[32m  border-radius: 5px;[m
[32m+[m[32m  color: var(--accent);[m
[32m+[m[32m  background: var(--accent-bg);[m
[32m+[m[32m  border: 2px solid transparent;[m
[32m+[m[32m  transition: border-color 0.3s;[m
[32m+[m[32m  margin-bottom: 24px;[m
[32m+[m
[32m+[m[32m  &:hover {[m
[32m+[m[32m    border-color: var(--accent-border);[m
[32m+[m[32m  }[m
[32m+[m[32m  &:focus-visible {[m
[32m+[m[32m    outline: 2px solid var(--accent);[m
[32m+[m[32m    outline-offset: 2px;[m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.hero {[m
[32m+[m[32m  position: relative;[m
[32m+[m
[32m+[m[32m  .base,[m
[32m+[m[32m  .framework,[m
[32m+[m[32m  .vite {[m
[32m+[m[32m    inset-inline: 0;[m
[32m+[m[32m    margin: 0 auto;[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  .base {[m
[32m+[m[32m    width: 170px;[m
[32m+[m[32m    position: relative;[m
[32m+[m[32m    z-index: 0;[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  .framework,[m
[32m+[m[32m  .vite {[m
[32m+[m[32m    position: absolute;[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  .framework {[m
[32m+[m[32m    z-index: 1;[m
[32m+[m[32m    top: 34px;[m
[32m+[m[32m    height: 28px;[m
[32m+[m[32m    transform: perspective(2000px) rotateZ(300deg) rotateX(44deg) rotateY(39deg)[m
[32m+[m[32m      scale(1.4);[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  .vite {[m
[32m+[m[32m    z-index: 0;[m
[32m+[m[32m    top: 107px;[m
[32m+[m[32m    height: 26px;[m
[32m+[m[32m    width: auto;[m
[32m+[m[32m    transform: perspective(2000px) rotateZ(300deg) rotateX(40deg) rotateY(39deg)[m
[32m+[m[32m      scale(0.8);[m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m#center {[m
[32m+[m[32m  display: flex;[m
[32m+[m[32m  flex-direction: column;[m
[32m+[m[32m  gap: 25px;[m
[32m+[m[32m  place-content: center;[m
[32m+[m[32m  place-items: center;[m
[32m+[m[32m  flex-grow: 1;[m
[32m+[m
[32m+[m[32m  @media (max-width: 1024px) {[m
[32m+[m[32m    padding: 32px 20px 24px;[m
[32m+[m[32m    gap: 18px;[m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m#next-steps {[m
[32m+[m[32m  display: flex;[m
[32m+[m[32m  border-top: 1px solid var(--border);[m
[32m+[m[32m  text-align: left;[m
[32m+[m
[32m+[m[32m  & > div {[m
[32m+[m[32m    flex: 1 1 0;[m
[32m+[m[32m    padding: 32px;[m
[32m+[m[32m    @media (max-width: 1024px) {[m
[32m+[m[32m      padding: 24px 20px;[m
[32m+[m[32m    }[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  .icon {[m
[32m+[m[32m    margin-bottom: 16px;[m
[32m+[m[32m    width: 22px;[m
[32m+[m[32m    height: 22px;[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  @media (max-width: 1024px) {[m
[32m+[m[32m    flex-direction: column;[m
[32m+[m[32m    text-align: center;[m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m#docs {[m
[32m+[m[32m  border-right: 1px solid var(--border);[m
[32m+[m
[32m+[m[32m  @media (max-width: 1024px) {[m
[32m+[m[32m    border-right: none;[m
[32m+[m[32m    border-bottom: 1px solid var(--border);[m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m#next-steps ul {[m
[32m+[m[32m  list-style: none;[m
[32m+[m[32m  padding: 0;[m
[32m+[m[32m  display: flex;[m
[32m+[m[32m  gap: 8px;[m
[32m+[m[32m  margin: 32px 0 0;[m
[32m+[m
[32m+[m[32m  .logo {[m
[32m+[m[32m    height: 18px;[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  a {[m
[32m+[m[32m    color: var(--text-h);[m
[32m+[m[32m    font-size: 16px;[m
[32m+[m[32m    border-radius: 6px;[m
[32m+[m[32m    background: var(--social-bg);[m
[32m+[m[32m    display: flex;[m
[32m+[m[32m    padding: 6px 12px;[m
[32m+[m[32m    align-items: center;[m
[32m+[m[32m    gap: 8px;[m
[32m+[m[32m    text-decoration: none;[m
[32m+[m[32m    transition: box-shadow 0.3s;[m
[32m+[m
[32m+[m[32m    &:hover {[m
[32m+[m[32m      box-shadow: var(--shadow);[m
[32m+[m[32m    }[m
[32m+[m[32m    .button-icon {[m
[32m+[m[32m      height: 18px;[m
[32m+[m[32m      width: 18px;[m
[32m+[m[32m    }[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  @media (max-width: 1024px) {[m
[32m+[m[32m    margin-top: 20px;[m
[32m+[m[32m    flex-wrap: wrap;[m
[32m+[m[32m    justify-content: center;[m
[32m+[m
[32m+[m[32m    li {[m
[32m+[m[32m      flex: 1 1 calc(50% - 8px);[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    a {[m
[32m+[m[32m      width: 100%;[m
[32m+[m[32m      justify-content: center;[m
[32m+[m[32m      box-sizing: border-box;[m
[32m+[m[32m    }[m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m#spacer {[m
[32m+[m[32m  height: 88px;[m
[32m+[m[32m  border-top: 1px solid var(--border);[m
[32m+[m[32m  @media (max-width: 1024px) {[m
[32m+[m[32m    height: 48px;[m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.ticks {[m
[32m+[m[32m  position: relative;[m
[32m+[m[32m  width: 100%;[m
[32m+[m
[32m+[m[32m  &::before,[m
[32m+[m[32m  &::after {[m
[32m+[m[32m    content: '';[m
[32m+[m[32m    position: absolute;[m
[32m+[m[32m    top: -4.5px;[m
[32m+[m[32m    border: 5px solid transparent;[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  &::before {[m
[32m+[m[32m    left: 0;[m
[32m+[m[32m    border-left-color: var(--border);[m
[32m+[m[32m  }[m
[32m+[m[32m  &::after {[m
[32m+[m[32m    right: 0;[m
[32m+[m[32m    border-right-color: var(--border);[m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[1mdiff --git a/frontend/src/App.jsx b/frontend/src/App.jsx[m
[1mnew file mode 100644[m
[1mindex 0000000..f3b49c0[m
[1m--- /dev/null[m
[1m+++ b/frontend/src/App.jsx[m
[36m@@ -0,0 +1,12 @@[m
[32m+[m[32mimport React from 'react';[m
[32m+[m[32mimport AppointmentBoard from './pages/AppointmentBoard';[m
[32m+[m
[32m+[m[32mexport function App() {[m
[32m+[m[32m  return ([m
[32m+[m[32m    <div className="min-h-screen bg-slate-50">[m
[32m+[m[32m      <AppointmentBoard />[m
[32m+[m[32m    </div>[m
[32m+[m[32m  );[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32mexport default App;[m
[1mdiff --git a/frontend/src/assets/hero.png b/frontend/src/assets/hero.png[m
[1mnew file mode 100644[m
[1mindex 0000000..02251f4[m
Binary files /dev/null and b/frontend/src/assets/hero.png differ
[1mdiff --git a/frontend/src/assets/react.svg b/frontend/src/assets/react.svg[m
[1mnew file mode 100644[m
[1mindex 0000000..6c87de9[m
[1m--- /dev/null[m
[1m+++ b/frontend/src/assets/react.svg[m
[36m@@ -0,0 +1 @@[m
[32m+[m[32m<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" aria-hidden="true" role="img" class="iconify iconify--logos" width="35.93" height="32" preserveAspectRatio="xMidYMid meet" viewBox="0 0 256 228"><path fill="#00D8FF" d="M210.483 73.824a171.49 171.49 0 0 0-8.24-2.597c.465-1.9.893-3.777 1.273-5.621c6.238-30.281 2.16-54.676-11.769-62.708c-13.355-7.7-35.196.329-57.254 19.526a171.23 171.23 0 0 0-6.375 5.848a155.866 155.866 0 0 0-4.241-3.917C100.759 3.829 77.587-4.822 63.673 3.233C50.33 10.957 46.379 33.89 51.995 62.588a170.974 170.974 0 0 0 1.892 8.48c-3.28.932-6.445 1.924-9.474 2.98C17.309 83.498 0 98.307 0 113.668c0 15.865 18.582 31.778 46.812 41.427a145.52 145.52 0 0 0 6.921 2.165a167.467 167.467 0 0 0-2.01 9.138c-5.354 28.2-1.173 50.591 12.134 58.266c13.744 7.926 36.812-.22 59.273-19.855a145.567 145.567 0 0 0 5.342-4.923a168.064 168.064 0 0 0 6.92 6.314c21.758 18.722 43.246 26.282 56.54 18.586c13.731-7.949 18.194-32.003 12.4-61.268a145.016 145.016 0 0 0-1.535-6.842c1.62-.48 3.21-.974 4.76-1.488c29.348-9.723 48.443-25.443 48.443-41.52c0-15.417-17.868-30.326-45.517-39.844Zm-6.365 70.984c-1.4.463-2.836.91-4.3 1.345c-3.24-10.257-7.612-21.163-12.963-32.432c5.106-11 9.31-21.767 12.459-31.957c2.619.758 5.16 1.557 7.61 2.4c23.69 8.156 38.14 20.213 38.14 29.504c0 9.896-15.606 22.743-40.946 31.14Zm-10.514 20.834c2.562 12.94 2.927 24.64 1.23 33.787c-1.524 8.219-4.59 13.698-8.382 15.893c-8.067 4.67-25.32-1.4-43.927-17.412a156.726 156.726 0 0 1-6.437-5.87c7.214-7.889 14.423-17.06 21.459-27.246c12.376-1.098 24.068-2.894 34.671-5.345a134.17 134.17 0 0 1 1.386 6.193ZM87.276 214.515c-7.882 2.783-14.16 2.863-17.955.675c-8.075-4.657-11.432-22.636-6.853-46.752a156.923 156.923 0 0 1 1.869-8.499c10.486 2.32 22.093 3.988 34.498 4.994c7.084 9.967 14.501 19.128 21.976 27.15a134.668 134.668 0 0 1-4.877 4.492c-9.933 8.682-19.886 14.842-28.658 17.94ZM50.35 144.747c-12.483-4.267-22.792-9.812-29.858-15.863c-6.35-5.437-9.555-10.836-9.555-15.216c0-9.322 13.897-21.212 37.076-29.293c2.813-.98 5.757-1.905 8.812-2.773c3.204 10.42 7.406 21.315 12.477 32.332c-5.137 11.18-9.399 22.249-12.634 32.792a134.718 134.718 0 0 1-6.318-1.979Zm12.378-84.26c-4.811-24.587-1.616-43.134 6.425-47.789c8.564-4.958 27.502 2.111 47.463 19.835a144.318 144.318 0 0 1 3.841 3.545c-7.438 7.987-14.787 17.08-21.808 26.988c-12.04 1.116-23.565 2.908-34.161 5.309a160.342 160.342 0 0 1-1.76-7.887Zm110.427 27.268a347.8 347.8 0 0 0-7.785-12.803c8.168 1.033 15.994 2.404 23.343 4.08c-2.206 7.072-4.956 14.465-8.193 22.045a381.151 381.151 0 0 0-7.365-13.322Zm-45.032-43.861c5.044 5.465 10.096 11.566 15.065 18.186a322.04 322.04 0 0 0-30.257-.006c4.974-6.559 10.069-12.652 15.192-18.18ZM82.802 87.83a323.167 323.167 0 0 0-7.227 13.238c-3.184-7.553-5.909-14.98-8.134-22.152c7.304-1.634 15.093-2.97 23.209-3.984a321.524 321.524 0 0 0-7.848 12.897Zm8.081 65.352c-8.385-.936-16.291-2.203-23.593-3.793c2.26-7.3 5.045-14.885 8.298-22.6a321.187 321.187 0 0 0 7.257 13.246c2.594 4.48 5.28 8.868 8.038 13.147Zm37.542 31.03c-5.184-5.592-10.354-11.779-15.403-18.433c4.902.192 9.899.29 14.978.29c5.218 0 10.376-.117 15.453-.343c-4.985 6.774-10.018 12.97-15.028 18.486Zm52.198-57.817c3.422 7.8 6.306 15.345 8.596 22.52c-7.422 1.694-15.436 3.058-23.88 4.071a382.417 382.417 0 0 0 7.859-13.026a347.403 347.403 0 0 0 7.425-13.565Zm-16.898 8.101a358.557 358.557 0 0 1-12.281 19.815a329.4 329.4 0 0 1-23.444.823c-7.967 0-15.716-.248-23.178-.732a310.202 310.202 0 0 1-12.513-19.846h.001a307.41 307.41 0 0 1-10.923-20.627a310.278 310.278 0 0 1 10.89-20.637l-.001.001a307.318 307.318 0 0 1 12.413-19.761c7.613-.576 15.42-.876 23.31-.876H128c7.926 0 15.743.303 23.354.883a329.357 329.357 0 0 1 12.335 19.695a358.489 358.489 0 0 1 11.036 20.54a329.472 329.472 0 0 1-11 20.722Zm22.56-122.124c8.572 4.944 11.906 24.881 6.52 51.026c-.344 1.668-.73 3.367-1.15 5.09c-10.622-2.452-22.155-4.275-34.23-5.408c-7.034-10.017-14.323-19.124-21.64-27.008a160.789 160.789 0 0 1 5.888-5.4c18.9-16.447 36.564-22.941 44.612-18.3ZM128 90.808c12.625 0 22.86 10.235 22.86 22.86s-10.235 22.86-22.86 22.86s-22.86-10.235-22.86-22.86s10.235-22.86 22.86-22.86Z"></path></svg>[m
\ No newline at end of file[m
[1mdiff --git a/frontend/src/assets/vite.svg b/frontend/src/assets/vite.svg[m
[1mnew file mode 100644[m
[1mindex 0000000..5101b67[m
[1m--- /dev/null[m
[1m+++ b/frontend/src/assets/vite.svg[m
[36m@@ -0,0 +1 @@[m
[32m+[m[32m<svg xmlns="http://www.w3.org/2000/svg" width="77" height="47" fill="none" aria-labelledby="vite-logo-title" viewBox="0 0 77 47"><title id="vite-logo-title">Vite</title><style>.parenthesis{fill:#000}@media (prefers-color-scheme:dark){.parenthesis{fill:#fff}}</style><path fill="#9135ff" d="M40.151 45.71c-.663.844-2.02.374-2.02-.699V34.708a2.26 2.26 0 0 0-2.262-2.262H24.493c-.92 0-1.457-1.04-.92-1.788l7.479-10.471c1.07-1.498 0-3.578-1.842-3.578H15.443c-.92 0-1.456-1.04-.92-1.788l9.696-13.576c.213-.297.556-.474.92-.474h28.894c.92 0 1.456 1.04.92 1.788l-7.48 10.472c-1.07 1.497 0 3.578 1.842 3.578h11.376c.944 0 1.474 1.087.89 1.83L40.153 45.712z"/><mask id="a" width="48" height="47" x="14" y="0" maskUnits="userSpaceOnUse" style="mask-type:alpha"><path fill="#000" d="M40.047 45.71c-.663.843-2.02.374-2.02-.699V34.708a2.26 2.26 0 0 0-2.262-2.262H24.389c-.92 0-1.457-1.04-.92-1.788l7.479-10.472c1.07-1.497 0-3.578-1.842-3.578H15.34c-.92 0-1.456-1.04-.92-1.788l9.696-13.575c.213-.297.556-.474.92-.474H53.93c.92 0 1.456 1.04.92 1.788L47.37 13.03c-1.07 1.498 0 3.578 1.842 3.578h11.376c.944 0 1.474 1.088.89 1.831L40.049 45.712z"/></mask><g mask="url(#a)"><g filter="url(#b)"><ellipse cx="5.508" cy="14.704" fill="#eee6ff" rx="5.508" ry="14.704" transform="rotate(269.814 20.96 11.29)scale(-1 1)"/></g><g filter="url(#c)"><ellipse cx="10.399" cy="29.851" fill="#eee6ff" rx="10.399" ry="29.851" transform="rotate(89.814 -16.902 -8.275)scale(1 -1)"/></g><g filter="url(#d)"><ellipse cx="5.508" cy="30.487" fill="#8900ff" rx="5.508" ry="30.487" transform="rotate(89.814 -19.197 -7.127)scale(1 -1)"/></g><g filter="url(#e)"><ellipse cx="5.508" cy="30.599" fill="#8900ff" rx="5.508" ry="30.599" transform="rotate(89.814 -25.928 4.177)scale(1 -1)"/></g><g filter="url(#f)"><ellipse cx="5.508" cy="30.599" fill="#8900ff" rx="5.508" ry="30.599" transform="rotate(89.814 -25.738 5.52)scale(1 -1)"/></g><g filter="url(#g)"><ellipse cx="14.072" cy="22.078" fill="#eee6ff" rx="14.072" ry="22.078" transform="rotate(93.35 31.245 55.578)scale(-1 1)"/></g><g filter="url(#h)"><ellipse cx="3.47" cy="21.501" fill="#8900ff" rx="3.47" ry="21.501" transform="rotate(89.009 35.419 55.202)scale(-1 1)"/></g><g filter="url(#i)"><ellipse cx="3.47" cy="21.501" fill="#8900ff" rx="3.47" ry="21.501" transform="rotate(89.009 35.419 55.202)scale(-1 1)"/></g><g filter="url(#j)"><ellipse cx="14.592" cy="9.743" fill="#8900ff" rx="4.407" ry="29.108" transform="rotate(39.51 14.592 9.743)"/></g><g filter="url(#k)"><ellipse cx="61.728" cy="-5.321" fill="#8900ff" rx="4.407" ry="29.108" transform="rotate(37.892 61.728 -5.32)"/></g><g filter="url(#l)"><ellipse cx="55.618" cy="7.104" fill="#00c2ff" rx="5.971" ry="9.665" transform="rotate(37.892 55.618 7.104)"/></g><g filter="url(#m)"><ellipse cx="12.326" cy="39.103" fill="#8900ff" rx="4.407" ry="29.108" transform="rotate(37.892 12.326 39.103)"/></g><g filter="url(#n)"><ellipse cx="12.326" cy="39.103" fill="#8900ff" rx="4.407" ry="29.108" transform="rotate(37.892 12.326 39.103)"/></g><g filter="url(#o)"><ellipse cx="49.857" cy="30.678" fill="#8900ff" rx="4.407" ry="29.108" transform="rotate(37.892 49.857 30.678)"/></g><g filter="url(#p)"><ellipse cx="52.623" cy="33.171" fill="#00c2ff" rx="5.971" ry="15.297" transform="rotate(37.892 52.623 33.17)"/></g></g><path d="M6.919 0c-9.198 13.166-9.252 33.575 0 46.789h6.215c-9.25-13.214-9.196-33.623 0-46.789zm62.424 0h-6.215c9.198 13.166 9.252 33.575 0 46.789h6.215c9.25-13.214 9.196-33.623 0-46.789" class="parenthesis"/><defs><filter id="b" width="60.045" height="41.654" x="-5.564" y="16.92" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17286" stdDeviation="7.659"/></filter><filter id="c" width="90.34" height="51.437" x="-40.407" y="-6.762" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17286" stdDeviation="7.659"/></filter><filter id="d" width="79.355" height="29.4" x="-35.435" y="2.801" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17286" stdDeviation="4.596"/></filter><filter id="e" width="79.579" height="29.4" x="-30.84" y="20.8" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17286" stdDeviation="4.596"/></filter><filter id="f" width="79.579" height="29.4" x="-29.307" y="21.949" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17286" stdDeviation="4.596"/></filter><filter id="g" width="74.749" height="58.852" x="29.961" y="-17.13" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17286" stdDeviation="7.659"/></filter><filter id="h" width="61.377" height="25.362" x="37.754" y="3.055" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17286" stdDeviation="4.596"/></filter><filter id="i" width="61.377" height="25.362" x="37.754" y="3.055" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17286" stdDeviation="4.596"/></filter><filter id="j" width="56.045" height="63.649" x="-13.43" y="-22.082" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17286" stdDeviation="4.596"/></filter><filter id="k" width="54.814" height="64.646" x="34.321" y="-37.644" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17286" stdDeviation="4.596"/></filter><filter id="l" width="33.541" height="35.313" x="38.847" y="-10.552" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17286" stdDeviation="4.596"/></filter><filter id="m" width="54.814" height="64.646" x="-15.081" y="6.78" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17286" stdDeviation="4.596"/></filter><filter id="n" width="54.814" height="64.646" x="-15.081" y="6.78" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17286" stdDeviation="4.596"/></filter><filter id="o" width="54.814" height="64.646" x="22.45" y="-1.645" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17286" stdDeviation="4.596"/></filter><filter id="p" width="39.409" height="43.623" x="32.919" y="11.36" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur result="effect1_foregroundBlur_2002_17286" stdDeviation="4.596"/></filter></defs></svg>[m
[1mdiff --git a/frontend/src/components/AppointmentCard.jsx b/frontend/src/components/AppointmentCard.jsx[m
[1mnew file mode 100644[m
[1mindex 0000000..be4e0ad[m
[1m--- /dev/null[m
[1m+++ b/frontend/src/components/AppointmentCard.jsx[m
[36m@@ -0,0 +1,165 @@[m
[32m+[m[32mimport React from 'react';[m
[32m+[m[32mimport { Calendar, Clock, Edit2, CheckCircle, Ban } from 'lucide-react';[m
[32m+[m[32mimport StatusBadge from './StatusBadge';[m
[32m+[m
[32m+[m[32m/**[m
[32m+[m[32m * Format time string 'HH:MM:SS' or 'HH:MM' to friendly 'h:mm AM/PM'[m
[32m+[m[32m */[m
[32m+[m[32mconst formatDisplayTime = (timeStr) => {[m
[32m+[m[32m  if (!timeStr) return '';[m
[32m+[m[32m  const parts = timeStr.split(':');[m
[32m+[m[32m  if (parts.length < 2) return timeStr;[m
[32m+[m[32m  let hour = parseInt(parts[0], 10);[m
[32m+[m[32m  const minute = parts[1];[m
[32m+[m[32m  const ampm = hour >= 12 ? 'PM' : 'AM';[m
[32m+[m[32m  hour = hour % 12;[m
[32m+[m[32m  hour = hour ? hour : 12;[m
[32m+[m[32m  return `${hour}:${minute} ${ampm}`;[m
[32m+[m[32m};[m
[32m+[m
[32m+[m[32m/**[m
[32m+[m[32m * Format date string 'YYYY-MM-DD' to readable 'Month Day, Year'[m
[32m+[m[32m */[m
[32m+[m[32mconst formatDisplayDate = (dateStr) => {[m
[32m+[m[32m  if (!dateStr) return '';[m
[32m+[m[32m  try {[m
[32m+[m[32m    const [year, month, day] = dateStr.split('-').map(Number);[m
[32m+[m[32m    const d = new Date(year, month - 1, day);[m
[32m+[m[32m    return d.toLocaleDateString(undefined, {[m
[32m+[m[32m      weekday: 'short',[m
[32m+[m[32m      month: 'short',[m
[32m+[m[32m      day: 'numeric',[m
[32m+[m[32m      year: 'numeric',[m
[32m+[m[32m    });[m
[32m+[m[32m  } catch {[m
[32m+[m[32m    return dateStr;[m
[32m+[m[32m  }[m
[32m+[m[32m};[m
[32m+[m
[32m+[m[32mexport const AppointmentCard = ({[m
[32m+[m[32m  appointment,[m
[32m+[m[32m  onEdit,[m
[32m+[m[32m  onComplete,[m
[32m+[m[32m  onCancel,[m
[32m+[m[32m}) => {[m
[32m+[m[32m  const { id, title, description, date, start_time, end_time, status } = appointment;[m
[32m+[m
[32m+[m[32m  const isScheduled = status === 'Scheduled';[m
[32m+[m[32m  const isCompleted = status === 'Completed';[m
[32m+[m[32m  const isCancelled = status === 'Cancelled';[m
[32m+[m
[32m+[m[32m  return ([m
[32m+[m[32m    <div[m
[32m+[m[32m      id={`appointment-card-${id}`}[m
[32m+[m[32m      className={`group relative rounded-2xl border transition-all duration-200 flex flex-col justify-between overflow-hidden ${[m
[32m+[m[32m        isCancelled[m
[32m+[m[32m          ? 'bg-slate-50/60 border-slate-200/60 opacity-85 hover:opacity-100'[m
[32m+[m[32m          : isCompleted[m
[32m+[m[32m          ? 'bg-white border-emerald-100 shadow-sm hover:shadow-md hover:border-emerald-200'[m
[32m+[m[32m          : 'bg-white border-slate-200/90 shadow-sm hover:shadow-md hover:border-blue-200'[m
[32m+[m[32m      }`}[m
[32m+[m[32m    >[m
[32m+[m[32m      {/* Top Accent Strip */}[m
[32m+[m[32m      <div[m
[32m+[m[32m        className={`h-1.5 w-full ${[m
[32m+[m[32m          isScheduled[m
[32m+[m[32m            ? 'bg-gradient-to-r from-blue-500 to-indigo-500'[m
[32m+[m[32m            : isCompleted[m
[32m+[m[32m            ? 'bg-gradient-to-r from-emerald-400 to-teal-500'[m
[32m+[m[32m            : 'bg-slate-300'[m
[32m+[m[32m        }`}[m
[32m+[m[32m      />[m
[32m+[m
[32m+[m[32m      <div className="p-5 flex-1 flex flex-col">[m
[32m+[m[32m        {/* Card Header: Title & Status */}[m
[32m+[m[32m        <div className="flex items-start justify-between gap-3 mb-2.5">[m
[32m+[m[32m          <h3[m
[32m+[m[32m            className={`text-base font-semibold leading-snug line-clamp-2 ${[m
[32m+[m[32m              isCancelled ? 'text-slate-500 line-through' : 'text-slate-900'[m
[32m+[m[32m            }`}[m
[32m+[m[32m          >[m
[32m+[m[32m            {title}[m
[32m+[m[32m          </h3>[m
[32m+[m[32m          <div className="shrink-0">[m
[32m+[m[32m            <StatusBadge status={status} />[m
[32m+[m[32m          </div>[m
[32m+[m[32m        </div>[m
[32m+[m
[32m+[m[32m        {/* Description */}[m
[32m+[m[32m        <p className="text-xs text-slate-600 leading-relaxed mb-4 line-clamp-3 flex-1">[m
[32m+[m[32m          {description || ([m
[32m+[m[32m            <span className="text-slate-400 italic">No description provided</span>[m
[32m+[m[32m          )}[m
[32m+[m[32m        </p>[m
[32m+[m
[32m+[m[32m        {/* Date & Time metadata */}[m
[32m+[m[32m        <div className="pt-3 border-t border-slate-100 space-y-1.5 text-xs text-slate-600">[m
[32m+[m[32m          <div className="flex items-center gap-2">[m
[32m+[m[32m            <Calendar className="w-3.5 h-3.5 text-slate-400 shrink-0" />[m
[32m+[m[32m            <span className="font-medium text-slate-700">{formatDisplayDate(date)}</span>[m
[32m+[m[32m          </div>[m
[32m+[m[32m          <div className="flex items-center gap-2">[m
[32m+[m[32m            <Clock className="w-3.5 h-3.5 text-slate-400 shrink-0" />[m
[32m+[m[32m            <span className="font-mono text-slate-700">[m
[32m+[m[32m              {formatDisplayTime(start_time)} – {formatDisplayTime(end_time)}[m
[32m+[m[32m            </span>[m
[32m+[m[32m          </div>[m
[32m+[m[32m        </div>[m
[32m+[m[32m      </div>[m
[32m+[m
[32m+[m[32m      {/* Card Actions Footer */}[m
[32m+[m[32m      <div className="px-5 py-3 bg-slate-50/70 border-t border-slate-100 flex items-center justify-end gap-2">[m
[32m+[m[32m        {/* Edit Action - enabled for Scheduled & Completed */}[m
[32m+[m[32m        {!isCancelled && ([m
[32m+[m[32m          <button[m
[32m+[m[32m            type="button"[m
[32m+[m[32m            id={`btn-edit-${id}`}[m
[32m+[m[32m            onClick={() => onEdit(appointment)}[m
[32m+[m[32m            className="inline-flex items-center gap-1.5 px-2.5 py-1.5 text-xs font-medium text-slate-700 hover:text-slate-900 hover:bg-slate-200/70 rounded-lg transition-colors cursor-pointer"[m
[32m+[m[32m            title="Edit appointment"[m
[32m+[m[32m          >[m
[32m+[m[32m            <Edit2 className="w-3.5 h-3.5 text-slate-500" />[m
[32m+[m[32m            Edit[m
[32m+[m[32m          </button>[m
[32m+[m[32m        )}[m
[32m+[m
[32m+[m[32m        {/* Complete Action - only for Scheduled */}[m
[32m+[m[32m        {isScheduled && ([m
[32m+[m[32m          <button[m
[32m+[m[32m            type="button"[m
[32m+[m[32m            id={`btn-complete-${id}`}[m
[32m+[m[32m            onClick={() => onComplete(id)}[m
[32m+[m[32m            className="inline-flex items-center gap-1.5 px-2.5 py-1.5 text-xs font-medium text-emerald-700 hover:text-emerald-800 bg-emerald-50 hover:bg-emerald-100/80 border border-emerald-200/80 rounded-lg transition-colors cursor-pointer"[m
[32m+[m[32m            title="Mark appointment as completed"[m
[32m+[m[32m          >[m
[32m+[m[32m            <CheckCircle className="w-3.5 h-3.5 text-emerald-600" />[m
[32m+[m[32m            Complete[m
[32m+[m[32m          </button>[m
[32m+[m[32m        )}[m
[32m+[m
[32m+[m[32m        {/* Cancel Action - for Scheduled or Completed */}[m
[32m+[m[32m        {!isCancelled && ([m
[32m+[m[32m          <button[m
[32m+[m[32m            type="button"[m
[32m+[m[32m            id={`btn-cancel-${id}`}[m
[32m+[m[32m            onClick={() => onCancel(appointment)}[m
[32m+[m[32m            className="inline-flex items-center gap-1.5 px-2.5 py-1.5 text-xs font-medium text-rose-700 hover:text-rose-800 hover:bg-rose-50 rounded-lg transition-colors cursor-pointer"[m
[32m+[m[32m            title="Cancel appointment"[m
[32m+[m[32m          >[m
[32m+[m[32m            <Ban className="w-3.5 h-3.5 text-rose-500" />[m
[32m+[m[32m            Cancel[m
[32m+[m[32m          </button>[m
[32m+[m[32m        )}[m
[32m+[m
[32m+[m[32m        {/* If Cancelled, show informational badge */}[m
[32m+[m[32m        {isCancelled && ([m
[32m+[m[32m          <span className="text-[11px] text-slate-400 italic py-1">[m
[32m+[m[32m            Slot released[m
[32m+[m[32m          </span>[m
[32m+[m[32m        )}[m
[32m+[m[32m      </div>[m
[32m+[m[32m    </div>[m
[32m+[m[32m  );[m
[32m+[m[32m};[m
[32m+[m
[32m+[m[32mexport default AppointmentCard;[m
[1mdiff --git a/frontend/src/components/AppointmentFilters.jsx b/frontend/src/components/AppointmentFilters.jsx[m
[1mnew file mode 100644[m
[1mindex 0000000..79fdd67[m
[1m--- /dev/null[m
[1m+++ b/frontend/src/components/AppointmentFilters.jsx[m
[36m@@ -0,0 +1,88 @@[m
[32m+[m[32mimport React from 'react';[m
[32m+[m[32mimport { Calendar, Filter, X, RotateCcw } from 'lucide-react';[m
[32m+[m
[32m+[m[32mexport const AppointmentFilters = ({[m
[32m+[m[32m  filterDate,[m
[32m+[m[32m  filterStatus,[m
[32m+[m[32m  onDateChange,[m
[32m+[m[32m  onStatusChange,[m
[32m+[m[32m  onClearFilters,[m
[32m+[m[32m  totalCount,[m
[32m+[m[32m}) => {[m
[32m+[m[32m  const hasActiveFilters = Boolean(filterDate || (filterStatus && filterStatus !== 'All'));[m
[32m+[m
[32m+[m[32m  return ([m
[32m+[m[32m    <div className="bg-white border border-slate-200/80 rounded-2xl p-4 sm:p-5 shadow-sm mb-6 transition-all">[m
[32m+[m[32m      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">[m
[32m+[m[32m        {/* Left Side: Filter Form Controls */}[m
[32m+[m[32m        <div className="flex flex-wrap items-center gap-3">[m
[32m+[m[32m          {/* Date Picker */}[m
[32m+[m[32m          <div className="relative min-w-[180px] flex-1 sm:flex-initial">[m
[32m+[m[32m            <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">[m
[32m+[m[32m              <Calendar className="w-4 h-4" />[m
[32m+[m[32m            </div>[m
[32m+[m[32m            <input[m
[32m+[m[32m              type="date"[m
[32m+[m[32m              id="filter-date-input"[m
[32m+[m[32m              value={filterDate}[m
[32m+[m[32m              onChange={(e) => onDateChange(e.target.value)}[m
[32m+[m[32m              className="w-full pl-10 pr-3 py-2 text-sm bg-slate-50 hover:bg-slate-100/80 focus:bg-white border border-slate-200 focus:border-blue-500 rounded-xl outline-none transition-all text-slate-800"[m
[32m+[m[32m              aria-label="Filter appointments by date"[m
[32m+[m[32m            />[m
[32m+[m[32m          </div>[m
[32m+[m
[32m+[m[32m          {/* Status Dropdown */}[m
[32m+[m[32m          <div className="relative min-w-[160px] flex-1 sm:flex-initial">[m
[32m+[m[32m            <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">[m
[32m+[m[32m              <Filter className="w-4 h-4" />[m
[32m+[m[32m            </div>[m
[32m+[m[32m            <select[m
[32m+[m[32m              id="filter-status-select"[m
[32m+[m[32m              value={filterStatus}[m
[32m+[m[32m              onChange={(e) => onStatusChange(e.target.value)}[m
[32m+[m[32m              className="w-full pl-10 pr-8 py-2 text-sm bg-slate-50 hover:bg-slate-100/80 focus:bg-white border border-slate-200 focus:border-blue-500 rounded-xl outline-none transition-all text-slate-800 cursor-pointer appearance-none"[m
[32m+[m[32m              aria-label="Filter appointments by status"[m
[32m+[m[32m            >[m
[32m+[m[32m              <option value="All">All Statuses</option>[m
[32m+[m[32m              <option value="Scheduled">Scheduled</option>[m
[32m+[m[32m              <option value="Completed">Completed</option>[m
[32m+[m[32m              <option value="Cancelled">Cancelled</option>[m
[32m+[m[32m            </select>[m
[32m+[m[32m            <div className="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none text-slate-400 text-xs">[m
[32m+[m[32m              ▼[m
[32m+[m[32m            </div>[m
[32m+[m[32m          </div>[m
[32m+[m
[32m+[m[32m          {/* Clear Filters Button */}[m
[32m+[m[32m          {hasActiveFilters && ([m
[32m+[m[32m            <button[m
[32m+[m[32m              type="button"[m
[32m+[m[32m              id="clear-filters-button"[m
[32m+[m[32m              onClick={onClearFilters}[m
[32m+[m[32m              className="inline-flex items-center gap-1.5 px-3 py-2 text-sm font-medium text-slate-600 hover:text-slate-900 bg-slate-100 hover:bg-slate-200 rounded-xl transition-all cursor-pointer"[m
[32m+[m[32m            >[m
[32m+[m[32m              <RotateCcw className="w-3.5 h-3.5" />[m
[32m+[m[32m              Clear Filters[m
[32m+[m[32m            </button>[m
[32m+[m[32m          )}[m
[32m+[m[32m        </div>[m
[32m+[m
[32m+[m[32m        {/* Right Side: Appointment Counter */}[m
[32m+[m[32m        <div className="flex items-center gap-2 text-xs font-semibold text-slate-500">[m
[32m+[m[32m          <span>Showing</span>[m
[32m+[m[32m          <span className="px-2 py-0.5 rounded-md bg-blue-50 text-blue-700 border border-blue-200 font-mono text-xs">[m
[32m+[m[32m            {totalCount}[m
[32m+[m[32m          </span>[m
[32m+[m[32m          <span>{totalCount === 1 ? 'appointment' : 'appointments'}</span>[m
[32m+[m[32m          {hasActiveFilters && ([m
[32m+[m[32m            <span className="inline-flex items-center gap-1 text-blue-600 bg-blue-50/50 px-2 py-0.5 rounded text-[11px] font-medium border border-blue-100">[m
[32m+[m[32m              Filtered[m
[32m+[m[32m            </span>[m
[32m+[m[32m          )}[m
[32m+[m[32m        </div>[m
[32m+[m[32m      </div>[m
[32m+[m[32m    </div>[m
[32m+[m[32m  );[m
[32m+[m[32m};[m
[32m+[m
[32m+[m[32mexport default AppointmentFilters;[m
[1mdiff --git a/frontend/src/components/AppointmentForm.jsx b/frontend/src/components/AppointmentForm.jsx[m
[1mnew file mode 100644[m
[1mindex 0000000..4a1218c[m
[1m--- /dev/null[m
[1m+++ b/frontend/src/components/AppointmentForm.jsx[m
[36m@@ -0,0 +1,281 @@[m
[32m+[m[32mimport React, { useState, useEffect } from 'react';[m
[32m+[m[32mimport { Clock, Calendar, Type, AlignLeft, AlertCircle } from 'lucide-react';[m
[32m+[m
[32m+[m[32mexport const AppointmentForm = ({[m
[32m+[m[32m  initialData = null,[m
[32m+[m[32m  onSubmit,[m
[32m+[m[32m  onCancel,[m
[32m+[m[32m  isSubmitting = false,[m
[32m+[m[32m  serverError = null,[m
[32m+[m[32m}) => {[m
[32m+[m[32m  const [formData, setFormData] = useState({[m
[32m+[m[32m    title: '',[m
[32m+[m[32m    description: '',[m
[32m+[m[32m    date: '',[m
[32m+[m[32m    start_time: '',[m
[32m+[m[32m    end_time: '',[m
[32m+[m[32m  });[m
[32m+[m
[32m+[m[32m  const [fieldErrors, setFieldErrors] = useState({});[m
[32m+[m
[32m+[m[32m  useEffect(() => {[m
[32m+[m[32m    if (initialData) {[m
[32m+[m[32m      // Normalize times if they include seconds (e.g. 09:00:00 -> 09:00)[m
[32m+[m[32m      const formatTimeInput = (t) => (t && t.length >= 5 ? t.substring(0, 5) : t || '');[m
[32m+[m[32m      setFormData({[m
[32m+[m[32m        title: initialData.title || '',[m
[32m+[m[32m        description: initialData.description || '',[m
[32m+[m[32m        date: initialData.date ? String(initialData.date) : '',[m
[32m+[m[32m        start_time: formatTimeInput(initialData.start_time),[m
[32m+[m[32m        end_time: formatTimeInput(initialData.end_time),[m
[32m+[m[32m      });[m
[32m+[m[32m    } else {[m
[32m+[m[32m      // Defaults for a new appointment: today's date[m
[32m+[m[32m      const today = new Date().toISOString().split('T')[0];[m
[32m+[m[32m      setFormData({[m
[32m+[m[32m        title: '',[m
[32m+[m[32m        description: '',[m
[32m+[m[32m        date: today,[m
[32m+[m[32m        start_time: '10:00',[m
[32m+[m[32m        end_time: '11:00',[m
[32m+[m[32m      });[m
[32m+[m[32m    }[m
[32m+[m[32m    setFieldErrors({});[m
[32m+[m[32m  }, [initialData]);[m
[32m+[m
[32m+[m[32m  const handleChange = (e) => {[m
[32m+[m[32m    const { name, value } = e.target;[m
[32m+[m[32m    setFormData((prev) => ({ ...prev, [name]: value }));[m
[32m+[m
[32m+[m[32m    // Clear individual field error on change[m
[32m+[m[32m    if (fieldErrors[name]) {[m
[32m+[m[32m      setFieldErrors((prev) => ({ ...prev, [name]: null }));[m
[32m+[m[32m    }[m
[32m+[m[32m  };[m
[32m+[m
[32m+[m[32m  const validate = () => {[m
[32m+[m[32m    const errors = {};[m
[32m+[m
[32m+[m[32m    if (!formData.title.trim()) {[m
[32m+[m[32m      errors.title = 'Title is required.';[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    if (!formData.date) {[m
[32m+[m[32m      errors.date = 'Date is required.';[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    if (!formData.start_time) {[m
[32m+[m[32m      errors.start_time = 'Start time is required.';[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    if (!formData.end_time) {[m
[32m+[m[32m      errors.end_time = 'End time is required.';[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    if (formData.start_time && formData.end_time) {[m
[32m+[m[32m      if (formData.end_time <= formData.start_time) {[m
[32m+[m[32m        errors.end_time = 'End time must be after start time.';[m
[32m+[m[32m      }[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    setFieldErrors(errors);[m
[32m+[m[32m    return Object.keys(errors).length === 0;[m
[32m+[m[32m  };[m
[32m+[m
[32m+[m[32m  const handleSubmit = (e) => {[m
[32m+[m[32m    e.preventDefault();[m
[32m+[m[32m    if (!validate()) return;[m
[32m+[m
[32m+[m[32m    // Ensure seconds format (HH:MM:SS) for MySQL Time field[m
[32m+[m[32m    const normalizeTimeToSeconds = (t) => (t.length === 5 ? `${t}:00` : t);[m
[32m+[m
[32m+[m[32m    onSubmit({[m
[32m+[m[32m      title: formData.title.trim(),[m
[32m+[m[32m      description: formData.description.trim() || null,[m
[32m+[m[32m      date: formData.date,[m
[32m+[m[32m      start_time: normalizeTimeToSeconds(formData.start_time),[m
[32m+[m[32m      end_time: normalizeTimeToSeconds(formData.end_time),[m
[32m+[m[32m    });[m
[32m+[m[32m  };[m
[32m+[m
[32m+[m[32m  const isEdit = Boolean(initialData && initialData.id);[m
[32m+[m
[32m+[m[32m  return ([m
[32m+[m[32m    <form onSubmit={handleSubmit} className="space-y-4" noValidate id="appointment-form">[m
[32m+[m[32m      {/* Server Error Banner (e.g. 409 Conflict) */}[m
[32m+[m[32m      {serverError && ([m
[32m+[m[32m        <div[m
[32m+[m[32m          id="form-server-error"[m
[32m+[m[32m          className="p-3.5 bg-rose-50 border border-rose-200 rounded-xl flex items-start gap-2.5 text-rose-800 text-sm animate-shake"[m
[32m+[m[32m        >[m
[32m+[m[32m          <AlertCircle className="w-4 h-4 text-rose-600 mt-0.5 shrink-0" />[m
[32m+[m[32m          <div className="font-medium">{serverError}</div>[m
[32m+[m[32m        </div>[m
[32m+[m[32m      )}[m
[32m+[m
[32m+[m[32m      {/* Title Field */}[m
[32m+[m[32m      <div>[m
[32m+[m[32m        <label htmlFor="form-title" className="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1.5">[m
[32m+[m[32m          Title <span className="text-rose-500">*</span>[m
[32m+[m[32m        </label>[m
[32m+[m[32m        <div className="relative">[m
[32m+[m[32m          <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">[m
[32m+[m[32m            <Type className="w-4 h-4" />[m
[32m+[m[32m          </div>[m
[32m+[m[32m          <input[m
[32m+[m[32m            type="text"[m
[32m+[m[32m            id="form-title"[m
[32m+[m[32m            name="title"[m
[32m+[m[32m            value={formData.title}[m
[32m+[m[32m            onChange={handleChange}[m
[32m+[m[32m            placeholder="e.g., Sprint Planning, Client Review"[m
[32m+[m[32m            className={`w-full pl-10 pr-3 py-2 text-sm bg-slate-50 focus:bg-white border rounded-xl outline-none transition-all ${[m
[32m+[m[32m              fieldErrors.title ? 'border-rose-400 bg-rose-50/20 focus:border-rose-500' : 'border-slate-200 focus:border-blue-500'[m
[32m+[m[32m            }`}[m
[32m+[m[32m            autoFocus[m
[32m+[m[32m          />[m
[32m+[m[32m        </div>[m
[32m+[m[32m        {fieldErrors.title && ([m
[32m+[m[32m          <p className="mt-1 text-xs text-rose-600 font-medium" id="error-title">[m
[32m+[m[32m            {fieldErrors.title}[m
[32m+[m[32m          </p>[m
[32m+[m[32m        )}[m
[32m+[m[32m      </div>[m
[32m+[m
[32m+[m[32m      {/* Description Field (Optional) */}[m
[32m+[m[32m      <div>[m
[32m+[m[32m        <label htmlFor="form-description" className="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1.5">[m
[32m+[m[32m          Description <span className="text-slate-400 font-normal normal-case">(Optional)</span>[m
[32m+[m[32m        </label>[m
[32m+[m[32m        <div className="relative">[m
[32m+[m[32m          <div className="absolute top-2.5 left-3.5 pointer-events-none text-slate-400">[m
[32m+[m[32m            <AlignLeft className="w-4 h-4" />[m
[32m+[m[32m          </div>[m
[32m+[m[32m          <textarea[m
[32m+[m[32m            id="form-description"[m
[32m+[m[32m            name="description"[m
[32m+[m[32m            rows="3"[m
[32m+[m[32m            value={formData.description}[m
[32m+[m[32m            onChange={handleChange}[m
[32m+[m[32m            placeholder="Add relevant notes, agenda, or video call links..."[m
[32m+[m[32m            className="w-full pl-10 pr-3 py-2 text-sm bg-slate-50 focus:bg-white border border-slate-200 focus:border-blue-500 rounded-xl outline-none transition-all resize-none"[m
[32m+[m[32m          />[m
[32m+[m[32m        </div>[m
[32m+[m[32m      </div>[m
[32m+[m
[32m+[m[32m      {/* Date Field */}[m
[32m+[m[32m      <div>[m
[32m+[m[32m        <label htmlFor="form-date" className="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1.5">[m
[32m+[m[32m          Date <span className="text-rose-500">*</span>[m
[32m+[m[32m        </label>[m
[32m+[m[32m        <div className="relative">[m
[32m+[m[32m          <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">[m
[32m+[m[32m            <Calendar className="w-4 h-4" />[m
[32m+[m[32m          </div>[m
[32m+[m[32m          <input[m
[32m+[m[32m            type="date"[m
[32m+[m[32m            id="form-date"[m
[32m+[m[32m            name="date"[m
[32m+[m[32m            value={formData.date}[m
[32m+[m[32m            onChange={handleChange}[m
[32m+[m[32m            className={`w-full pl-10 pr-3 py-2 text-sm bg-slate-50 focus:bg-white border rounded-xl outline-none transition-all ${[m
[32m+[m[32m              fieldErrors.date ? 'border-rose-400 bg-rose-50/20 focus:border-rose-500' : 'border-slate-200 focus:border-blue-500'[m
[32m+[m[32m            }`}[m
[32m+[m[32m          />[m
[32m+[m[32m        </div>[m
[32m+[m[32m        {fieldErrors.date && ([m
[32m+[m[32m          <p className="mt-1 text-xs text-rose-600 font-medium" id="error-date">[m
[32m+[m[32m            {fieldErrors.date}[m
[32m+[m[32m          </p>[m
[32m+[m[32m        )}[m
[32m+[m[32m      </div>[m
[32m+[m
[32m+[m[32m      {/* Time Slots Grid */}[m
[32m+[m[32m      <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">[m
[32m+[m[32m        {/* Start Time */}[m
[32m+[m[32m        <div>[m
[32m+[m[32m          <label htmlFor="form-start-time" className="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1.5">[m
[32m+[m[32m            Start Time <span className="text-rose-500">*</span>[m
[32m+[m[32m          </label>[m
[32m+[m[32m          <div className="relative">[m
[32m+[m[32m            <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">[m
[32m+[m[32m              <Clock className="w-4 h-4" />[m
[32m+[m[32m            </div>[m
[32m+[m[32m            <input[m
[32m+[m[32m              type="time"[m
[32m+[m[32m              id="form-start-time"[m
[32m+[m[32m              name="start_time"[m
[32m+[m[32m              value={formData.start_time}[m
[32m+[m[32m              onChange={handleChange}[m
[32m+[m[32m              className={`w-full pl-10 pr-3 py-2 text-sm bg-slate-50 focus:bg-white border rounded-xl outline-none transition-all ${[m
[32m+[m[32m                fieldErrors.start_time ? 'border-rose-400 bg-rose-50/20 focus:border-rose-500' : 'border-slate-200 focus:border-blue-500'[m
[32m+[m[32m              }`}[m
[32m+[m[32m            />[m
[32m+[m[32m          </div>[m
[32m+[m[32m          {fieldErrors.start_time && ([m
[32m+[m[32m            <p className="mt-1 text-xs text-rose-600 font-medium" id="error-start-time">[m
[32m+[m[32m              {fieldErrors.start_time}[m
[32m+[m[32m            </p>[m
[32m+[m[32m          )}[m
[32m+[m[32m        </div>[m
[32m+[m
[32m+[m[32m        {/* End Time */}[m
[32m+[m[32m        <div>[m
[32m+[m[32m          <label htmlFor="form-end-time" className="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1.5">[m
[32m+[m[32m            End Time <span className="text-rose-500">*</span>[m
[32m+[m[32m          </label>[m
[32m+[m[32m          <div className="relative">[m
[32m+[m[32m            <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">[m
[32m+[m[32m              <Clock className="w-4 h-4" />[m
[32m+[m[32m            </div>[m
[32m+[m[32m            <input[m
[32m+[m[32m              type="time"[m
[32m+[m[32m              id="form-end-time"[m
[32m+[m[32m              name="end_time"[m
[32m+[m[32m              value={formData.end_time}[m
[32m+[m[32m              onChange={handleChange}[m
[32m+[m[32m              className={`w-full pl-10 pr-3 py-2 text-sm bg-slate-50 focus:bg-white border rounded-xl outline-none transition-all ${[m
[32m+[m[32m                fieldErrors.end_time ? 'border-rose-400 bg-rose-50/20 focus:border-rose-500' : 'border-slate-200 focus:border-blue-500'[m
[32m+[m[32m              }`}[m
[32m+[m[32m            />[m
[32m+[m[32m          </div>[m
[32m+[m[32m          {fieldErrors.end_time && ([m
[32m+[m[32m            <p className="mt-1 text-xs text-rose-600 font-medium" id="error-end-time">[m
[32m+[m[32m              {fieldErrors.end_time}[m
[32m+[m[32m            </p>[m
[32m+[m[32m          )}[m
[32m+[m[32m        </div>[m
[32m+[m[32m      </div>[m
[32m+[m
[32m+[m[32m      {/* Buttons */}[m
[32m+[m[32m      <div className="pt-4 flex items-center justify-end gap-3 border-t border-slate-100 mt-5">[m
[32m+[m[32m        <button[m
[32m+[m[32m          type="button"[m
[32m+[m[32m          id="modal-cancel-button"[m
[32m+[m[32m          onClick={onCancel}[m
[32m+[m[32m          disabled={isSubmitting}[m
[32m+[m[32m          className="px-4 py-2 text-sm font-medium text-slate-700 bg-slate-100 hover:bg-slate-200 rounded-xl transition-colors disabled:opacity-50"[m
[32m+[m[32m        >[m
[32m+[m[32m          Cancel[m
[32m+[m[32m        </button>[m
[32m+[m[32m        <button[m
[32m+[m[32m          type="submit"[m
[32m+[m[32m          id="modal-submit-button"[m
[32m+[m[32m          disabled={isSubmitting}[m
[32m+[m[32m          className="px-5 py-2 text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 rounded-xl transition-all shadow-md shadow-blue-500/20 disabled:opacity-50 flex items-center gap-2"[m
[32m+[m[32m        >[m
[32m+[m[32m          {isSubmitting ? ([m
[32m+[m[32m            <>[m
[32m+[m[32m              <span className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></span>[m
[32m+[m[32m              <span>{isEdit ? 'Updating...' : 'Creating...'}</span>[m
[32m+[m[32m            </>[m
[32m+[m[32m          ) : ([m
[32m+[m[32m            <span>{isEdit ? 'Update Appointment' : 'Create Appointment'}</span>[m
[32m+[m[32m          )}[m
[32m+[m[32m        </button>[m
[32m+[m[32m      </div>[m
[32m+[m[32m    </form>[m
[32m+[m[32m  );[m
[32m+[m[32m};[m
[32m+[m
[32m+[m[32mexport default AppointmentForm;[m
[1mdiff --git a/frontend/src/components/AppointmentModal.jsx b/frontend/src/components/AppointmentModal.jsx[m
[1mnew file mode 100644[m
[1mindex 0000000..4b73b25[m
[1m--- /dev/null[m
[1m+++ b/frontend/src/components/AppointmentModal.jsx[m
[36m@@ -0,0 +1,83 @@[m
[32m+[m[32mimport React, { useEffect } from 'react';[m
[32m+[m[32mimport { X, CalendarPlus, Edit3 } from 'lucide-react';[m
[32m+[m[32mimport AppointmentForm from './AppointmentForm';[m
[32m+[m
[32m+[m[32mexport const AppointmentModal = ({[m
[32m+[m[32m  isOpen,[m
[32m+[m[32m  onClose,[m
[32m+[m[32m  initialData = null,[m
[32m+[m[32m  onSubmit,[m
[32m+[m[32m  isSubmitting = false,[m
[32m+[m[32m  serverError = null,[m
[32m+[m[32m}) => {[m
[32m+[m[32m  useEffect(() => {[m
[32m+[m[32m    const handleKeyDown = (e) => {[m
[32m+[m[32m      if (e.key === 'Escape' && isOpen && !isSubmitting) {[m
[32m+[m[32m        onClose();[m
[32m+[m[32m      }[m
[32m+[m[32m    };[m
[32m+[m[32m    window.addEventListener('keydown', handleKeyDown);[m
[32m+[m[32m    return () => window.removeEventListener('keydown', handleKeyDown);[m
[32m+[m[32m  }, [isOpen, isSubmitting, onClose]);[m
[32m+[m
[32m+[m[32m  if (!isOpen) return null;[m
[32m+[m
[32m+[m[32m  const isEdit = Boolean(initialData && initialData.id);[m
[32m+[m
[32m+[m[32m  return ([m
[32m+[m[32m    <div[m
[32m+[m[32m      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/50 backdrop-blur-sm animate-fade-in"[m
[32m+[m[32m      id="appointment-modal-overlay"[m
[32m+[m[32m      onClick={(e) => {[m
[32m+[m[32m        if (e.target === e.currentTarget && !isSubmitting) onClose();[m
[32m+[m[32m      }}[m
[32m+[m[32m    >[m
[32m+[m[32m      <div[m
[32m+[m[32m        className="w-full max-w-lg bg-white rounded-2xl shadow-2xl border border-slate-200 overflow-hidden transform transition-all"[m
[32m+[m[32m        role="dialog"[m
[32m+[m[32m        aria-modal="true"[m
[32m+[m[32m        aria-labelledby="modal-title"[m
[32m+[m[32m      >[m
[32m+[m[32m        {/* Modal Header */}[m
[32m+[m[32m        <div className="flex items-center justify-between px-6 py-4 border-b border-slate-100 bg-slate-50/50">[m
[32m+[m[32m          <div className="flex items-center gap-3">[m
[32m+[m[32m            <div className={`p-2 rounded-xl ${isEdit ? 'bg-amber-100 text-amber-700' : 'bg-blue-100 text-blue-700'}`}>[m
[32m+[m[32m              {isEdit ? <Edit3 className="w-5 h-5" /> : <CalendarPlus className="w-5 h-5" />}[m
[32m+[m[32m            </div>[m
[32m+[m[32m            <div>[m
[32m+[m[32m              <h2 id="modal-title" className="text-base font-semibold text-slate-900">[m
[32m+[m[32m                {isEdit ? 'Edit Appointment' : 'Add New Appointment'}[m
[32m+[m[32m              </h2>[m
[32m+[m[32m              <p className="text-xs text-slate-500">[m
[32m+[m[32m                {isEdit ? 'Update appointment time and information' : 'Schedule a new slot for the team'}[m
[32m+[m[32m              </p>[m
[32m+[m[32m            </div>[m
[32m+[m[32m          </div>[m
[32m+[m[32m          <button[m
[32m+[m[32m            type="button"[m
[32m+[m[32m            id="modal-header-close-button"[m
[32m+[m[32m            onClick={onClose}[m
[32m+[m[32m            disabled={isSubmitting}[m
[32m+[m[32m            className="p-1.5 text-slate-400 hover:text-slate-600 rounded-lg hover:bg-slate-100 transition-colors disabled:opacity-50"[m
[32m+[m[32m            aria-label="Close modal"[m
[32m+[m[32m          >[m
[32m+[m[32m            <X className="w-5 h-5" />[m
[32m+[m[32m          </button>[m
[32m+[m[32m        </div>[m
[32m+[m
[32m+[m[32m        {/* Modal Body */}[m
[32m+[m[32m        <div className="p-6">[m
[32m+[m[32m          <AppointmentForm[m
[32m+[m[32m            initialData={initialData}[m
[32m+[m[32m            onSubmit={onSubmit}[m
[32m+[m[32m            onCancel={onClose}[m
[32m+[m[32m            isSubmitting={isSubmitting}[m
[32m+[m[32m            serverError={serverError}[m
[32m+[m[32m          />[m
[32m+[m[32m        </div>[m
[32m+[m[32m      </div>[m
[32m+[m[32m    </div>[m
[32m+[m[32m  );[m
[32m+[m[32m};[m
[32m+[m
[32m+[m[32mexport default AppointmentModal;[m
[1mdiff --git a/frontend/src/components/ConfirmModal.jsx b/frontend/src/components/ConfirmModal.jsx[m
[1mnew file mode 100644[m
[1mindex 0000000..c330c37[m
[1m--- /dev/null[m
[1m+++ b/frontend/src/components/ConfirmModal.jsx[m
[36m@@ -0,0 +1,79 @@[m
[32m+[m[32mimport React, { useEffect } from 'react';[m
[32m+[m[32mimport { AlertTriangle, X } from 'lucide-react';[m
[32m+[m
[32m+[m[32mexport const ConfirmModal = ({ isOpen, title, message, onConfirm, onCancel, confirmText = 'Confirm', isSubmitting = false }) => {[m
[32m+[m[32m  useEffect(() => {[m
[32m+[m[32m    const handleKeyDown = (e) => {[m
[32m+[m[32m      if (e.key === 'Escape' && isOpen && !isSubmitting) {[m
[32m+[m[32m        onCancel();[m
[32m+[m[32m      }[m
[32m+[m[32m    };[m
[32m+[m[32m    window.addEventListener('keydown', handleKeyDown);[m
[32m+[m[32m    return () => window.removeEventListener('keydown', handleKeyDown);[m
[32m+[m[32m  }, [isOpen, isSubmitting, onCancel]);[m
[32m+[m
[32m+[m[32m  if (!isOpen) return null;[m
[32m+[m
[32m+[m[32m  return ([m
[32m+[m[32m    <div[m
[32m+[m[32m      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/50 backdrop-blur-sm animate-fade-in"[m
[32m+[m[32m      id="confirm-modal-overlay"[m
[32m+[m[32m      onClick={(e) => {[m
[32m+[m[32m        if (e.target === e.currentTarget && !isSubmitting) onCancel();[m
[32m+[m[32m      }}[m
[32m+[m[32m    >[m
[32m+[m[32m      <div[m
[32m+[m[32m        className="w-full max-w-md bg-white rounded-2xl shadow-2xl border border-slate-200 overflow-hidden transform transition-all"[m
[32m+[m[32m        role="dialog"[m
[32m+[m[32m        aria-modal="true"[m
[32m+[m[32m        aria-labelledby="confirm-modal-title"[m
[32m+[m[32m      >[m
[32m+[m[32m        <div className="p-6">[m
[32m+[m[32m          <div className="flex items-start gap-4">[m
[32m+[m[32m            <div className="p-3 bg-amber-100 rounded-xl text-amber-600 shrink-0">[m
[32m+[m[32m              <AlertTriangle className="w-6 h-6" />[m
[32m+[m[32m            </div>[m
[32m+[m[32m            <div className="flex-1">[m
[32m+[m[32m              <h3 id="confirm-modal-title" className="text-lg font-semibold text-slate-900">[m
[32m+[m[32m                {title}[m
[32m+[m[32m              </h3>[m
[32m+[m[32m              <p className="mt-2 text-sm text-slate-600 leading-relaxed">[m
[32m+[m[32m                {message}[m
[32m+[m[32m              </p>[m
[32m+[m[32m            </div>[m
[32m+[m[32m          </div>[m
[32m+[m
[32m+[m[32m          <div className="mt-6 flex items-center justify-end gap-3">[m
[32m+[m[32m            <button[m
[32m+[m[32m              type="button"[m
[32m+[m[32m              id="confirm-cancel-button"[m
[32m+[m[32m              onClick={onCancel}[m
[32m+[m[32m              disabled={isSubmitting}[m
[32m+[m[32m              className="px-4 py-2 text-sm font-medium text-slate-700 bg-slate-100 hover:bg-slate-200 rounded-xl transition-colors disabled:opacity-50"[m
[32m+[m[32m            >[m
[32m+[m[32m              Keep Appointment[m
[32m+[m[32m            </button>[m
[32m+[m[32m            <button[m
[32m+[m[32m              type="button"[m
[32m+[m[32m              id="confirm-action-button"[m
[32m+[m[32m              onClick={onConfirm}[m
[32m+[m[32m              disabled={isSubmitting}[m
[32m+[m[32m              className="px-4 py-2 text-sm font-medium text-white bg-rose-600 hover:bg-rose-700 rounded-xl transition-colors shadow-sm disabled:opacity-50 flex items-center gap-2"[m
[32m+[m[32m            >[m
[32m+[m[32m              {isSubmitting ? ([m
[32m+[m[32m                <>[m
[32m+[m[32m                  <span className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></span>[m
[32m+[m[32m                  Processing...[m
[32m+[m[32m                </>[m
[32m+[m[32m              ) : ([m
[32m+[m[32m                confirmText[m
[32m+[m[32m              )}[m
[32m+[m[32m            </button>[m
[32m+[m[32m          </div>[m
[32m+[m[32m        </div>[m
[32m+[m[32m      </div>[m
[32m+[m[32m    </div>[m
[32m+[m[32m  );[m
[32m+[m[32m};[m
[32m+[m
[32m+[m[32mexport default ConfirmModal;[m
[1mdiff --git a/frontend/src/components/StatusBadge.jsx b/frontend/src/components/StatusBadge.jsx[m
[1mnew file mode 100644[m
[1mindex 0000000..143cd3a[m
[1m--- /dev/null[m
[1m+++ b/frontend/src/components/StatusBadge.jsx[m
[36m@@ -0,0 +1,36 @@[m
[32m+[m[32mimport React from 'react';[m
[32m+[m[32mimport { CalendarClock, CheckCircle2, XCircle } from 'lucide-react';[m
[32m+[m
[32m+[m[32mexport const StatusBadge = ({ status }) => {[m
[32m+[m[32m  switch (status) {[m
[32m+[m[32m    case 'Scheduled':[m
[32m+[m[32m      return ([m
[32m+[m[32m        <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-semibold bg-blue-50 text-blue-700 border border-blue-200">[m
[32m+[m[32m          <CalendarClock className="w-3.5 h-3.5 text-blue-600" />[m
[32m+[m[32m          Scheduled[m
[32m+[m[32m        </span>[m
[32m+[m[32m      );[m
[32m+[m[32m    case 'Completed':[m
[32m+[m[32m      return ([m
[32m+[m[32m        <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-semibold bg-emerald-50 text-emerald-700 border border-emerald-200">[m
[32m+[m[32m          <CheckCircle2 className="w-3.5 h-3.5 text-emerald-600" />[m
[32m+[m[32m          Completed[m
[32m+[m[32m        </span>[m
[32m+[m[32m      );[m
[32m+[m[32m    case 'Cancelled':[m
[32m+[m[32m      return ([m
[32m+[m[32m        <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-semibold bg-rose-50 text-rose-700 border border-rose-200 line-through decoration-rose-400">[m
[32m+[m[32m          <XCircle className="w-3.5 h-3.5 text-rose-500" />[m
[32m+[m[32m          Cancelled[m
[32m+[m[32m        </span>[m
[32m+[m[32m      );[m
[32m+[m[32m    default:[m
[32m+[m[32m      return ([m
[32m+[m[32m        <span className="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold bg-slate-100 text-slate-700 border border-slate-200">[m
[32m+[m[32m          {status}[m
[32m+[m[32m        </span>[m
[32m+[m[32m      );[m
[32m+[m[32m  }[m
[32m+[m[32m};[m
[32m+[m
[32m+[m[32mexport default StatusBadge;[m
[1mdiff --git a/frontend/src/components/Toast.jsx b/frontend/src/components/Toast.jsx[m
[1mnew file mode 100644[m
[1mindex 0000000..ca87c36[m
[1m--- /dev/null[m
[1m+++ b/frontend/src/components/Toast.jsx[m
[36m@@ -0,0 +1,52 @@[m
[32m+[m[32mimport React, { useEffect } from 'react';[m
[32m+[m[32mimport { CheckCircle2, AlertCircle, X, Info } from 'lucide-react';[m
[32m+[m
[32m+[m[32mexport const Toast = ({ message, type = 'success', onClose, duration = 4000 }) => {[m
[32m+[m[32m  useEffect(() => {[m
[32m+[m[32m    if (!message) return;[m
[32m+[m[32m    const timer = setTimeout(() => {[m
[32m+[m[32m      onClose();[m
[32m+[m[32m    }, duration);[m
[32m+[m[32m    return () => clearTimeout(timer);[m
[32m+[m[32m  }, [message, duration, onClose]);[m
[32m+[m
[32m+[m[32m  if (!message) return null;[m
[32m+[m
[32m+[m[32m  const isSuccess = type === 'success';[m
[32m+[m[32m  const isError = type === 'error';[m
[32m+[m
[32m+[m[32m  return ([m
[32m+[m[32m    <div[m
[32m+[m[32m      role="alert"[m
[32m+[m[32m      id="app-toast"[m
[32m+[m[32m      className={`fixed top-5 right-5 z-50 flex items-start gap-3 p-4 rounded-xl shadow-xl border backdrop-blur-md max-w-md w-full transition-all duration-300 transform translate-y-0 ${[m
[32m+[m[32m        isSuccess[m
[32m+[m[32m          ? 'bg-emerald-50/95 border-emerald-300 text-emerald-900'[m
[32m+[m[32m          : isError[m
[32m+[m[32m          ? 'bg-rose-50/95 border-rose-300 text-rose-900'[m
[32m+[m[32m          : 'bg-slate-50/95 border-slate-300 text-slate-900'[m
[32m+[m[32m      }`}[m
[32m+[m[32m    >[m
[32m+[m[32m      <div className="shrink-0 mt-0.5">[m
[32m+[m[32m        {isSuccess && <CheckCircle2 className="w-5 h-5 text-emerald-600" />}[m
[32m+[m[32m        {isError && <AlertCircle className="w-5 h-5 text-rose-600" />}[m
[32m+[m[32m        {!isSuccess && !isError && <Info className="w-5 h-5 text-slate-600" />}[m
[32m+[m[32m      </div>[m
[32m+[m
[32m+[m[32m      <div className="flex-1 text-sm font-medium leading-5">[m
[32m+[m[32m        {message}[m
[32m+[m[32m      </div>[m
[32m+[m
[32m+[m[32m      <button[m
[32m+[m[32m        onClick={onClose}[m
[32m+[m[32m        id="toast-close-button"[m
[32m+[m[32m        className="shrink-0 p-1 text-slate-400 hover:text-slate-600 rounded-lg hover:bg-black/5 transition-colors"[m
[32m+[m[32m        aria-label="Close notification"[m
[32m+[m[32m      >[m
[32m+[m[32m        <X className="w-4 h-4" />[m
[32m+[m[32m      </button>[m
[32m+[m[32m    </div>[m
[32m+[m[32m  );[m
[32m+[m[32m};[m
[32m+[m
[32m+[m[32mexport default Toast;[m
[1mdiff --git a/frontend/src/index.css b/frontend/src/index.css[m
[1mnew file mode 100644[m
[1mindex 0000000..0d95790[m
[1m--- /dev/null[m
[1m+++ b/frontend/src/index.css[m
[36m@@ -0,0 +1,30 @@[m
[32m+[m[32m@import "tailwindcss";[m
[32m+[m
[32m+[m[32m@layer base {[m
[32m+[m[32m  body {[m
[32m+[m[32m    @apply bg-slate-50 text-slate-900 antialiased min-h-screen font-sans;[m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m/* Custom scrollbar */[m
[32m+[m[32m::-webkit-scrollbar {[m
[32m+[m[32m  width: 6px;[m
[32m+[m[32m  height: 6px;[m
[32m+[m[32m}[m
[32m+[m[32m::-webkit-scrollbar-track {[m
[32m+[m[32m  background: transparent;[m
[32m+[m[32m}[m
[32m+[m[32m::-webkit-scrollbar-thumb {[m
[32m+[m[32m  background: #cbd5e1;[m
[32m+[m[32m  border-radius: 4px;[m
[32m+[m[32m}[m
[32m+[m[32m::-webkit-scrollbar-thumb:hover {[m
[32m+[m[32m  background: #94a3b8;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m/* Glassmorphism utility */[m
[32m+[m[32m.glass-panel {[m
[32m+[m[32m  background: rgba(255, 255, 255, 0.85);[m
[32m+[m[32m  backdrop-filter: blur(12px);[m
[32m+[m[32m  -webkit-backdrop-filter: blur(12px);[m
[32m+[m[32m}[m
[1mdiff --git a/frontend/src/main.jsx b/frontend/src/main.jsx[m
[1mnew file mode 100644[m
[1mindex 0000000..b9a1a6d[m
[1m--- /dev/null[m
[1m+++ b/frontend/src/main.jsx[m
[36m@@ -0,0 +1,10 @@[m
[32m+[m[32mimport { StrictMode } from 'react'[m
[32m+[m[32mimport { createRoot } from 'react-dom/client'[m
[32m+[m[32mimport './index.css'[m
[32m+[m[32mimport App from './App.jsx'[m
[32m+[m
[32m+[m[32mcreateRoot(document.getElementById('root')).render([m
[32m+[m[32m  <StrictMode>[m
[32m+[m[32m    <App />[m
[32m+[m[32m  </StrictMode>,[m
[32m+[m[32m)[m
[1mdiff --git a/frontend/src/pages/AppointmentBoard.jsx b/frontend/src/pages/AppointmentBoard.jsx[m
[1mnew file mode 100644[m
[1mindex 0000000..71ffcb8[m
[1m--- /dev/null[m
[1m+++ b/frontend/src/pages/AppointmentBoard.jsx[m
[36m@@ -0,0 +1,345 @@[m
[32m+[m[32mimport React, { useState, useEffect, useCallback } from 'react';[m
[32m+[m[32mimport { Plus, Calendar, Clock, RefreshCw, AlertTriangle } from 'lucide-react';[m
[32m+[m[32mimport appointmentApi, { extractErrorMessage } from '../services/appointmentApi';[m
[32m+[m[32mimport AppointmentCard from '../components/AppointmentCard';[m
[32m+[m[32mimport AppointmentModal from '../components/AppointmentModal';[m
[32m+[m[32mimport AppointmentFilters from '../components/AppointmentFilters';[m
[32m+[m[32mimport ConfirmModal from '../components/ConfirmModal';[m
[32m+[m[32mimport Toast from '../components/Toast';[m
[32m+[m
[32m+[m[32mexport const AppointmentBoard = () => {[m
[32m+[m[32m  // Appointments state[m
[32m+[m[32m  const [appointments, setAppointments] = useState([]);[m
[32m+[m[32m  const [isLoading, setIsLoading] = useState(true);[m
[32m+[m[32m  const [error, setError] = useState(null);[m
[32m+[m
[32m+[m[32m  // Filters state[m
[32m+[m[32m  const [filterDate, setFilterDate] = useState('');[m
[32m+[m[32m  const [filterStatus, setFilterStatus] = useState('All');[m
[32m+[m
[32m+[m[32m  // Modal states[m
[32m+[m[32m  const [isModalOpen, setIsModalOpen] = useState(false);[m
[32m+[m[32m  const [editingAppointment, setEditingAppointment] = useState(null);[m
[32m+[m[32m  const [isSubmitting, setIsSubmitting] = useState(false);[m
[32m+[m[32m  const [formServerError, setFormServerError] = useState(null);[m
[32m+[m
[32m+[m[32m  // Cancellation confirm modal state[m
[32m+[m[32m  const [cancelModalAppointment, setCancelModalAppointment] = useState(null);[m
[32m+[m[32m  const [isCancelling, setIsCancelling] = useState(false);[m
[32m+[m
[32m+[m[32m  // Toast notification state[m
[32m+[m[32m  const [toast, setToast] = useState({ message: '', type: 'success' });[m
[32m+[m
[32m+[m[32m  const showToast = (message, type = 'success') => {[m
[32m+[m[32m    setToast({ message, type });[m
[32m+[m[32m  };[m
[32m+[m
[32m+[m[32m  const closeToast = () => {[m
[32m+[m[32m    setToast({ message: '', type: 'success' });[m
[32m+[m[32m  };[m
[32m+[m
[32m+[m[32m  // Fetch appointments from backend with active query params[m
[32m+[m[32m  const loadAppointments = useCallback(async () => {[m
[32m+[m[32m    setIsLoading(true);[m
[32m+[m[32m    setError(null);[m
[32m+[m[32m    try {[m
[32m+[m[32m      const data = await appointmentApi.getAll({[m
[32m+[m[32m        date: filterDate || undefined,[m
[32m+[m[32m        status: filterStatus !== 'All' ? filterStatus : undefined,[m
[32m+[m[32m      });[m
[32m+[m[32m      setAppointments(data);[m
[32m+[m[32m    } catch (err) {[m
[32m+[m[32m      const msg = extractErrorMessage(err);[m
[32m+[m[32m      setError(msg);[m
[32m+[m[32m      showToast(msg, 'error');[m
[32m+[m[32m    } finally {[m
[32m+[m[32m      setIsLoading(false);[m
[32m+[m[32m    }[m
[32m+[m[32m  }, [filterDate, filterStatus]);[m
[32m+[m
[32m+[m[32m  useEffect(() => {[m
[32m+[m[32m    loadAppointments();[m
[32m+[m[32m  }, [loadAppointments]);[m
[32m+[m
[32m+[m[32m  // Handlers for Add / Edit Modal[m
[32m+[m[32m  const handleOpenAddModal = () => {[m
[32m+[m[32m    setEditingAppointment(null);[m
[32m+[m[32m    setFormServerError(null);[m
[32m+[m[32m    setIsModalOpen(true);[m
[32m+[m[32m  };[m
[32m+[m
[32m+[m[32m  const handleOpenEditModal = (appointment) => {[m
[32m+[m[32m    setEditingAppointment(appointment);[m
[32m+[m[32m    setFormServerError(null);[m
[32m+[m[32m    setIsModalOpen(true);[m
[32m+[m[32m  };[m
[32m+[m
[32m+[m[32m  const handleCloseModal = () => {[m
[32m+[m[32m    if (isSubmitting) return;[m
[32m+[m[32m    setIsModalOpen(false);[m
[32m+[m[32m    setEditingAppointment(null);[m
[32m+[m[32m    setFormServerError(null);[m
[32m+[m[32m  };[m
[32m+[m
[32m+[m[32m  const handleFormSubmit = async (formData) => {[m
[32m+[m[32m    setIsSubmitting(true);[m
[32m+[m[32m    setFormServerError(null);[m
[32m+[m
[32m+[m[32m    try {[m
[32m+[m[32m      if (editingAppointment && editingAppointment.id) {[m
[32m+[m[32m        await appointmentApi.update(editingAppointment.id, formData);[m
[32m+[m[32m        showToast('Appointment updated successfully.', 'success');[m
[32m+[m[32m      } else {[m
[32m+[m[32m        await appointmentApi.create(formData);[m
[32m+[m[32m        showToast('Appointment created successfully.', 'success');[m
[32m+[m[32m      }[m
[32m+[m[32m      setIsModalOpen(false);[m
[32m+[m[32m      setEditingAppointment(null);[m
[32m+[m[32m      await loadAppointments();[m
[32m+[m[32m    } catch (err) {[m
[32m+[m[32m      const msg = extractErrorMessage(err);[m
[32m+[m[32m      setFormServerError(msg);[m
[32m+[m[32m      showToast(msg, 'error');[m
[32m+[m[32m    } finally {[m
[32m+[m[32m      setIsSubmitting(false);[m
[32m+[m[32m    }[m
[32m+[m[32m  };[m
[32m+[m
[32m+[m[32m  // Handler for Complete Appointment[m
[32m+[m[32m  const handleComplete = async (id) => {[m
[32m+[m[32m    try {[m
[32m+[m[32m      await appointmentApi.complete(id);[m
[32m+[m[32m      showToast('Appointment marked as completed.', 'success');[m
[32m+[m[32m      await loadAppointments();[m
[32m+[m[32m    } catch (err) {[m
[32m+[m[32m      const msg = extractErrorMessage(err);[m
[32m+[m[32m      showToast(msg, 'error');[m
[32m+[m[32m    }[m
[32m+[m[32m  };[m
[32m+[m
[32m+[m[32m  // Handlers for Cancel Appointment[m
[32m+[m[32m  const handlePromptCancel = (appointment) => {[m
[32m+[m[32m    setCancelModalAppointment(appointment);[m
[32m+[m[32m  };[m
[32m+[m
[32m+[m[32m  const handleCloseCancelModal = () => {[m
[32m+[m[32m    if (isCancelling) return;[m
[32m+[m[32m    setCancelModalAppointment(null);[m
[32m+[m[32m  };[m
[32m+[m
[32m+[m[32m  const handleConfirmCancel = async () => {[m
[32m+[m[32m    if (!cancelModalAppointment) return;[m
[32m+[m[32m    setIsCancelling(true);[m
[32m+[m[32m    try {[m
[32m+[m[32m      await appointmentApi.cancel(cancelModalAppointment.id);[m
[32m+[m[32m      showToast('Appointment cancelled successfully.', 'success');[m
[32m+[m[32m      setCancelModalAppointment(null);[m
[32m+[m[32m      await loadAppointments();[m
[32m+[m[32m    } catch (err) {[m
[32m+[m[32m      const msg = extractErrorMessage(err);[m
[32m+[m[32m      showToast(msg, 'error');[m
[32m+[m[32m    } finally {[m
[32m+[m[32m      setIsCancelling(false);[m
[32m+[m[32m    }[m
[32m+[m[32m  };[m
[32m+[m
[32m+[m[32m  // Clear filters[m
[32m+[m[32m  const handleClearFilters = () => {[m
[32m+[m[32m    setFilterDate('');[m
[32m+[m[32m    setFilterStatus('All');[m
[32m+[m[32m  };[m
[32m+[m
[32m+[m[32m  const hasActiveFilters = Boolean(filterDate || (filterStatus && filterStatus !== 'All'));[m
[32m+[m
[32m+[m[32m  return ([m
[32m+[m[32m    <div className="min-h-screen bg-gradient-to-b from-slate-50 via-slate-100/60 to-slate-200/50">[m
[32m+[m[32m      {/* Toast Notification Container */}[m
[32m+[m[32m      <Toast[m
[32m+[m[32m        message={toast.message}[m
[32m+[m[32m        type={toast.type}[m
[32m+[m[32m        onClose={closeToast}[m
[32m+[m[32m      />[m
[32m+[m
[32m+[m[32m      {/* Main Container */}[m
[32m+[m[32m      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 sm:py-10">[m
[32m+[m[32m        {/* Header Section */}[m
[32m+[m[32m        <header className="mb-8">[m
[32m+[m[32m          <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 pb-6 border-b border-slate-200/80">[m
[32m+[m[32m            <div>[m
[32m+[m[32m              <div className="flex items-center gap-2 mb-1">[m
[32m+[m[32m                <div className="p-2 bg-blue-600 text-white rounded-xl shadow-md shadow-blue-500/20">[m
[32m+[m[32m                  <Calendar className="w-5 h-5" />[m
[32m+[m[32m                </div>[m
[32m+[m[32m                <h1 className="text-2xl sm:text-3xl font-bold text-slate-900 tracking-tight" id="main-header-title">[m
[32m+[m[32m                  Appointment Board[m
[32m+[m[32m                </h1>[m
[32m+[m[32m              </div>[m
[32m+[m[32m              <p className="text-sm text-slate-600">[m
[32m+[m[32m                Manage your team's appointments efficiently[m
[32m+[m[32m              </p>[m
[32m+[m[32m            </div>[m
[32m+[m
[32m+[m[32m            <div className="flex items-center gap-3">[m
[32m+[m[32m              <button[m
[32m+[m[32m                type="button"[m
[32m+[m[32m                onClick={loadAppointments}[m
[32m+[m[32m                id="refresh-button"[m
[32m+[m[32m                className="p-2.5 text-slate-600 hover:text-slate-900 bg-white hover:bg-slate-50 border border-slate-200 rounded-xl transition-colors shadow-sm"[m
[32m+[m[32m                title="Refresh appointments"[m
[32m+[m[32m                aria-label="Refresh appointments"[m
[32m+[m[32m              >[m
[32m+[m[32m                <RefreshCw className={`w-4 h-4 ${isLoading ? 'animate-spin text-blue-600' : ''}`} />[m
[32m+[m[32m              </button>[m
[32m+[m
[32m+[m[32m              <button[m
[32m+[m[32m                type="button"[m
[32m+[m[32m                id="add-appointment-button"[m
[32m+[m[32m                onClick={handleOpenAddModal}[m
[32m+[m[32m                className="inline-flex items-center gap-2 px-4 py-2.5 bg-blue-600 hover:bg-blue-700 text-white text-sm font-semibold rounded-xl transition-all shadow-md shadow-blue-500/20 hover:shadow-lg hover:shadow-blue-500/30 cursor-pointer"[m
[32m+[m[32m              >[m
[32m+[m[32m                <Plus className="w-4 h-4" />[m
[32m+[m[32m                <span>Add Appointment</span>[m
[32m+[m[32m              </button>[m
[32m+[m[32m            </div>[m
[32m+[m[32m          </div>[m
[32m+[m[32m        </header>[m
[32m+[m
[32m+[m[32m        {/* Filters Bar */}[m
[32m+[m[32m        <AppointmentFilters[m
[32m+[m[32m          filterDate={filterDate}[m
[32m+[m[32m          filterStatus={filterStatus}[m
[32m+[m[32m          onDateChange={setFilterDate}[m
[32m+[m[32m          onStatusChange={setFilterStatus}[m
[32m+[m[32m          onClearFilters={handleClearFilters}[m
[32m+[m[32m          totalCount={appointments.length}[m
[32m+[m[32m        />[m
[32m+[m
[32m+[m[32m        {/* Content Area: Loading, Error, Empty, or Cards Grid */}[m
[32m+[m[32m        <main>[m
[32m+[m[32m          {isLoading ? ([m
[32m+[m[32m            /* Loading State / Skeleton Grid */[m
[32m+[m[32m            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5" id="loading-state">[m
[32m+[m[32m              {[1, 2, 3, 4, 5, 6].map((i) => ([m
[32m+[m[32m                <div[m
[32m+[m[32m                  key={i}[m
[32m+[m[32m                  className="bg-white border border-slate-200 rounded-2xl p-5 shadow-sm animate-pulse space-y-4"[m
[32m+[m[32m                >[m
[32m+[m[32m                  <div className="flex justify-between items-center">[m
[32m+[m[32m                    <div className="h-5 bg-slate-200 rounded w-2/3"></div>[m
[32m+[m[32m                    <div className="h-5 bg-slate-200 rounded-full w-20"></div>[m
[32m+[m[32m                  </div>[m
[32m+[m[32m                  <div className="space-y-2">[m
[32m+[m[32m                    <div className="h-3 bg-slate-100 rounded w-full"></div>[m
[32m+[m[32m                    <div className="h-3 bg-slate-100 rounded w-4/5"></div>[m
[32m+[m[32m                  </div>[m
[32m+[m[32m                  <div className="pt-3 border-t border-slate-100 space-y-2">[m
[32m+[m[32m                    <div className="h-3 bg-slate-200 rounded w-1/2"></div>[m
[32m+[m[32m                    <div className="h-3 bg-slate-200 rounded w-1/3"></div>[m
[32m+[m[32m                  </div>[m
[32m+[m[32m                </div>[m
[32m+[m[32m              ))}[m
[32m+[m[32m            </div>[m
[32m+[m[32m          ) : error ? ([m
[32m+[m[32m            /* Error State */[m
[32m+[m[32m            <div[m
[32m+[m[32m              id="error-state"[m
[32m+[m[32m              className="bg-rose-50 border border-rose-200 rounded-2xl p-8 text-center max-w-lg mx-auto shadow-sm"[m
[32m+[m[32m            >[m
[32m+[m[32m              <AlertTriangle className="w-10 h-10 text-rose-500 mx-auto mb-3" />[m
[32m+[m[32m              <h3 className="text-base font-semibold text-rose-900 mb-1">[m
[32m+[m[32m                Unable to load appointments[m
[32m+[m[32m              </h3>[m
[32m+[m[32m              <p className="text-sm text-rose-700 mb-4">{error}</p>[m
[32m+[m[32m              <button[m
[32m+[m[32m                type="button"[m
[32m+[m[32m                id="error-retry-button"[m
[32m+[m[32m                onClick={loadAppointments}[m
[32m+[m[32m                className="px-4 py-2 bg-rose-600 hover:bg-rose-700 text-white text-xs font-semibold rounded-xl transition-colors shadow-sm"[m
[32m+[m[32m              >[m
[32m+[m[32m                Retry Connection[m
[32m+[m[32m              </button>[m
[32m+[m[32m            </div>[m
[32m+[m[32m          ) : appointments.length === 0 ? ([m
[32m+[m[32m            /* Empty State */[m
[32m+[m[32m            <div[m
[32m+[m[32m              id="empty-state"[m
[32m+[m[32m              className="bg-white border border-slate-200 rounded-2xl p-12 text-center max-w-lg mx-auto shadow-sm"[m
[32m+[m[32m            >[m
[32m+[m[32m              <div className="w-12 h-12 bg-blue-50 text-blue-600 rounded-2xl flex items-center justify-center mx-auto mb-4 border border-blue-100">[m
[32m+[m[32m                <Clock className="w-6 h-6" />[m
[32m+[m[32m              </div>[m
[32m+[m[32m              <h3 className="text-base font-semibold text-slate-900 mb-1">[m
[32m+[m[32m                {hasActiveFilters ? 'No appointments match your filters.' : 'No appointments found.'}[m
[32m+[m[32m              </h3>[m
[32m+[m[32m              <p className="text-sm text-slate-500 mb-6">[m
[32m+[m[32m                {hasActiveFilters[m
[32m+[m[32m                  ? 'Try selecting a different date or status, or clear all filters.'[m
[32m+[m[32m                  : 'Get started by scheduling the first appointment for your team.'}[m
[32m+[m[32m              </p>[m
[32m+[m
[32m+[m[32m              {hasActiveFilters ? ([m
[32m+[m[32m                <button[m
[32m+[m[32m                  type="button"[m
[32m+[m[32m                  id="empty-clear-filters-button"[m
[32m+[m[32m                  onClick={handleClearFilters}[m
[32m+[m[32m                  className="px-4 py-2 text-sm font-medium text-slate-700 bg-slate-100 hover:bg-slate-200 rounded-xl transition-colors"[m
[32m+[m[32m                >[m
[32m+[m[32m                  Clear Filters[m
[32m+[m[32m                </button>[m
[32m+[m[32m              ) : ([m
[32m+[m[32m                <button[m
[32m+[m[32m                  type="button"[m
[32m+[m[32m                  id="empty-add-appointment-button"[m
[32m+[m[32m                  onClick={handleOpenAddModal}[m
[32m+[m[32m                  className="inline-flex items-center gap-2 px-4 py-2 text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 rounded-xl transition-colors shadow-sm"[m
[32m+[m[32m                >[m
[32m+[m[32m                  <Plus className="w-4 h-4" />[m
[32m+[m[32m                  Add Appointment[m
[32m+[m[32m                </button>[m
[32m+[m[32m              )}[m
[32m+[m[32m            </div>[m
[32m+[m[32m          ) : ([m
[32m+[m[32m            /* Appointments Grid */[m
[32m+[m[32m            <div[m
[32m+[m[32m              className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5"[m
[32m+[m[32m              id="appointments-grid"[m
[32m+[m[32m            >[m
[32m+[m[32m              {appointments.map((appointment) => ([m
[32m+[m[32m                <AppointmentCard[m
[32m+[m[32m                  key={appointment.id}[m
[32m+[m[32m                  appointment={appointment}[m
[32m+[m[32m                  onEdit={handleOpenEditModal}[m
[32m+[m[32m                  onComplete={handleComplete}[m
[32m+[m[32m                  onCancel={handlePromptCancel}[m
[32m+[m[32m                />[m
[32m+[m[32m              ))}[m
[32m+[m[32m            </div>[m
[32m+[m[32m          )}[m
[32m+[m[32m        </main>[m
[32m+[m[32m      </div>[m
[32m+[m
[32m+[m[32m      {/* Add / Edit Appointment Modal */}[m
[32m+[m[32m      <AppointmentModal[m
[32m+[m[32m        isOpen={isModalOpen}[m
[32m+[m[32m        onClose={handleCloseModal}[m
[32m+[m[32m        initialData={editingAppointment}[m
[32m+[m[32m        onSubmit={handleFormSubmit}[m
[32m+[m[32m        isSubmitting={isSubmitting}[m
[32m+[m[32m        serverError={formServerError}[m
[32m+[m[32m      />[m
[32m+[m
[32m+[m[32m      {/* Cancel Confirmation Dialog */}[m
[32m+[m[32m      <ConfirmModal[m
[32m+[m[32m        isOpen={Boolean(cancelModalAppointment)}[m
[32m+[m[32m        title="Cancel Appointment"[m
[32m+[m[32m        message={`Are you sure you want to cancel "${cancelModalAppointment?.title}"? The record will remain visible as Cancelled, and its time slot will become available for new bookings.`}[m
[32m+[m[32m        confirmText="Yes, Cancel Appointment"[m
[32m+[m[32m        onConfirm={handleConfirmCancel}[m
[32m+[m[32m        onCancel={handleCloseCancelModal}[m
[32m+[m[32m        isSubmitting={isCancelling}[m
[32m+[m[32m      />[m
[32m+[m[32m    </div>[m
[32m+[m[32m  );[m
[32m+[m[32m};[m
[32m+[m
[32m+[m[32mexport default AppointmentBoard;[m
[1mdiff --git a/frontend/src/services/appointmentApi.js b/frontend/src/services/appointmentApi.js[m
[1mnew file mode 100644[m
[1mindex 0000000..194810d[m
[1m--- /dev/null[m
[1m+++ b/frontend/src/services/appointmentApi.js[m
[36m@@ -0,0 +1,90 @@[m
[32m+[m[32mimport axios from 'axios';[m
[32m+[m
[32m+[m[32mconst API_BASE_URL = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000/api/appointments';[m
[32m+[m
[32m+[m[32mconst apiClient = axios.create({[m
[32m+[m[32m  baseURL: API_BASE_URL,[m
[32m+[m[32m  headers: {[m
[32m+[m[32m    'Content-Type': 'application/json',[m
[32m+[m[32m  },[m
[32m+[m[32m  timeout: 10000,[m
[32m+[m[32m});[m
[32m+[m
[32m+[m[32m/**[m
[32m+[m[32m * Standard error message extractor[m
[32m+[m[32m */[m
[32m+[m[32mexport const extractErrorMessage = (error) => {[m
[32m+[m[32m  if (error.response && error.response.data) {[m
[32m+[m[32m    if (typeof error.response.data.detail === 'string') {[m
[32m+[m[32m      return error.response.data.detail;[m
[32m+[m[32m    }[m
[32m+[m[32m    if (Array.isArray(error.response.data.detail)) {[m
[32m+[m[32m      return error.response.data.detail.map((d) => d.msg || JSON.stringify(d)).join(', ');[m
[32m+[m[32m    }[m
[32m+[m[32m  }[m
[32m+[m[32m  if (error.message) {[m
[32m+[m[32m    if (error.code === 'ECONNABORTED') return 'Request timed out. Please check your network or server.';[m
[32m+[m[32m    if (error.message === 'Network Error') return 'Cannot connect to backend server. Make sure FastAPI is running on port 8000.';[m
[32m+[m[32m    return error.message;[m
[32m+[m[32m  }[m
[32m+[m[32m  return 'An unexpected error occurred. Please try again.';[m
[32m+[m[32m};[m
[32m+[m
[32m+[m[32mexport const appointmentApi = {[m
[32m+[m[32m  /**[m
[32m+[m[32m   * Get all appointments with optional date and status filters[m
[32m+[m[32m   */[m
[32m+[m[32m  getAll: async (filters = {}) => {[m
[32m+[m[32m    const params = {};[m
[32m+[m[32m    if (filters.date) {[m
[32m+[m[32m      params.date = filters.date;[m
[32m+[m[32m    }[m
[32m+[m[32m    if (filters.status && filters.status !== 'All') {[m
[32m+[m[32m      params.status = filters.status;[m
[32m+[m[32m    }[m
[32m+[m[32m    const response = await apiClient.get('', { params });[m
[32m+[m[32m    return response.data;[m
[32m+[m[32m  },[m
[32m+[m
[32m+[m[32m  /**[m
[32m+[m[32m   * Get single appointment by ID[m
[32m+[m[32m   */[m
[32m+[m[32m  getById: async (id) => {[m
[32m+[m[32m    const response = await apiClient.get(`/${id}`);[m
[32m+[m[32m    return response.data;[m
[32m+[m[32m  },[m
[32m+[m
[32m+[m[32m  /**[m
[32m+[m[32m   * Create a new appointment[m
[32m+[m[32m   */[m
[32m+[m[32m  create: async (appointmentData) => {[m
[32m+[m[32m    const response = await apiClient.post('', appointmentData);[m
[32m+[m[32m    return response.data;[m
[32m+[m[32m  },[m
[32m+[m
[32m+[m[32m  /**[m
[32m+[m[32m   * Update an existing appointment[m
[32m+[m[32m   */[m
[32m+[m[32m  update: async (id, appointmentData) => {[m
[32m+[m[32m    const response = await apiClient.put(`/${id}`, appointmentData);[m
[32m+[m[32m    return response.data;[m
[32m+[m[32m  },[m
[32m+[m
[32m+[m[32m  /**[m
[32m+[m[32m   * Mark appointment as Completed[m
[32m+[m[32m   */[m
[32m+[m[32m  complete: async (id) => {[m
[32m+[m[32m    const response = await apiClient.patch(`/${id}/complete`);[m
[32m+[m[32m    return response.data;[m
[32m+[m[32m  },[m
[32m+[m
[32m+[m[32m  /**[m
[32m+[m[32m   * Cancel an appointment[m
[32m+[m[32m   */[m
[32m+[m[32m  cancel: async (id) => {[m
[32m+[m[32m    const response = await apiClient.patch(`/${id}/cancel`);[m
[32m+[m[32m    return response.data;[m
[32m+[m[32m  },[m
[32m+[m[32m};[m
[32m+[m
[32m+[m[32mexport default appointmentApi;[m
[1mdiff --git a/frontend/vite.config.js b/frontend/vite.config.js[m
[1mnew file mode 100644[m
[1mindex 0000000..ecd10b5[m
[1m--- /dev/null[m
[1m+++ b/frontend/vite.config.js[m
[36m@@ -0,0 +1,15 @@[m
[32m+[m[32mimport { defineConfig } from 'vite'[m
[32m+[m[32mimport react from '@vitejs/plugin-react'[m
[32m+[m[32mimport tailwindcss from '@tailwindcss/vite'[m
[32m+[m
[32m+[m[32m// https://vite.dev/config/[m
[32m+[m[32mexport default defineConfig({[m
[32m+[m[32m  plugins: [[m
[32m+[m[32m    react(),[m
[32m+[m[32m    tailwindcss(),[m
[32m+[m[32m  ],[m
[32m+[m[32m  server: {[m
[32m+[m[32m    port: 5173,[m
[32m+[m[32m    host: '127.0.0.1',[m
[32m+[m[32m  },[m
[32m+[m[32m})[m
