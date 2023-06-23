C:
cd C:/DeviceTracker/
@echo off
setlocal enabledelayedexpansion
for /F "tokens=2 delims==" %%a in ('findstr /I "EnableOperation=" settings.txt') do set "uniuser=%%a"
powershell -ExecutionPolicy Bypass -File %uniuser%
setlocal enabledelayedexpansion
for /F "tokens=2 delims==" %%a in ('findstr /I "ActionScheduler=" settings.txt') do set "uniuser=%%a"
powershell -ExecutionPolicy Bypass -File %uniuser%