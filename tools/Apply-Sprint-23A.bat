@echo off
setlocal
cd /d "%~dp0\.."

powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\Apply-Sprint-23A.ps1"
if errorlevel 1 (
  echo ERROR: Fallo la auditoria de encoding.
  exit /b 1
)

cd piyi_mobile

call flutter analyze --no-fatal-infos
if errorlevel 1 (
  echo ERROR: flutter analyze fallo.
  exit /b 1
)

call flutter build apk --release --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com
if errorlevel 1 (
  echo ERROR: build APK fallo.
  exit /b 1
)

cd ..
dotnet build /warnaserror
if errorlevel 1 (
  echo ERROR: dotnet build fallo.
  exit /b 1
)

echo Sprint 23A completado correctamente.
exit /b 0
