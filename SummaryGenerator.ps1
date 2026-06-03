# Set console encoding to UTF-8 to ensure clean text output rendering
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "   System Automation: Alarm Batch Summary Report" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host ""

# Define file names and paths based on the root folder structure
$ReqName = "requirements.txt"
$ScriptPath = "src\script.py"

# 1. Verify requirements.txt exists next to this script
if (-not (Test-Path $ReqName)) {
    Write-Host "[ERROR] Could not find $ReqName in the current directory." -ForegroundColor Red
    Write-Host "Please make sure $ReqName is in the same folder as this PowerShell script.`n" -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    Exit
}

# 2. Verify script.py exists inside the src folder
if (-not (Test-Path $ScriptPath)) {
    Write-Host "[ERROR] Could not find your python script at: $ScriptPath" -ForegroundColor Red
    Write-Host "Please ensure your script is saved exactly as src\script.py`n" -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    Exit
}

Write-Host "[INFO] Validating Python environment dependencies..." -ForegroundColor Yellow

# 3. Check if packages are already fulfilled using Python
python -c "import pkg_resources; pkg_resources.require(open(r'$ReqName').read().splitlines())" 2>$null

if ($LASTEXITCODE -ne 0) {
    Write-Host "[WARN] Missing or outdated dependencies detected." -ForegroundColor Yellow
    Write-Host "[INFO] Installing required packages from '$ReqName'..." -ForegroundColor Blue
    Write-Host ""
    
    # Upgrade pip and install requirements
    python -m pip install --upgrade pip
    python -m pip install -r $ReqName
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "`n[ERROR] Dependency installation failed. Please check your internet connection." -ForegroundColor Red
        Read-Host "Press Enter to exit..."
        Exit
    }
    Write-Host "`n[SUCCESS] Dependencies successfully configured." -ForegroundColor Green
} else {
    Write-Host "[SUCCESS] All Python requirements are already satisfied." -ForegroundColor Green
}

Write-Host "`n[INFO] Launching Summary Generator..." -ForegroundColor Blue
Write-Host "---------------------------------------------------"
Write-Host ""

# 4. Explicitly execute the python script
python $ScriptPath

Write-Host ""
Write-Host "---------------------------------------------------"
Write-Host "[SUCCESS] Script execution finished.`n" -ForegroundColor Green

Read-Host "Press Enter to close this window..."