@echo off
setlocal enabledelayedexpansion
title ContinuAI - Starting Server...

:: Change working directory to the folder containing this batch script
cd /d "%~dp0"

:: Sync root index.html to static\index.html if an updated index.html exists in root
if exist "index.html" (
    if not exist "static" mkdir "static"
    copy /y "index.html" "static\index.html" >nul 2>&1
)

echo ===================================================
echo               Starting ContinuAI
echo ===================================================
echo.

:: 1. Check if Python is installed and accessible
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python was not found in your system PATH!
    echo Please install Python 3.10 or newer from https://www.python.org/
    echo During installation, make sure to check "Add Python to PATH".
    echo.
    pause
    exit /b 1
)

:: 2. Check or create the virtual environment
if not exist ".venv\Scripts\activate.bat" (
    echo [*] Setting up virtual environment .venv...
    python -m venv .venv
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to create virtual environment.
        pause
        exit /b 1
    )
    echo [*] Virtual environment created successfully.
)

:: 3. Activate the virtual environment
echo [*] Activating virtual environment...
call .venv\Scripts\activate.bat

:: 4. Check and install dependencies
echo [*] Checking dependencies from requirements.txt...
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo [WARNING] Dependency installation encountered an issue. Attempting to start anyway...
)

:: 5. Launch the application
echo.
echo ===================================================
echo  ContinuAI server is starting!
echo  URL: http://localhost:5000
echo  Press Ctrl+C in this window to stop the server.
echo ===================================================
echo.

:: Launch the web browser to the application URL
start "" "http://localhost:5000"

:: Start the Flask backend server
python app.py

:: Keep window open if the process terminates
echo.
echo [INFO] ContinuAI server has stopped.
pause
