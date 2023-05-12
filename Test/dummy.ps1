#Get-AppxPackage
Get-Content C:\DeviceTracker\settings.txt | Foreach-Object{
    $var = $_.Split('=')
    New-Variable -Name $var[0] -Value $var[1]
}