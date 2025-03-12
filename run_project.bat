@echo off
echo Starting back-end and front-end...

REM Start back-end in a new Command Prompt window
start "Back-End" cmd /k "cd backend && npm start"

REM Start front-end in a new Command Prompt window
start "Front-End" cmd /k "flutter run --web-port=8000"