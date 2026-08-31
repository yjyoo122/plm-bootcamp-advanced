@echo off
REM Double-click to publish the ADVANCED module from the OneDrive folder.
REM Or drag an .html file onto this file to publish that specific one.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0publish.ps1" -SourceFile "%~1"
echo.
pause
