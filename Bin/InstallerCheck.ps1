$Software = @()
$Code = @()
Import-Csv C:\DeviceTracker\SoftwareList.csv -delimiter "," |`
    ForEach-Object {
    $Software += $_."Software"
    $Code += $_."Code"
}
$SoftwareList = @()
for ($i = 0; $i -lt $Software.Count; $i++) {
    $SoftwareList += [pscustomobject]@{Name=$Software[$i];Code=$Code[$i]}
}

$pcname = whoami
$ComputerName = $pcname.Split("\")
$YesterdayDateFileName = (Get-Date).AddDays(-1).ToString('yyyyMMdd')

Get-Content C:\DeviceTracker\settings.txt | Foreach-Object{
    $var = $_.Split('=')
    New-Variable -Name $var[0] -Value $var[1]
}

$NewItemPath = $LogPath + $YesterdayDateFileName
if (-Not(Test-Path -Path $NewItemPath)){
    New-Item -Path $NewItemPath -ItemType Directory
}
$SoftwareInstalledHistoryFilePath = $NewItemPath + "\SoftwareHistory" + $YesterdayDateFileName + $ComputerName[0] + ".csv"

$CurrentTime = Get-Date
$AllHistory = @()

For ($i=0; $i -lt $SoftwareList.Length; $i++) {
    $EleCode = $SoftwareList[$i].Code
    $EleName = $SoftwareList[$i].Name
    if(Get-AppxPackage -Name $EleCode){
        $HistoryData = New-Object -TypeName PSObject -Property @{
            Software = $EleName
            Result = 'installed'
            PCName = $ComputerName[0]
            RunTime = $CurrentTime
            InstalledTime = 'N/A'
            Comment= ''
        }
    }
    else{
        $HistoryData = New-Object -TypeName PSObject -Property @{
            Software = $EleName
            Result = 'not installed'
            PCName = $ComputerName[0]
            RunTime = $CurrentTime
            InstalledTime = 'N/A'
            Comment= ''
        }
    }
    $AllHistory += $HistoryData
}
$AllHistory | Export-Csv -Encoding UTF8 -Path $SoftwareInstalledHistoryFilePath
