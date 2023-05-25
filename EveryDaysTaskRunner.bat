cd C:/DeviceTracker/
@echo off
setlocal
for /F "tokens=2 delims==" %%a in ('findstr /I "EventDataSave=" settings.txt') do set "uniuser=%%a"
powershell -ExecutionPolicy Bypass -File %uniuser%

setlocal
for /F "tokens=2 delims==" %%a in ('findstr /I "NewBrowserHistoryAll=" settings.txt') do set "uniuser=%%a"
powershell -ExecutionPolicy Bypass -File %uniuser%

setlocal
for /F "tokens=2 delims==" %%a in ('findstr /I "InstallerCheck=" settings.txt') do set "uniuser=%%a"
powershell -ExecutionPolicy Bypass -File %uniuser%

setlocal
for /F "tokens=2 delims==" %%a in ('findstr /I "FileUploadToSFTPAndFTP=" settings.txt') do set "uniuser=%%a"
powershell -ExecutionPolicy Bypass -File %uniuser%
