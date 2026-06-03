@echo off
SETLOCAL EnableDelayedExpansion

echo ===================================================
echo   System Automation: Alarm Batch Summary Report
echo ===================================================
echo.

:: Define the target network paths explicitly using the batch location context
set "ROOT_DIR=%~dp0"
set "TARGET_DIR=%~dp0src"

:: Remove any trailing slashes from the ROOT_DIR variable string for tracking consistency
if "%ROOT_DIR:~-1%"=="\" set "ROOT_DIR=%ROOT_DIR:~0,-1%"

:: 1. Verify requirements.txt exists inside the src folder
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

:: 3. Run pip install using --quiet flags to prevent flooding the screen with "already satisfied" text
python -m pip install --upgrade pip --quiet
python -m pip install -r "%TARGET_DIR%\requirements.txt" --quiet

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

:: 4. Force Python base to lock onto the root path context. The -B flag prevents __pycache__ from spawning.
python -B -c "import os, sys; os.chdir(r'%ROOT_DIR%'); sys.path.insert(0, os.path.join(os.getcwd(), 'src')); import script; script.process_all_batch_reports()"

echo.
echo ---------------------------------------------------
echo [SUCCESS] Batch execution finished.
echo.
pause