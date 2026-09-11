# 🚀 Complete Startup & Operational Guide

This guide provides step-by-step instructions on **how to start the backend, start the frontend, and understand how the application works internally**.

---

## 📌 Table of Contents
1. [Prerequisites](#1-prerequisites)
2. [MySQL Database Setup](#2-mysql-database-setup)
3. [Starting the Backend (FastAPI)](#3-starting-the-backend-fastapi)
4. [Starting the Frontend (React + Vite)](#4-starting-the-frontend-react--vite)
5. [One-Click Windows Start Scripts](#5-one-click-windows-start-scripts)
6. [How the Application Works (Architecture & Data Flow)](#6-how-the-application-works-architecture--data-flow)
7. [How Appointment Conflict Detection Works](#7-how-appointment-conflict-detection-works)
8. [Feature Walkthrough & User Guide](#8-feature-walkthrough--user-guide)
9. [Troubleshooting & FAQs](#9-troubleshooting--faqs)

---

## 1. Prerequisites

Make sure the following are installed on your machine:
- **Python 3.10+** (Tested on Python 3.14): `python --version`
- **Node.js 18+** & **npm**: `node -v` and `npm -v`
- **MySQL Server 8.0+** running on `localhost:3306`

---

## 2. MySQL Database Setup

1. Start your local MySQL service.
2. Log into MySQL CLI or MySQL Workbench:
   ```bash
   mysql -u root -p
   ```
3. Run this command to create the database:
   ```sql
   CREATE DATABASE IF NOT EXISTS appointment_board CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```
4. Verify your credentials in `backend/.env`:
   ```env
   DATABASE_URL=mysql+pymysql://root:prakhar22%40@127.0.0.1:3306/appointment_board
   DB_USER=root
   DB_PASSWORD=prakhar22@
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_NAME=appointment_board
   FRONTEND_URL=http://localhost:5173
   PORT=8000
   HOST=0.0.0.0
   ```
   > **Note on Passwords**: If your password contains `@`, it is safely handled by the `DB_PASSWORD` configuration, or encoded as `%40` in `DATABASE_URL`.

---

## 3. Starting the Backend (FastAPI)

Open a terminal in the root directory:

### Step 3.1: Navigate to the `backend` directory
```bash
cd backend
```

### Step 3.2: Create and activate a virtual environment
- **Windows (PowerShell)**:
  ```powershell
  python -m venv venv
  .\venv\Scripts\Activate.ps1
  ```
  *(If PowerShell displays a script execution policy error, run `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` first)*

- **Windows (Command Prompt)**:
  ```cmd
  python -m venv venv
  venv\Scripts\activate.bat
  ```

- **macOS / Linux**:
  ```bash
  python3 -m venv venv
  source venv/bin/activate
  ```

### Step 3.3: Install backend dependencies
```bash
pip install -r requirements.txt
```

### Step 3.4: Run the FastAPI backend server
```bash
uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
```

You should see output similar to:
```
INFO:     Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)
INFO:     Started reloader process
INFO:     Waiting for application startup.
Successfully seeded 5 sample appointments into the database.
INFO:     Application startup complete.
```

- **Backend API URL**: `http://127.0.0.1:8000`
- **Interactive Swagger Documentation**: `http://127.0.0.1:8000/docs`
- **Alternative Redoc Documentation**: `http://127.0.0.1:8000/redoc`

---

## 4. Starting the Frontend (React + Vite)

Open a **second terminal** window:

### Step 4.1: Navigate to the `frontend` directory
```bash
cd frontend
```

### Step 4.2: Install frontend dependencies
```bash
npm install
```

### Step 4.3: Start the Vite development server
```bash
npm run dev
```

You should see:
```
  VITE v8.3.0  ready in 250 ms

  ➜  Local:   http://127.0.0.1:5173/
  ➜  Network: use --host to expose
```

### Step 4.4: Open in Browser
Open your browser and navigate to:
👉 **`http://localhost:5173`** (or `http://127.0.0.1:5173` / `http://127.0.0.1:5174`)

---

## 5. One-Click Windows Start Scripts

For quick startup on Windows, three `.bat` scripts are included in the repository root:

1. **`start_all.bat`**: Launches both backend and frontend in separate command prompt windows with a single double-click.
2. **`start_backend.bat`**: Activates Python virtual environment and starts Uvicorn.
3. **`start_frontend.bat`**: Starts the Vite development server.

---

## 6. How the Application Works (Architecture & Data Flow)

### High-Level Architecture
```
┌──────────────────────────────────────────────┐
│             React Frontend (Vite)            │
│  - AppointmentBoard.jsx (State Management)   │
│  - AppointmentFilters.jsx (Date / Status)    │
│  - AppointmentModal.jsx & Form (Validation)  │
│  - AppointmentCard.jsx (Actions & Badges)    │
└──────────────────────┬───────────────────────┘
                       │ Axios (HTTP REST Requests)
                       ▼
┌──────────────────────────────────────────────┐
│            FastAPI Backend Service           │
│  - /api/appointments (CRUD Endpoints)        │
│  - Pydantic v2 (Input & Output Serialization)│
│  - appointment_service.py (Business Logic)   │
└──────────────────────┬───────────────────────┘
                       │ SQLAlchemy 2.0 ORM
                       ▼
┌──────────────────────────────────────────────┐
│             MySQL Database (Port 3306)       │
│  - Table: `appointments`                     │
│  - PyMySQL DBAPI Connection Pool             │
└──────────────────────────────────────────────┘
```

### End-to-End Operational Lifecycle

1. **Application Startup & Database Seeding**:
   - When FastAPI starts, `lifespan` in `backend/app/main.py` runs.
   - It runs `Base.metadata.create_all()`, automatically creating the `appointments` MySQL table if it doesn't already exist.
   - It checks `COUNT(*)`. If the table is empty, it seeds 5 realistic, non-overlapping sample appointments (Team Standup, Client Meeting, Project Review, Design Discussion, Candidate Interview). If records already exist, it skips seeding to prevent duplicate data.

2. **Fetching Appointments**:
   - When the React dashboard mounts, `appointmentApi.getAll(filters)` executes a `GET /api/appointments?date=...&status=...`.
   - FastAPI queries MySQL using SQLAlchemy with dynamic `.filter()` clauses for date and status, returning sorted appointments by date and start time.
   - React displays the cards or shows an empty state if no appointments match.

3. **Creating an Appointment**:
   - User clicks **"+ Add Appointment"**, opening `AppointmentModal`.
   - Frontend validates that Title, Date, Start Time, and End Time are filled, and `end_time > start_time`.
   - On submit, Axios sends a `POST /api/appointments` payload.
   - FastAPI validates types with Pydantic (`AppointmentCreate`).
   - The backend service queries MySQL to verify whether any non-cancelled appointment on that date overlaps with the new time slot.
   - If an overlap exists, FastAPI aborts and returns `HTTP 409 Conflict`.
   - If clear, the appointment is inserted with status `"Scheduled"`, returning `HTTP 201 Created`.
   - The UI displays a green success toast `"Appointment created successfully."` and refreshes the cards.

4. **Updating an Appointment**:
   - User clicks **"Edit"** on a card.
   - The modal pre-fills existing appointment data.
   - On submit, Axios sends a `PUT /api/appointments/{id}` request.
   - The backend conflict check explicitly excludes the current appointment ID (`Appointment.id != appointment_id`), ensuring the appointment does not conflict with itself when keeping or shifting times.

5. **Completing an Appointment**:
   - User clicks **"Complete"** on a Scheduled appointment card.
   - Axios sends `PATCH /api/appointments/{id}/complete`.
   - Backend transitions status from `"Scheduled"` to `"Completed"`.
   - If an invalid transition is attempted (e.g. Cancelled to Completed), backend returns `HTTP 400 Bad Request`.

6. **Cancelling an Appointment**:
   - User clicks **"Cancel"**.
   - `ConfirmModal` prompts the user for confirmation.
   - On confirmation, Axios sends `PATCH /api/appointments/{id}/cancel`.
   - Status is updated to `"Cancelled"` (record is **NOT** deleted).
   - Card is styled with strikethrough styling and a `"Slot released"` badge.
   - Because its status is now `"Cancelled"`, it is excluded from future conflict checks, freeing up the time slot.

---

## 7. How Appointment Conflict Detection Works

### The Golden Conflict Formula
Two appointments on the **same date** overlap if and only if:
$$\text{new\_start} < \text{existing\_end} \quad \text{AND} \quad \text{new\_end} > \text{existing\_start}$$

### Visual Examples

#### ❌ Scenario A: Overlapping Slots (REJECTED with HTTP 409)
- Existing Meeting: `10:00 AM` to `11:00 AM`
- Requested New Meeting: `10:30 AM` to `11:30 AM`
- Evaluation:
  - `10:30 < 11:00` (True)
  - `11:30 > 10:00` (True)
  - Result: **Conflict detected** ➔ Request rejected with `"Selected time slot conflicts with an existing appointment."`

#### ✅ Scenario B: Back-to-Back Slots (ALLOWED)
- Existing Meeting: `10:00 AM` to `11:00 AM`
- Requested New Meeting: `11:00 AM` to `12:00 PM`
- Evaluation:
  - `11:00 < 11:00` (**False**)
  - Result: **No conflict** ➔ Back-to-back booking is permitted!

#### ✅ Scenario C: Overlapping with a Cancelled Slot (ALLOWED)
- Cancelled Meeting: `01:00 PM` to `02:00 PM` (Status: `Cancelled`)
- Requested New Meeting: `01:00 PM` to `02:00 PM`
- Evaluation:
  - Query filters: `Appointment.status != 'Cancelled'`
  - Result: Cancelled appointments do not block time slots ➔ New meeting created successfully!

---

## 8. Feature Walkthrough & User Guide

| Feature | How to Use in the UI |
|---|---|
| **Add Appointment** | Click **"+ Add Appointment"** in the header ➔ Fill Title, Date, Start Time, End Time ➔ Click **"Create Appointment"**. |
| **Filter by Date** | Choose a date using the calendar input in the filter bar. The board immediately updates. |
| **Filter by Status** | Choose `Scheduled`, `Completed`, or `Cancelled` from the dropdown. |
| **Clear Filters** | Click **"Clear Filters"** to reset both date and status filters. |
| **Edit Appointment** | Click **"Edit"** on any active appointment card ➔ Modify details ➔ Click **"Update Appointment"**. |
| **Complete Appointment** | Click **"Complete"** on any Scheduled card ➔ Card turns green with a checkmark badge. |
| **Cancel Appointment** | Click **"Cancel"** ➔ Confirm in dialog ➔ Card is marked Cancelled with strikethrough. |

---

## 9. Troubleshooting & FAQs

### Q: "Port 5173 is in use, trying another one..."
- **A**: Vite automatically selects `5174` if `5173` is occupied. The backend CORS and Vite proxy (`/api`) are configured to support any port dynamically.

### Q: "Access denied for user 'root'@'localhost'"
- **A**: Check your password in `backend/.env`. If your password contains `@` (e.g. `prakhar22@`), make sure `DB_PASSWORD=prakhar22@` is set, or URL-encode it as `%40` in `DATABASE_URL`.

### Q: How do I run the automated backend test suite?
- **A**: Run:
  ```bash
  python backend/tests/test_conflict.py
  ```
  All 6 unit tests will run and report `OK`.
