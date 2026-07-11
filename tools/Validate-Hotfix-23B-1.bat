@echo off
setlocal
cd /d "%~dp0\.."

echo Validando backend...
dotnet build /warnaserror
if errorlevel 1 exit /b 1

echo Validando Flutter...
cd piyi_mobile
call flutter analyze --no-fatal-infos
if errorlevel 1 exit /b 1

echo Validacion completada correctamente.
exit /b 0
