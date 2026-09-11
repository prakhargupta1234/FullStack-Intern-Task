@echo off
title Appointment Board - Frontend (React + Vite)
echo ========================================================
echo Starting Appointment Board Frontend Server...
echo ========================================================
cd /d "%~dp0frontend"

echo Starting Vite Dev Server...
call npm run dev
pause
