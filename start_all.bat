@echo off
title Appointment Board Launcher
echo ========================================================
echo Launching Appointment Board Full Stack Application...
echo ========================================================

echo 1. Starting Backend server in a new window...
start "Appointment Board - Backend" cmd /c "%~dp0start_backend.bat"

timeout /t 2 /nobreak >nul

echo 2. Starting Frontend server in a new window...
start "Appointment Board - Frontend" cmd /c "%~dp0start_frontend.bat"

echo ========================================================
echo Both servers are starting up!
echo Backend:  http://127.0.0.1:8000 (Swagger: http://127.0.0.1:8000/docs)
echo Frontend: http://localhost:5173
echo ========================================================
