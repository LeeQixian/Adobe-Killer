@echo off
:: Check for Administrator privileges
whoami /groups | findstr /i "S-1-5-32-544" >nul
if %errorlevel% NEQ 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%0' -Verb RunAs"
    exit /b
)

:: Stop Adobe services
powershell -Command "Get-Service -DisplayName 'Adobe*' | Stop-Service -Force"

:: Stop Adobe processes
set "psCommand=Get-Process * | Where-Object { $_.CompanyName -match 'Adobe' -or $_.Path -match 'Adobe' } | ForEach-Object { Stop-Process $_ -Force }"

powershell -Command "& { %psCommand% }"

echo.
echo Adobe processes stopped.
pause
exit
