@echo off
REM Gobbonet Launcher for Windows
REM This script manages the application lifecycle, including password setup, hardware probing, model downloading, and health monitoring.

REM Check for PowerShell
where powershell >nul 2>nul
if errorlevel 1 (
    echo PowerShell is required to run this script.
    exit /b 1
)

REM Password setup
if not exist ".gobbonet-secret" (
    set /p password="Enter a password for Gobbonet: "
    echo %password% | powershell -Command "ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File .gobbonet-secret"
)

REM Hardware probe
powershell -ExecutionPolicy Bypass -File hardware-probe.ps1

REM Model download
call models-list.json

REM Start the fileserver
start powershell -ExecutionPolicy Bypass -File fileserver.ps1

REM Health monitoring loop
:health_check
timeout /t 10
REM Check if llama-server is running
tasklist | findstr /i "llama-server.exe" >nul
if errorlevel 1 (
    echo Llama-server is not running. Restarting...
    start llama-server.exe
)
goto health_check

REM End of script