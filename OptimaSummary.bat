@echo off
SETLOCAL EnableDelayedExpansion

echo ===================================================
echo   System Automation: Alarm Batch Summary Report
echo ===================================================
echo.

:: Define the target paths pointing directly into the src directory
set "TARGET_DIR=%~dp0src"

:: 1. Verify requirements.txt exists inside the src folder using Python's path parser
python -c "import os; print(os.path.exists(os.path.join(r'%TARGET_DIR%', 'requirements.txt')))" 2>nul | findstr /I "True" >nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Could not find requirements.txt inside the 'src' folder.
    echo Expected Location: %TARGET_DIR%\requirements.txt
    echo.
    pause
    exit /b
)

:: 2. Verify script.py exists inside the src folder
python -c "import os; print(os.path.exists(os.path.join(r'%TARGET_DIR%', 'script.py')))" 2>nul | findstr /I "True" >nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Could not find script.py inside the 'src' folder.
    echo Expected Location: %TARGET_DIR%\script.py
    echo.
    pause
    exit /b
)

echo [INFO] Validating Python environment dependencies...

:: 3. Run pip install directly targeting the network path of requirements.txt
python -m pip install --upgrade pip --quiet
python -m pip install -r "%TARGET_DIR%\requirements.txt"

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

:: 4. Force Python to step inside the 'src' directory context and execute your core logic
python -c "import os, sys; os.chdir(r'%TARGET_DIR%'); sys.path.insert(0, os.getcwd()); import subprocess; subprocess.run(['python', 'script.py'])"

echo.
echo ---------------------------------------------------
echo [SUCCESS] Batch execution finished.
echo.
pause