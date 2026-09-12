# Setup and Operational Guide

This guide provides step-by-step instructions on setting up the local development environment, starting the services, and troubleshooting common issues.

---

## Prerequisites

Make sure the following dependencies are installed:
- Python 3.10+
- Node.js 18+ and npm
- MySQL Server 8.0+ running on `localhost:3306`

---

## Database Setup

1. Start your local MySQL server.
2. Connect to MySQL via CLI or MySQL Workbench:
   ```bash
   mysql -u root -p
   ```
3. Run this command to create the database:
   ```sql
   CREATE DATABASE IF NOT EXISTS appointment_board CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```
4. Verify your credentials in `backend/.env`:
   ```env
   DB_USER=root
   DB_PASSWORD=your_password
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_NAME=appointment_board
   FRONTEND_URL=http://localhost:5173
   PORT=8000
   HOST=0.0.0.0
   ```
   > Note: If your password contains special characters (such as `@`), set the granular `DB_PASSWORD` variable directly.

---

## Starting the Backend (FastAPI)

Open a terminal in the project root:

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

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Run the development server:
   ```bash
   uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
   ```

- API Base URL: `http://127.0.0.1:8000`
- Swagger UI: `http://127.0.0.1:8000/docs`
- ReDoc: `http://127.0.0.1:8000/redoc`

---

## Starting the Frontend (React + Vite)

Open a separate terminal window:

1. Navigate to the `frontend` directory:
   ```bash
   cd frontend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the Vite development server:
   ```bash
   npm run dev
   ```

4. Open your browser at `http://localhost:5173`.

---

## Windows Quick-Start Scripts

For convenience on Windows machines, three batch files are included in the repository root:
- `start_all.bat`: Launches backend and frontend in separate command windows.
- `start_backend.bat`: Starts the virtual environment and Uvicorn server.
- `start_frontend.bat`: Starts the Vite dev server.

---

## Application Data Flow

1. **Initial Load & Auto-Seed**:
   - On startup, FastAPI runs `Base.metadata.create_all()` to ensure the `appointments` table exists.
   - If the table is empty, 5 realistic sample appointments are inserted so the board is ready to test immediately.

2. **Listing Appointments**:
   - React calls `GET /api/appointments` via Axios.
   - Optional query parameters `date` and `status` filter records dynamically.
   - Appointments are sorted chronologically by date and start time.

3. **Booking an Appointment**:
   - Client performs initial checks (required fields, `end_time > start_time`).
   - Server runs authoritative conflict validation against active appointments on that date.
   - If a conflict exists, returns `HTTP 409 Conflict`.
   - On success, returns `HTTP 201 Created` and updates the board.

4. **Editing an Appointment**:
   - Sends `PUT /api/appointments/{id}`.
   - Server excludes the record itself (`id != exclude_id`) so the appointment can keep or modify its time without false conflict errors.

5. **Completing an Appointment**:
   - Sends `PATCH /api/appointments/{id}/complete`.
   - Moves status to `Completed`. Transitions from `Cancelled` to `Completed` are rejected with `HTTP 400`.

6. **Cancelling an Appointment**:
   - User confirms in modal, then sends `PATCH /api/appointments/{id}/cancel`.
   - Sets status to `Cancelled`. The record remains in the database for reference, but releases its time slot for future bookings.

---

## Troubleshooting

### Port 5173 is already in use
Vite will automatically increment to the next open port (e.g., `5174`). The Vite proxy and FastAPI CORS are configured to handle local development ports automatically.

### Database connection errors
Check that:
1. MySQL server is running on port 3306.
2. The database `appointment_board` was created.
3. Credentials in `backend/.env` match your local MySQL configuration.

### Running Backend Tests
To run the automated test suite verifying conflict detection and lifecycle transitions:
```bash
python -m unittest backend/tests/test_conflict.py
```
