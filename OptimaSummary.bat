@echo off
SETLOCAL EnableDelayedExpansion

echo ===================================================
echo   System Automation: Alarm Batch Summary Report
echo ===================================================
echo.

:: Wrap the paths natively in double quotes right at the assignment level
set "ROOT_DIR=%~dp0"
set "TARGET_DIR=%~dp0src"

:: 1. Verify requirements.txt exists inside the src folder using a direct string match
python -c "import os; print(os.path.exists(os.path.join(r'%~dp0src', 'requirements.txt')))" 2>nul | findstr /I "True" >nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Could not find requirements.txt inside the 'src' folder.
    echo Expected Location: %~dp0src\requirements.txt
    echo.
    pause
    exit /b
)

:: 2. Verify script.py exists inside the src folder
python -c "import os; print(os.path.exists(os.path.join(r'%~dp0src', 'script.py')))" 2>nul | findstr /I "True" >nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Could not find script.py inside the 'src' folder.
    echo Expected Location: %~dp0src\script.py
    echo.
    pause
    exit /b
)

echo [INFO] Validating Python environment dependencies...

:: 3. Run pip install using absolute location text bounds to ignore any space limitations
python -m pip install --upgrade pip --quiet
python -m pip install -r "%~dp0src\requirements.txt" --quiet

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

:: 4. Force Python to strip quotes internally using raw string conversion flags
python -B -c "import os, sys; os.chdir(r'%~dp0'); sys.path.insert(0, os.path.join(os.getcwd(), 'src')); import script; script.process_all_batch_reports()"

echo.
echo ---------------------------------------------------
echo [SUCCESS] Batch execution finished.
echo.
pause