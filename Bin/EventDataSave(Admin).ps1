$YesterdayDateFileName = (Get-Date).AddDays(-1).ToString('yyyyMMdd')
$YesterdayDateFilterName = (Get-Date).AddDays(-1).ToString('yyyy-MM-dd')
$pcname= whoami
$ComputerName = $pcname.Split("\")

$AllHistory = @()

Get-Content C:\DeviceTracker\settings.txt | Foreach-Object{
    $var = $_.Split('=')
    New-Variable -Name $var[0] -Value $var[1]
}

$NewItemPath = $LogPath+$YesterdayDateFileName
if (-Not (Test-Path -Path $NewItemPath)){
    New-Item -Path $NewItemPath -ItemType Directory
}
$PrinterAndDriverPath = $NewItemPath + "\DriverAndPrinterFrameworks"+$YesterdayDateFileName+$ComputerName[0]+".csv"

#Add The Condition to fix time
$WindowsDriverSearchData = "*[System[TimeCreated[@SystemTime>='"+$YesterdayDateFilterName+"T00:00:00' and @SystemTime<'"+$YesterdayDateFilterName+"T23:59:59']] and System[(EventID=2003)]]"
$PrintServiceSearchData = "*[System[TimeCreated[@SystemTime>='"+$YesterdayDateFilterName+"T00:00:00' and @SystemTime<'"+$YesterdayDateFilterName+"T23:59:59']] and System[(EventID=307)]]"
#$WindowsDriverSearchData = "*"
#$PrintServiceSearchData = "*"

$WindowsDriverEventLog = wevtutil qe Microsoft-Windows-DriverFrameworks-UserMode/Operational /rd:true /f:Text /q:$WindowsDriverSearchData
$PrintServiceEventLog = wevtutil qe Microsoft-Windows-PrintService/Operational /rd:true /f:Text /q:$PrintServiceSearchData

if($WindowsDriverEventLog -eq $null){
    Write-Host "No driver data to export"
}else{
    $WindowsDriverCharArray = $WindowsDriverEventLog.Split("`r`n")
    for ($i = 0; $i -lt ($WindowsDriverCharArray.Count/15); $i++) {
        $HistoryData = New-Object -TypeName PSObject -Property @{
            User = $ComputerName[1]
            LogType = "Device"
            DateTimeInfo = $WindowsDriverCharArray[($i * 15) + 3] -replace ".*Date: "
            Data = $WindowsDriverCharArray[($i * 15) + 13]
        }
        $AllHistory += $HistoryData
    }
}
if($PrintServiceEventLog -eq $null){
    Write-Host "No printer service data to export"
}else{
    $PrintServiceCharArray =$PrintServiceEventLog.Split("`r`n" )
    for ($i = 0; $i -lt ($PrintServiceCharArray.Count/15); $i++) {
        $HistoryData = New-Object -TypeName PSObject -Property @{
            User = $ComputerName[1]
            LogType = "PrinterService"
            DateTimeInfo = $PrintServiceCharArray[($i * 15) + 3] -replace ".*Date: "
            Data = $PrintServiceCharArray[($i * 15) + 13]
        }
        $AllHistory += $HistoryData
    }
}
$AllHistory | Export-Csv -Encoding UTF8 -Path $PrinterAndDriverPath