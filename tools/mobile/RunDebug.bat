@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0..\..\piyi_mobile"

powershell -ExecutionPolicy Bypass -File "..\tools\mobile\increment_build.ps1"

call flutter pub get
call flutter run --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com

endlocal
