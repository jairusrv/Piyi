@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0..\..\piyi_mobile"

echo === Piyi RC1 build ===
call flutter clean
powershell -Command "Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue"
powershell -Command "Remove-Item pubspec.lock -Force -ErrorAction SilentlyContinue"

call flutter pub get
if errorlevel 1 exit /b 1

call flutter analyze --no-fatal-infos
if errorlevel 1 exit /b 1

call flutter build apk --release --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com
if errorlevel 1 exit /b 1

call flutter build appbundle --release --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com
if errorlevel 1 exit /b 1

cd /d "%~dp0..\.."
if not exist release mkdir release
copy /Y "piyi_mobile\android\app\build\outputs\apk\release\app-release.apk" "release\Piyi_RC1.apk"
copy /Y "piyi_mobile\build\app\outputs\bundle\release\app-release.aab" "release\Piyi_RC1.aab"

echo.
echo RC1 generado:
echo release\Piyi_RC1.apk
echo release\Piyi_RC1.aab
pause
