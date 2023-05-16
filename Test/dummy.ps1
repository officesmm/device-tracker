$scriptPath = $PSScriptRoot
Write-Host "1 The absolute path of the .ps1 file location is: $scriptPath"

$scriptPath2 = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
Write-Host "2 The absolute path of the .ps1 file location is: $scriptPath2"

$scriptPath3 = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$parentPath = Split-Path -Parent -Path $scriptPath3
Write-Host "3 The absolute path of the parent directory is: $parentPath"