function AllInstallerCheck($GapDate)
{
    $softwarePrefixList = @('Microsoft')
    $ContainsPrefix = $softwarePrefixList | Where-Object { $wifiName -like "$_*" }

    $YesterdayDateFileName = (Get-Date).AddDays($GapDate).ToString('yyyyMMdd')

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
    $SoftwareInstalledHistoryFilePath = $NewItemPath + "\AllInstaller" + $YesterdayDateFileName + $ComputerName[0] + ".csv"


    $CurrentTime = Get-Date
    $InstallerList = @()
    $InstallerList1 = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | select-object DisplayName, InstallDate
    For ($i = 0; $i -lt $InstallerList1.Length; $i++) {
        $ContainsPrefix = $softwarePrefixList | Where-Object { $InstallerList1[$i].DisplayName -like "$_*" }
        if(-Not $ContainsPrefix){
            $InstallerTemp = New-Object -TypeName PSObject -Property @{
                SoftwareName = $InstallerList1[$i].DisplayName
                RunTime = $CurrentTime
                InstallDate = $InstallerList1[$i].InstallDate
            }
            $InstallerList += $InstallerTemp
        }
    }
    $InstallerList2  = AppxPackage
    For ($i = 0; $i -lt $InstallerList2.Length; $i++) {
        $ContainsPrefix = $softwarePrefixList | Where-Object { $InstallerList2[$i].Name -like "$_*" }
        if(-Not $ContainsPrefix){
            $InstallerTemp = New-Object -TypeName PSObject -Property @{
                SoftwareName = $InstallerList2[$i].Name
                RunTime = $CurrentTime
            }
            $InstallerList += $InstallerTemp
        }
    }
    $InstallerList | Export-Csv -Encoding UTF8 -Path $SoftwareInstalledHistoryFilePath
}

$file = Join-Path $PSScriptRoot 'lastrun.txt'

$YesterdayDateFileName = (Get-Date).AddDays(-1).ToString('yyyyMMdd')
$VariableList = Get-Content -Raw $file | ConvertFrom-StringData
$HistoryVar = $VariableList.AllInstaller

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
    AllInstallerCheck $gettingDatetoRun
    $runningDate  = (Get-Date).AddDays($gettingDatetoRun).ToString('yyyyMMdd')
    Write-Host "$runningDate is running"
    $dateGap --
}

(Get-Content $file -Encoding utf8) | ForEach-Object {
    if ($_ -match "^AllInstaller=") {
        "AllInstaller=$YesterdayDateFileName"
    } else {
        $_
    }
} | Set-Content $file -Encoding utf8


