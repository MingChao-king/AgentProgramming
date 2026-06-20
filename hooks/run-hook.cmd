@echo off
REM Run a hook script from the hooks directory
REM Usage: run-hook.cmd <hook-name>

setlocal enabledelayedexpansion

set "HOOK_NAME=%~1"
set "SCRIPT_DIR=%~dp0"
set "PLUGIN_ROOT=%SCRIPT_DIR%.."

REM Try Git Bash first
if exist "C:\Program Files\Git\bin\bash.exe" (
    "C:\Program Files\Git\bin\bash.exe" "%SCRIPT_DIR%%HOOK_NAME%"
    exit /b %ERRORLEVEL%
)

REM Fall back to finding bash in PATH
where bash >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    bash "%SCRIPT_DIR%%HOOK_NAME%"
    exit /b %ERRORLEVEL%
)

REM If no bash, output raw JSON directly
echo No bash found - using fallback JSON output
if "%HOOK_NAME%"=="session-start" (
    echo { "hookSpecificOutput": { "hookEventName": "SessionStart", "additionalContext": "SuperProgramming methodology loaded (bash unavailable - full skill content not injected). Use Skill tool to invoke 'superprogramming:using-agent-programming'." } }
)

exit /b 0
