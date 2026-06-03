@echo off
echo ===================================================
echo   System Automation: Alarm Batch Summary Report
echo ===================================================
echo.

:: 1. Define absolute paths natively. Quotes ensure spaces in folder names are handled flawlessly.
set "REQ_FILE=%~dp0src\requirements.txt"
set "SCRIPT_FILE=%~dp0src\script.py"

:: 2. Verify requirements.txt exists natively
if not exist "%REQ_FILE%" (
    echo [ERROR] Could not find requirements.txt!
    echo Looked specifically in: "%REQ_FILE%"
    pause
    exit /b
)

:: 3. Verify script.py exists natively
if not exist "%SCRIPT_FILE%" (
    echo [ERROR] Could not find script.py!
    echo Looked specifically in: "%SCRIPT_FILE%"
    pause
    exit /b
)

echo [INFO] Validating Python environment dependencies...

:: 4. Install dependencies targeting the absolute path string
python -m pip install --upgrade pip
python -m pip install -r "%REQ_FILE%" 
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Dependency installation failed. Please check your internet connection.
    pause
    exit /b
)
echo [SUCCESS] Dependencies successfully configured.
echo.
echo [INFO] Launching Summary Generator...
echo ---------------------------------------------------

:: 5. Execute script directly using its absolute path. 
:: (This completely bypasses the UNC network drive error on your VDI!)
python "%SCRIPT_FILE%"

echo ---------------------------------------------------
echo [SUCCESS] Batch execution finished.
pause