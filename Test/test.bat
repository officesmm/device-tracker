@echo off
setlocal
for /F "tokens=2 delims==" %%a in ('findstr /I "message=" settings.txt') do set "uniuser=%%a"  
powershell -ExecutionPolicy Bypass -File %uniuser%