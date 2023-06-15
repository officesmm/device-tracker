$scriptPathLocal = $PSScriptRoot
$filePath = Join-Path $scriptPathLocal "lastrun.txt"
$newContent = @"
BrowserHistory=null
DeviceHistory=null
InstallerHistory=null
AllInstaller=null
"@

try {
    Set-Content -Path $filePath -Value $newContent -Force
    Write-Host "File 'lastrun.txt' overwritten successfully."
} catch {
    Write-Host "An error occurred while overwriting the file: $($_.Exception.Message)"
}
