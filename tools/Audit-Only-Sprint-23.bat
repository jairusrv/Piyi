@echo off
cd /d "%~dp0\.."
python tools\encoding_audit_23.py --root .
exit /b %ERRORLEVEL%
