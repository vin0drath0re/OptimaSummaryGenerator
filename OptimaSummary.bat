@echo off
:: Create a temporary drive letter mapping if on a network UNC path, and set as working directory
pushd "%~dp0"

SETLOCAL EnableDelayedExpansion

echo ===================================================
echo   System Automation: Alarm Batch Summary Report
echo ===================================================
echo.

set "REQ_NAME=requirements.txt"
set "SCRIPT_PATH=src\script.py"

:: 1. Verify requirements.txt is adjacent to the bat file
if not exist "%REQ_NAME%" (
    echo [ERROR] Could not find %REQ_NAME% in the current directory.
    echo Please make sure %REQ_NAME% is in the same folder as this BAT file.
    echo.
    popd
    pause
    exit /b
)

:: 2. Verify script.py is inside the src folder
if not exist "%SCRIPT_PATH%" (
    echo [ERROR] Could not find your python script at: %SCRIPT_PATH%
    echo Please ensure your script is saved exactly as src\script.py
    echo.
    popd
    pause
    exit /b
)

echo [INFO] Validating Python environment dependencies...

:: Check if packages are already fulfilled
python -c "import pkg_resources; pkg_resources.require(open(r'%REQ_NAME%').read().splitlines())" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo [WARN] Missing or outdated dependencies detected.
    echo [INFO] Installing required packages from '%REQ_NAME%'...
    echo.
    
    python -m pip install --upgrade pip
    python -m pip install -r "%REQ_NAME%"
    
    if !ERRORLEVEL! NEQ 0 (
        echo.
        echo [ERROR] Dependency installation failed. Please check your internet connection.
        popd
        pause
        exit /b
    )
    echo.
    echo [SUCCESS] Dependencies successfully configured.
) else (
    echo [SUCCESS] All Python requirements are already satisfied.
)

echo.
echo [INFO] Launching Summary Generator...
echo ---------------------------------------------------
echo.

:: 3. Execute the python script safely
cmd /c python "%SCRIPT_PATH%"

echo.
echo ---------------------------------------------------
echo [SUCCESS] Batch execution finished.
echo.

:: Clean up and delete the temporary drive letter mapping (if one was created)
popd
pause