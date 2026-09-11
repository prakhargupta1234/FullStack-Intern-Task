# 📅 Appointment Board

A modern, responsive, full-stack appointment board designed for teams to coordinate, schedule, and manage appointments seamlessly without double-booking or scheduling conflicts.

Built for the **Python Full Stack Developer Intern** technical assignment.

---

## 🌟 Overview

The **Appointment Board** is a centralized scheduling application tailored for a collaborative team. It provides a real-time overview of scheduled, completed, and cancelled appointments with strict automated conflict detection to prevent overlapping slots on the same date.

### Key Highlights
- **Conflict Prevention Engine**: Both backend and frontend validate appointment times. Overlapping active appointments on the same date are rejected with HTTP 409 Conflict.
- **Back-to-Back Slot Support**: Seamlessly allows consecutive slots (e.g., `10:00 - 11:00` followed by `11:00 - 12:00`).
- **Full Lifecycle Management**: Add, edit, complete, or cancel appointments. Cancelled appointments remain visible in the record for auditability while releasing their time slot.
- **Dynamic Backend Filtering**: Filter by date, status, or both via REST API query parameters.
- **Clean Responsive UI**: Designed with Tailwind CSS, Plus Jakarta Sans typography, modal dialogs, status badges, and animated feedback toasts.
- **One-Click Startup**: Includes [`STARTUP_GUIDE.md`](STARTUP_GUIDE.md) and automated `start_all.bat` launcher.

---

## 🏗️ Architecture & Technology Stack

The application follows a clean 3-tier architecture:

```
┌─────────────────────────────────────────────────────────┐
│                 React.js 19 + Vite                      │  (Frontend UI)
│   Tailwind CSS • Axios • React Hooks • Lucide Icons     │  Port: 5173 / 5174
└────────────────────────────┬────────────────────────────┘
                             │  HTTP / JSON REST API
                             ▼
┌─────────────────────────────────────────────────────────┐
│                    FastAPI + Uvicorn                    │  (Backend API)
│    Pydantic v2 • SQLAlchemy 2.0 ORM • Python 3.14      │  Port: 8000
└────────────────────────────┬────────────────────────────┘
                             │  PyMySQL Driver
                             ▼
┌─────────────────────────────────────────────────────────┐
│                          MySQL                          │  (Relational Database)
│        `appointment_board` database • InnoDB Engine     │  Port: 3306
└─────────────────────────────────────────────────────────┘
```

### Stack Details
- **Frontend**:
  - **React.js** (v19) with Vite build tool
  - **Tailwind CSS** (v4) for styling and layout
  - **Axios** for API requests and response interceptors
  - **Lucide React** for lightweight iconography
  - **React Hooks** (`useState`, `useEffect`, `useCallback`) for clean state management
- **Backend**:
  - **Python 3**
  - **FastAPI** for high-performance REST endpoints
  - **SQLAlchemy 2.0** ORM for database models and queries
  - **Pydantic v2** for schema validation and serialization
  - **Uvicorn** as ASGI web server
- **Database**:
  - **MySQL** (v8.0+)
  - **PyMySQL** as the pure Python DBAPI driver

---

## 📁 Project Structure

```
Remote_Assignment/
├── backend/
│   ├── app/
│   │   ├── __init__.py
│   │   ├── main.py                  # FastAPI app, CORS, lifespan, exception handlers
│   │   ├── database.py              # Engine, session factory, URL builder
│   │   ├── models/
│   │   │   ├── __init__.py
│   │   │   └── appointment.py       # SQLAlchemy Appointment model & status enum
│   │   ├── schemas/
│   │   │   ├── __init__.py
│   │   │   └── appointment.py       # Pydantic request & response schemas
│   │   ├── routers/
│   │   │   ├── __init__.py
│   │   │   └── appointments.py      # REST endpoint routes (/api/appointments)
│   │   └── services/
│   │       ├── __init__.py
│   │       └── appointment_service.py # Conflict detection, CRUD & seed logic
│   ├── tests/
│   │   └── test_conflict.py         # Automated test suite for business & conflict logic
│   ├── .env                         # Local database environment configuration (gitignored)
│   ├── .env.example                 # Template for environment configuration
│   └── requirements.txt             # Python dependencies
│
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   │   ├── AppointmentCard.jsx   # Card component with status badge & actions
│   │   │   ├── AppointmentForm.jsx   # Form fields & client-side validation
│   │   │   ├── AppointmentModal.jsx  # Accessible modal wrapper for Add/Edit
│   │   │   ├── AppointmentFilters.jsx# Date picker, status dropdown, clear button
│   │   │   ├── StatusBadge.jsx       # Visual badge for Scheduled/Completed/Cancelled
│   │   │   ├── ConfirmModal.jsx      # Confirmation modal for appointment cancellation
│   │   │   └── Toast.jsx             # Auto-dismissing success/error toast
│   │   ├── pages/
│   │   │   └── AppointmentBoard.jsx  # Main dashboard page orchestrating state
│   │   ├── services/
│   │   │   └── appointmentApi.js     # Axios API service with proxy & error extraction
│   │   ├── App.jsx                   # Root application shell
│   │   ├── index.css                 # Tailwind CSS styles & custom scrollbars
│   │   └── main.jsx                  # React DOM entry point
│   ├── index.html                   # HTML template with Plus Jakarta Sans font
│   ├── package.json                 # Frontend dependencies & scripts
│   └── vite.config.js               # Vite config with Tailwind & API proxy
│
├── .gitignore                       # Git ignore file for Python, Node, & .env
└── README.md                        # Documentation & setup guide
```

---

## ⚙️ Prerequisites

Ensure you have the following installed on your system:
1. **Python 3.10+** (Tested on Python 3.14)
2. **Node.js 18+** and **npm** (Tested on Node v24.11.1)
3. **MySQL Server 8.0+** running locally on port 3306

---

## 🗄️ Database Setup

1. Start your local MySQL service.
2. Open MySQL CLI or MySQL Workbench:
   ```sql
   mysql -u root -p
   ```
3. Create the database:
   ```sql
   CREATE DATABASE IF NOT EXISTS appointment_board CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```
4. The database table `appointments` is **automatically created on backend startup** by SQLAlchemy via `Base.metadata.create_all()`.
5. On the first startup, if the table is empty, **5 non-overlapping sample appointments** are automatically seeded into the database.

---

## 🔐 Environment Variables

Never commit `.env` files containing real database credentials to version control. The repository includes `.env.example` with placeholder values:

### `backend/.env.example`
```env
# Database connection string
DATABASE_URL=mysql+pymysql://root:password@127.0.0.1:3306/appointment_board

# Or use granular database configuration:
DB_USER=root
DB_PASSWORD=password
DB_HOST=127.0.0.1
DB_PORT=3306
DB_NAME=appointment_board

# Application Settings
FRONTEND_URL=http://localhost:5173
PORT=8000
HOST=0.0.0.0
```

> **Note on Special Characters**: If your MySQL password contains special characters (such as `@`, `#`, or `%`), you can either set the granular `DB_PASSWORD` variable (which handles special characters safely via `URL.create`), or URL-encode the password in `DATABASE_URL` (e.g. `@` becomes `%40`).

---

## 🚀 Running the Application

### 1. Backend Setup (FastAPI)

Navigate to the `backend` folder:
```bash
cd backend
```

Create and activate a virtual environment:
- **Windows (PowerShell)**:
  ```powershell
  python -m venv venv
  .\venv\Scripts\Activate.ps1
  ```
- **macOS / Linux**:
  ```bash
  python3 -m venv venv
  source venv/bin/activate
  ```

Install dependencies:
```bash
pip install -r requirements.txt
```

Create your `.env` file from `.env.example` and set your credentials:
```bash
cp .env.example .env
```

Start the FastAPI server:
```bash
uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
```
- API Base URL: `http://127.0.0.1:8000`
- Interactive Swagger Docs: `http://127.0.0.1:8000/docs`

---

### 2. Frontend Setup (React + Vite)

In a separate terminal, navigate to the `frontend` folder:
```bash
cd frontend
```

Install packages:
```bash
npm install
```

Start the Vite development server:
```bash
npm run dev
```

Open your browser at `http://localhost:5173` (or the port indicated in your terminal).

---

## ⚡ Conflict Detection Logic

Preventing double-booking is a critical feature of the Appointment Board.

### Mathematical Condition
Two appointments on the same date overlap if and only if:
$$\text{new\_start} < \text{existing\_end} \quad \land \quad \text{new\_end} > \text{existing\_start}$$

### Rules
1. **Status Filter**: Only active appointments (`status != 'Cancelled'`) participate in conflict checks. Cancelled appointments do not block time slots.
2. **Back-to-Back Allowed**: If an appointment ends at `11:00` and another begins at `11:00`:
   - `new_start < existing_end` evaluates to `11:00 < 11:00` which is **False**.
   - Hence, back-to-back appointments are allowed.
3. **Self-Exclusion on Edit**: When updating an existing appointment, the query excludes `id != current_appointment_id`, preventing an appointment from conflicting with itself.
4. **Independent Backend Validation**: Even if frontend validation is bypassed, FastAPI independently checks the database query before saving, returning `HTTP 409 Conflict` if an overlap is detected:
   ```json
   {
     "detail": "Selected time slot conflicts with an existing appointment."
   }
   ```

---

## 📖 REST API Endpoints

| Method | Endpoint | Status | Description |
|---|---|---|---|
| `GET` | `/api/appointments` | 200 | List all appointments. Optional query filters: `?date=YYYY-MM-DD` and `?status=Scheduled` |
| `GET` | `/api/appointments/{id}` | 200 / 404 | Get single appointment by ID |
| `POST` | `/api/appointments` | 201 / 400 / 409 | Create new appointment. Validates times & overlaps |
| `PUT` | `/api/appointments/{id}` | 200 / 400 / 404 / 409 | Update appointment details. Excludes self from conflict check |
| `PATCH` | `/api/appointments/{id}/complete` | 200 / 400 / 404 | Mark appointment as Completed (disallows Cancelled -> Completed) |
| `PATCH` | `/api/appointments/{id}/cancel` | 200 / 404 | Cancel appointment (releases time slot, keeps DB record) |
| `GET` | `/health` | 200 | Health check endpoint |

---

## 🧪 Automated & Manual Testing

### Automated Backend Tests
Run the included test suite to verify conflict detection, edge cases, and state transitions:
```bash
python backend/tests/test_conflict.py
```

Tests include:
- `test_end_time_must_be_after_start_time`: Rejects `end_time <= start_time` with HTTP 400.
- `test_conflict_detection_overlap_rejected`: Rejects overlapping slots with HTTP 409.
- `test_back_to_back_appointments_allowed`: Confirms consecutive slots are permitted.
- `test_cancelled_appointment_does_not_block_slot`: Confirms cancelled slots can be re-booked.
- `test_update_allows_same_time_without_self_conflict`: Confirms self-exclusion on edit.
- `test_cannot_complete_cancelled_appointment`: Rejects invalid state transitions with HTTP 400.

### Manual Testing Checklist
- [x] **Sample Appointments**: 5 diverse sample appointments appear on fresh startup.
- [x] **Client Validation**: Attempting to create an appointment with an empty title displays `"Title is required."`.
- [x] **Time Validation**: Attempting to set end time earlier than start time displays `"End time must be after start time."`.
- [x] **Conflict Detection**: Attempting to create an appointment overlapping an existing active appointment shows `"Selected time slot conflicts with an existing appointment."`.
- [x] **Back-to-Back Slots**: Creating an appointment starting right when another ends succeeds.
- [x] **Edit Flow**: Editing appointment title/times updates the card immediately without self-conflict.
- [x] **Complete Action**: Clicking "Complete" updates status to `Completed` with green badge.
- [x] **Cancel Action**: Clicking "Cancel" opens confirmation modal; confirming transitions card to `Cancelled` with strikethrough styling and releases slot.
- [x] **Date Filter**: Selecting a date displays only appointments on that date.
- [x] **Status Filter**: Selecting a status (e.g., `Completed`) filters the cards accordingly.
- [x] **Combined Filters**: Combining Date + Status filters works seamlessly.
- [x] **Clear Filters**: Restores the full appointments list.
- [x] **Empty State**: When filters yield zero results, displays `"No appointments match your filters."` with a "Clear Filters" button.

---

## 📌 Assumptions

1. **Authentication**: In accordance with project instructions, authentication and authorization are omitted to focus on clean domain logic, scheduling algorithms, and responsive UI design.
2. **Team Scope**: The appointment board is designed for a single collaborative team.
3. **Data Retention**: Cancelled appointments are preserved in the database for auditing and historical reference, but are excluded from active conflict validation.
4. **Single-Day Slots**: Appointments are scheduled within a single calendar day (end time > start time on the same date).
