@echo off
SETLOCAL EnableDelayedExpansion

echo ===================================================
echo   System Automation: Alarm Batch Summary Report
echo ===================================================
echo.

:: 1. Force Python to run a quick inline script to find files dynamically relative to the batch location
python -c "import os; print(os.path.exists(os.path.join(r'%~dp0', 'requirements.txt')))" 2>nul | findstr /I "True" >nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Could not find requirements.txt next to this BAT file.
    echo Current location evaluated: %~dp0
    echo.
    pause
    exit /b
)

echo [INFO] Validating Python environment dependencies...

:: 2. Install requirements pointing explicitly to the network path string
python -m pip install --upgrade pip --quiet
python -m pip install -r "%~dp0requirements.txt"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Dependency installation failed. Please check your internet connection.
    pause
    exit /b
)
echo [SUCCESS] Dependencies successfully configured.

echo.
echo [INFO] Launching Summary Generator...
echo ---------------------------------------------------
echo.

:: 3. Change directory and execute the script natively via Python's internal path parser
python -c "import os, sys; os.chdir(r'%~dp0'); sys.path.insert(0, os.getcwd()); import subprocess; subprocess.run(['python', r'src\script.py'])"

echo.
echo ---------------------------------------------------
echo [SUCCESS] Batch execution finished.
echo.
pause