function InstallerCheck($GapDate){
    $YesterdayDateFileName = (Get-Date).AddDays($GapDate).ToString('yyyyMMdd')
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

    $scriptPathLocal = $PSScriptRoot
    $parentPathLocal = Split-Path -Parent -Path $scriptPathLocal
    $thePath = Join-Path $parentPathLocal 'settings.txt'

    (Get-Content $thePath) | Foreach-Object{
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
}

$file = Join-Path $PSScriptRoot 'lastrun.txt'

$YesterdayDateFileName = (Get-Date).AddDays(-1).ToString('yyyyMMdd')
$VariableList = Get-Content -Raw $file | ConvertFrom-StringData
$HistoryVar = $VariableList.InstallerHistory

if($HistoryVar -match "^[\d\.]+$"){
    $Today = Get-Date
    $PreviousDate = [datetime]::ParseExact($HistoryVar, 'yyyyMMdd', $null)
    $Gap = $Today - $PreviousDate
    $dateGap = $Gap.Days - 1
    if($dateGap -gt 7){
        $dateGap = 7
    }
}else{
    $dateGap = 7
}
while ($dateGap -ge 1){
    $gettingDatetoRun = -1 * ($dateGap);
    InstallerCheck $gettingDatetoRun
    $runningDate  = (Get-Date).AddDays($gettingDatetoRun).ToString('yyyyMMdd')
    Write-Host "$runningDate is running"
    $dateGap --
}

(Get-Content $file -Encoding utf8) | ForEach-Object {
    if ($_ -match "^InstallerHistory=") {
        "InstallerHistory=$YesterdayDateFileName"
    } else {
        $_
    }
} | Set-Content $file -Encoding utf8
