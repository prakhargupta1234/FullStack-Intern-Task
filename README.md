# Appointment Board

A full-stack appointment scheduling application built with FastAPI (Python) and React. It provides a collaborative scheduling board for teams, featuring real-time conflict detection to prevent double bookings, support for consecutive (back-to-back) meetings, dynamic filtering, and complete appointment lifecycle management.

---

## Overview

Managing team calendars requires strict scheduling rules to prevent conflicting bookings while remaining flexible enough to support consecutive slots. This project implements a clean three-tier architecture:

- **Frontend**: React 19 + Vite with Tailwind CSS, Lucide icons, and Axios.
- **Backend**: FastAPI with Pydantic v2 validation and SQLAlchemy 2.0 ORM.
- **Database**: MySQL 8.0 with InnoDB engine and PyMySQL driver.

---

## Key Features

- **Conflict Detection**: Prevents overlapping slots on the same date. Both backend and frontend validate appointment intervals. Overlapping requests are rejected with `HTTP 409 Conflict`.
- **Back-to-Back Slot Support**: Consecutive meetings (such as `10:00 - 11:00` followed by `11:00 - 12:00`) are fully permitted without false conflict errors.
- **Appointment Lifecycle**:
  - `Scheduled` &rarr; Default state for new appointments.
  - `Completed` &rarr; Marks the meeting as finished.
  - `Cancelled` &rarr; Releases the time slot for new bookings while preserving the record for auditing.
- **Dynamic Filtering**: Filter appointments by specific date, status (`Scheduled`, `Completed`, `Cancelled`), or combined filters via REST query parameters.
- **Responsive Dashboard**: Card-based board with status badges, loading skeletons, modal dialogs, error toasts, and keyboard shortcut (`N` to open the add modal).
- **Auto-Seeding**: Seeds initial sample appointments on first startup if the database table is empty.

---

## Tech Stack

| Layer | Technologies |
|---|---|
| **Frontend** | React 19, Vite, Tailwind CSS v4, Axios, Lucide React |
| **Backend** | Python 3, FastAPI, SQLAlchemy 2.0, Pydantic v2, Uvicorn |
| **Database** | MySQL 8.0+, PyMySQL |
| **Testing** | Python `unittest` |

---

## Project Structure

```
Remote_Assignment/
├── backend/
│   ├── app/
│   │   ├── main.py                  # FastAPI app configuration, CORS, exception handlers
│   │   ├── database.py              # Engine, session factory, connection setup
│   │   ├── models/
│   │   │   └── appointment.py       # SQLAlchemy Appointment model and status enum
│   │   ├── schemas/
│   │   │   └── appointment.py       # Pydantic request and response schemas
│   │   ├── routers/
│   │   │   └── appointments.py      # REST endpoint routes (/api/appointments)
│   │   └── services/
│   │       └── appointment_service.py # Conflict detection, CRUD operations, seed data
│   ├── tests/
│   │   └── test_conflict.py         # Unit and integration tests for conflict logic
│   ├── .env.example                 # Environment variables template
│   └── requirements.txt             # Python dependencies
│
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   │   ├── AppointmentCard.jsx   # Card view with status badges and action buttons
│   │   │   ├── AppointmentForm.jsx   # Form fields and client validation
│   │   │   ├── AppointmentModal.jsx  # Modal wrapper for Add and Edit flows
│   │   │   ├── AppointmentFilters.jsx# Date and status filter controls
│   │   │   ├── ConfirmModal.jsx      # Confirmation dialog for cancellations
│   │   │   ├── StatusBadge.jsx       # Visual badge for appointment status
│   │   │   └── Toast.jsx             # Notification toasts for success and errors
│   │   ├── pages/
│   │   │   └── AppointmentBoard.jsx  # Main dashboard orchestrating state
│   │   ├── services/
│   │   │   └── appointmentApi.js     # Axios API service layer
│   │   ├── App.jsx
│   │   └── main.jsx
│   ├── index.html
│   ├── package.json
│   └── vite.config.js
│
├── start_all.bat                    # Windows shortcut to launch backend and frontend
├── start_backend.bat
├── start_frontend.bat
└── README.md
```

---

## Getting Started

### Prerequisites

- **Python 3.10+**
- **Node.js 18+** and **npm**
- **MySQL Server 8.0+** running on `localhost:3306`

---

### 1. Database Setup

1. Log into your local MySQL server:
   ```bash
   mysql -u root -p
   ```

2. Create the database:
   ```sql
   CREATE DATABASE IF NOT EXISTS appointment_board CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```

3. Tables are created automatically on backend startup via SQLAlchemy `Base.metadata.create_all()`.

---

### 2. Backend Setup

1. Navigate to the `backend` directory:
   ```bash
   cd backend
   ```

2. Create and activate a virtual environment:
   - **Windows (PowerShell)**:
     ```powershell
     python -m venv venv
     .\venv\Scripts\Activate.ps1
     ```
   - **Linux / macOS**:
     ```bash
     python3 -m venv venv
     source venv/bin/activate
     ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Configure environment variables:
   ```bash
   cp .env.example .env
   ```
   Update `.env` with your MySQL credentials:
   ```env
   DB_USER=root
   DB_PASSWORD=your_password
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_NAME=appointment_board
   FRONTEND_URL=http://localhost:5173
   ```

5. Start the FastAPI server:
   ```bash
   uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
   ```

- API Base URL: `http://127.0.0.1:8000`
- Interactive OpenAPI Docs: `http://127.0.0.1:8000/docs`

---

### 3. Frontend Setup

1. In a separate terminal, navigate to the `frontend` directory:
   ```bash
   cd frontend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm run dev
   ```

4. Open `http://localhost:5173` in your browser.

> On Windows, you can also launch both servers with a single command by running `start_all.bat` from the repository root.

---

## Design Decisions & Technical Trade-offs

### 1. Conflict Detection Logic

To prevent double booking on the same date, two intervals `[start_A, end_A)` and `[start_B, end_B)` overlap if and only if:

```
new_start < existing_end AND new_end > existing_start
```

**Why not use SQL `BETWEEN`?**
Using `BETWEEN` tests inclusive boundaries (`>=` and `<=`). If someone has a meeting from `10:00` to `11:00` and another tries to book `11:00` to `12:00`, `BETWEEN` evaluates `11:00 <= 11:00` as true and incorrectly flags a conflict. The strict inequality formula cleanly allows adjacent/consecutive bookings while rejecting all genuine overlaps (enclosed, enclosing, and partial overlaps).

### 2. Self-Exclusion on Updates

When editing an existing appointment (for instance, tweaking the description or shifting the end time by 15 minutes), the query excludes the current appointment's ID (`Appointment.id != exclude_id`). Without this exclusion, updating an appointment would cause it to conflict with its own database record.

### 3. Soft Cancellation vs Hard Deletion

When an appointment is cancelled, we update its status to `Cancelled` rather than running a SQL `DELETE`. This provides two major advantages:
1. **Audit Trail**: Team members can see who cancelled and review historical scheduling activity.
2. **Slot Release**: The conflict query explicitly filters `Appointment.status != 'Cancelled'`, so the cancelled time slot is immediately available for new bookings.

### 4. Service Layer Pattern

FastAPI route handlers are kept lightweight and focused solely on request parsing, status codes, and HTTP responses. All database queries, transaction management, and business logic live inside `backend/app/services/appointment_service.py`. This separation makes the core scheduling logic reusable and directly testable without needing a live HTTP server.

### 5. Production Concurrency Considerations

In a high-traffic production system with simultaneous booking attempts, two concurrent requests might pass conflict detection at the exact same millisecond before either writes to MySQL (a race condition). To make this completely bulletproof in production, we could:
- Use transaction isolation with pessimistic row locking (`SELECT ... FOR UPDATE`).
- Or leverage PostgreSQL range types with `EXCLUDE USING gist` constraints to enforce non-overlapping time ranges at the database level.

---

## REST API Endpoints

| Method | Endpoint | Status | Description |
|---|---|---|---|
| `GET` | `/api/appointments` | 200 | List all appointments. Supports query params: `?date=YYYY-MM-DD` and `?status=Scheduled` |
| `GET` | `/api/appointments/{id}` | 200, 404 | Get single appointment details by ID |
| `POST` | `/api/appointments` | 201, 400, 409 | Create new appointment. Validates times and rejects conflicts |
| `PUT` | `/api/appointments/{id}` | 200, 400, 404, 409 | Update appointment details. Excludes self from conflict check |
| `PATCH` | `/api/appointments/{id}/complete` | 200, 400, 404 | Mark appointment as Completed |
| `PATCH` | `/api/appointments/{id}/cancel` | 200, 404 | Cancel appointment (releases slot, retains record) |
| `GET` | `/health` | 200 | Health check endpoint |

---

## Automated Testing

The backend includes a comprehensive test suite in `backend/tests/test_conflict.py` testing edge cases:
- Invalid time ranges (`end_time <= start_time` returns 400)
- Overlapping appointments rejection (returns 409)
- Back-to-back appointments allowance (returns 201)
- Cancelled appointment slot reuse
- Self-exclusion during appointment updates
- State machine transition safety (cannot complete a cancelled appointment)

To run the test suite:
```bash
python -m unittest backend/tests/test_conflict.py
```
