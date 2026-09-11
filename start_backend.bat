@echo off
title Appointment Board - Backend (FastAPI)
echo ========================================================
echo Starting Appointment Board Backend Server...
echo ========================================================
cd /d "%~dp0backend"

if exist venv\Scripts\activate.bat (
    echo Activating Python virtual environment...
    call venv\Scripts\activate.bat
)

echo Starting Uvicorn on http://127.0.0.1:8000 ...
python -m uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
pause
