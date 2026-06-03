@echo off
SETLOCAL EnableDelayedExpansion

echo ===================================================
echo   System Automation: Alarm Batch Summary Report
echo ===================================================
echo.

:: Define explicit directory paths based on the new folder structure
set "SCRIPT_DIR=src"
set "SCRIPT_NAME=script.py"
set "REQ_NAME=requirements.txt"

:: Verify that the src folder and its files exist before proceeding
if not exist "%SCRIPT_DIR%\%SCRIPT_NAME%" (
    echo [ERROR] Could not find %SCRIPT_NAME% inside the '%SCRIPT_DIR%' folder.
    echo Please ensure your files match the structure: src\script.py
    echo.
    pause
    exit /b
)

if not exist "%SCRIPT_DIR%\%REQ_NAME%" (
    echo [ERROR] Could not find %REQ_NAME% inside the '%SCRIPT_DIR%' folder.
    echo Please ensure your files match the structure: src\requirements.txt
    echo.
    pause
    exit /b
)

echo [INFO] Validating Python environment dependencies...

:: Use Python to verify if the dependencies in requirements.txt are already met
python -c "import pkg_resources; pkg_resources.require(open(r'%SCRIPT_DIR%\%REQ_NAME%').read().splitlines())" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo [WARN] Missing or outdated dependencies detected.
    echo [INFO] Installing required packages from '%SCRIPT_DIR%\%REQ_NAME%'...
    echo.
    
    python -m pip install --upgrade pip
    python -m pip install -r "%SCRIPT_DIR%\%REQ_NAME%"
    
    if !ERRORLEVEL! NEQ 0 (
        echo.
        echo [ERROR] Dependency installation failed. Please check your internet connection.
        pause
        exit /b
    )
    echo.
    echo [SUCCESS] Dependencies successfully configured.
) else (
    echo [SUCCESS] All Python requirements are already satisfied.
)

echo [INFO] Launching Summary Generator...
echo ---------------------------------------------------
echo.

:: Run the script inside the src folder
python "%SCRIPT_DIR%\%SCRIPT_NAME%"

echo.
echo ---------------------------------------------------
echo [SUCCESS] Batch execution finished.
echo.
pause