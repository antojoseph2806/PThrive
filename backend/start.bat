@echo off
echo Starting PThrive Backend Server...
echo.

if not exist node_modules (
    echo Installing dependencies...
    call npm install
    echo.
)

if not exist .env (
    echo WARNING: .env file not found!
    echo Please copy .env.example to .env and configure your Supabase credentials
    echo.
    pause
    exit /b 1
)

echo Starting server on port 3000...
call npm run dev
