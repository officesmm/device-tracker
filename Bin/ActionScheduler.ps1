$trigger = New-ScheduledTaskTrigger -Daily -At 12:00

$scriptPathLocal = $PSScriptRoot
$parentPathLocal = Split-Path -Parent -Path $scriptPathLocal
$TheTaskRunnerPath = Join-Path $parentPathLocal 'EveryDaysTaskRunner.bat'

$nextFilePath = $TheTaskRunnerPath
$action = New-ScheduledTaskAction -Execute $nextFilePath
$task = Register-ScheduledTask -TaskName "Device Tracker in Progress" -Trigger $trigger -Action $action -Force
$task.Triggers.Repetition.Duration = "P1D"
$task | Set-ScheduledTask

#editing EveryDaysTaskRunner Bat
$file = Join-Path $parentPathLocal "EveryDaysTaskRunner.bat"
$content = Get-Content $file
$content[0] = $parentPathLocal[0] + ":"
$content[1] = "cd "+ $parentPathLocal +"\"
$content | Set-Content $file

#add path to the sqlite3 extension
$newPath = "C:\SQLite3\sqlite-tools-win32-x86-3380500"
$currentPath = [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::Machine)
if ($currentPath -split ';' -contains $newPath) {
    Write-Host "SQLite Env Path is already present."
} else {
    $updatedPath = "$currentPath;$newPath"
    [Environment]::SetEnvironmentVariable("PATH", $updatedPath, [EnvironmentVariableTarget]::Machine)
    Write-Host "SQLite Env Path is added to the Environment variable."
}
