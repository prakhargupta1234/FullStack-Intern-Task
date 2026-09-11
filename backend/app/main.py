import os
import time
import logging
from contextlib import asynccontextmanager
from fastapi import FastAPI, Request, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from fastapi.exceptions import RequestValidationError

from app.database import engine, Base, SessionLocal
from app.routers import appointments_router
from app.services import seed_sample_data_if_empty

# Configure structured application logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
logger = logging.getLogger("appointment_board")


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Handles startup and shutdown events.
    Auto-creates database tables and seeds initial sample appointments if empty.
    """
    logger.info("Initializing database tables via SQLAlchemy metadata...")
    Base.metadata.create_all(bind=engine)

    db = SessionLocal()
    try:
        seed_sample_data_if_empty(db)
    except Exception as exc:
        logger.error(f"Failed to seed sample appointments on startup: {exc}")
    finally:
        db.close()

    yield
    logger.info("Shutting down Appointment Board API...")


app = FastAPI(
    title="Appointment Board API",
    description="Backend service for scheduling team appointments with real-time conflict checking.",
    version="1.0.0",
    lifespan=lifespan,
    docs_url="/docs",
    redoc_url="/redoc",
)

# CORS configuration supporting localhost dev ports
app.add_middleware(
    CORSMiddleware,
    allow_origin_regex=r"^https?://(localhost|127\.0\.0\.1)(:[0-9]+)?$",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.middleware("http")
async def log_requests(request: Request, call_next):
    """Logs incoming HTTP requests with execution duration."""
    start_time = time.time()
    response = await call_next(request)
    duration_ms = round((time.time() - start_time) * 1000, 2)
    logger.info(f"{request.method} {request.url.path} completed with {response.status_code} ({duration_ms}ms)")
    return response


@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    """Normalizes Pydantic input validation errors into client-friendly messages."""
    errors = exc.errors()
    messages = []
    for err in errors:
        loc = " -> ".join(str(l) for l in err.get("loc", []))
        msg = err.get("msg", "Invalid input")
        messages.append(f"{loc}: {msg}")
    return JSONResponse(
        status_code=status.HTTP_400_BAD_REQUEST,
        content={"detail": "Validation error: " + "; ".join(messages)},
    )


@app.exception_handler(Exception)
async def generic_exception_handler(request: Request, exc: Exception):
    """Catches unhandled exceptions so stack traces don't leak to API consumers."""
    logger.exception(f"Unhandled server error processing {request.method} {request.url.path}: {exc}")
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content={"detail": "An unexpected internal server error occurred. Please try again later."},
    )


# Attach routers
app.include_router(appointments_router)


@app.get("/health", tags=["System"])
def health_check():
    """Liveness probe endpoint."""
    return {"status": "healthy", "service": "appointment-board-api"}
