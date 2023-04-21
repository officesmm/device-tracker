$WindowsDriverSearchData = "*"

$eventLog = wevtutil qe Microsoft-Windows-DriverFrameworks-UserMode/Operational /rd:true /f:Text /q:$WindowsDriverSearchData
$CharArray =$eventLog.Split("`r`n" )

$AllHistory = @()
for ($i = 0; $i -lt ($CharArray.Count/15); $i++) {
    $HistoryData = New-Object -TypeName PSObject -Property @{
        User = "Default"
        LogType = "Device"
        DateTimeInfo = $CharArray[($i * 15) + 3] -replace ".*Date: "
        Data = $CharArray[($i * 15) + 13]
    }
    $AllHistory += $HistoryData
}
$AllHistory | Export-Csv -Encoding UTF8 -Path C:\temp\OtherData.csv
