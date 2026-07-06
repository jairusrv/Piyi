@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0..\..\piyi_mobile"

powershell -ExecutionPolicy Bypass -File "..\tools\mobile\increment_build.ps1"

call flutter clean
call flutter pub get
call flutter test
call flutter build apk --release --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com

if not exist "..\release" mkdir "..\release"

for /f "tokens=2 delims=+" %%a in ('findstr /R "^version:" pubspec.yaml') do set BUILD=%%a
copy /Y "android\app\build\outputs\apk\release\app-release.apk" "..\release\Piyi_Beta_build_!BUILD!.apk"

echo.
echo APK generado:
echo C:\Users\jairo\Documents\Piyi\release\Piyi_Beta_build_!BUILD!.apk

endlocal
pause
