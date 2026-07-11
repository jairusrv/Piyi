@echo off
setlocal
cd /d "%~dp0\.."
where python >nul 2>nul
if errorlevel 1 (
  echo ERROR: Python no esta instalado o no esta en PATH.
  exit /b 1
)
echo Paso 1: Auditoria...
python tools\encoding_audit_23.py --root .
echo Paso 2: Reparacion con respaldo...
python tools\encoding_audit_23.py --root . --apply
echo Paso 3: Flutter analyze...
cd piyi_mobile
call flutter analyze --no-fatal-infos
set FLUTTER_EXIT=%ERRORLEVEL%
cd ..
echo Paso 4: Backend...
dotnet build /warnaserror
set DOTNET_EXIT=%ERRORLEVEL%
if not "%FLUTTER_EXIT%"=="0" exit /b %FLUTTER_EXIT%
if not "%DOTNET_EXIT%"=="0" exit /b %DOTNET_EXIT%
echo Sprint 23 aplicado correctamente.
exit /b 0
