@echo off
setlocal enabledelayedexpansion

:: Start Logging
set logFile=setup_log.txt
echo "***** Trading Bot Setup Script Started ***** %logFile%"" > "%logFile%"
echo **

echo "Logging to %logFile%"" 
echo **

:: Track Execution Time Using %TIME%
set startTime=%TIME%

:: 1. Navigate to Project Directory
echo "Step 1: Navigating to Project Directory... %logFile%"" >> "%logFile%"
echo **

set projectDir=C:\Users\ethan\OneDrive\Desktop

if exist "%projectDir%" (
    cd /d "%projectDir%"
    echo "Successfully navigated to %projectDir% %logFile%"" >> "%logFile%"
) else (
    echo "Error: Directory %projectDir% not found. Exiting script. %logFile%"" >> "%logFile%"
    echo **
    exit /b 1
)
echo "***** %logFile%"" >> "%logFile%"
echo **

:: 2. Check if Virtual Environment Exists & Activate
echo "Step 2: Checking & Activating Virtual Environment... %logFile%"" >> "%logFile%"
echo **

set venvPath=%projectDir%\trading_env\Scripts\activate.bat

if exist "%venvPath%" (
    echo "Found virtual environment, activating... %logFile%"" >> "%logFile%"
    echo **
    call "%venvPath%"
    echo "Virtual environment activated successfully. %logFile%"" >> "%logFile%"
) else (
    echo "Error: Virtual environment not found. Creating a new one... %logFile%"" >> "%logFile%"
    echo **
    python -m venv trading_env
    if exist "%venvPath%" (
        echo "New virtual environment created. Activating... %logFile%"" >> "%logFile%"
        echo **
        call "%venvPath%"
        echo "Virtual environment activated successfully. %logFile%"" >> "%logFile%"
    ) else (
        echo "Failed to create virtual environment. Exiting. %logFile%"" >> "%logFile%"
        echo **
        exit /b 1
    )
)
echo "***** %logFile%"" >> "%logFile%"
echo **

:: 3. Ensure Python is Installed & Display Version
echo "Step 3: Checking Python Installation... %logFile%"" >> "%logFile%"
echo **

python --version > nul 2>&1
if %errorlevel% neq 0 (
    echo "Error: Python is not installed or not in PATH. Exiting. %logFile%"" >> "%logFile%"
    echo **
    exit /b 1
) else (
    for /f "tokens=2 delims= " %%I in ('python --version') do set pythonVersion=%%I
    echo "Python Version Detected: %pythonVersion% %logFile%"" >> "%logFile%"
)
echo "***** %logFile%"" >> "%logFile%"
echo **

:: 4. Install Dependencies (Only If Missing)
echo "Step 4: Installing Missing Dependencies... %logFile%"" >> "%logFile%"
echo **

set dependencies=ccxt numpy pandas backtrader torch matplotlib

for %%p in (%dependencies%) do (
    pip show %%p > nul 2>&1
    if errorlevel 1 (
        echo "Installing %%p... %logFile%"" >> "%logFile%"
        echo **
        pip install %%p >> "%logFile%" 2>&1
    ) else (
        echo "%%p is already installed. %logFile%"" >> "%logFile%"
        echo **
    )
)
echo "All dependencies are installed. %logFile%"" >> "%logFile%"
echo **

echo "***** %logFile%"" >> "%logFile%"
echo **

:: 5. Run Imports Test Script
echo "Step 5: Running Imports Test Script... %logFile%"" >> "%logFile%"
echo **

python -c "import ccxt, pandas, numpy, torch, backtrader; print('Setup successful!')"

echo **
echo "Step 6: Activating Environment... %logFile%"" >> "%logFile%"
echo **
call trading_env\Scripts\activate

echo "***** %logFile%"" >> "%logFile%"
echo **

pip install cdp ccxt numpy pandas backtrader torch matplotlib


echo **
echo "Step 7: Configuring CDP SDK w/ API Credentials... %logFile%"" >> "%logFile%"
echo **
python ConfigureCDPCreds.py

echo **
echo "Step 8: Starting Python & Importing ... %logFile%"" >> "%logFile%"
echo **

echo "***** %logFile%"" >> "%logFile%"
echo **

:: Calculate Execution Time Using %TIME%
set endTime=%TIME%
echo "Start Time: %startTime% %logFile%"" >> "%logFile%"
echo **
echo "End Time: %endTime% %logFile%"" >> "%logFile%"
echo **

echo "Script completed. %logFile%"" >> "%logFile%"
echo **

echo "===== Trading Bot Setup Complete ===== %logFile%"" >> "%logFile%"
echo **

cmd /k
exit /b 0