$trigger = New-ScheduledTaskTrigger -Daily -At 12:00

$scriptPathLocal = $PSScriptRoot
$TheTaskRunnerPath = Join-Path $scriptPathLocal 'EveryDaysTaskRunner.bat'

$nextFilePath = $TheTaskRunnerPath
$action = New-ScheduledTaskAction -Execute $nextFilePath
$task = Register-ScheduledTask -TaskName "Device Tracker in Progress" -Trigger $trigger -Action $action -Force
$task.Triggers.Repetition.Duration = "P1D"
$task | Set-ScheduledTask