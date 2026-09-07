@echo off
REM This script sets up firewall rules for LAN access

REM Check if the script is run with administrative privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script requires administrative privileges. Please run as administrator.
    exit /b
)

REM Enable firewall rules for the application
echo Setting up firewall rules for Gobbonet...

REM Allow inbound traffic on port 9066
netsh advfirewall firewall add rule name="Gobbonet" dir=in action=allow protocol=TCP localport=9066
echo Inbound rule added for port 9066.

REM Allow inbound traffic on port 11437 for llama-server
netsh advfirewall firewall add rule name="Llama Server" dir=in action=allow protocol=TCP localport=11437
echo Inbound rule added for port 11437.

echo Firewall setup complete. You can now access Gobbonet from other devices on the LAN.
pause