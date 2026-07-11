@echo off
setlocal
cd /d "%~dp0\.."

powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\Apply-Sprint-23B.ps1"
if errorlevel 1 exit /b 1

dotnet build /warnaserror
if errorlevel 1 exit /b 1

cd piyi_mobile
call flutter analyze --no-fatal-infos
if errorlevel 1 exit /b 1

echo Sprint 23B aplicado correctamente.
exit /b 0
