:: Script to run both the node.js backend and flutter frontend at the same time
:: To run the script, run ./run_project.bat in the terminal

@echo off
echo Starting back-end and front-end...

REM Start back-end in the background
start /B npm start --prefix backend

REM Start front-end in the foreground
flutter run lib/main.dart