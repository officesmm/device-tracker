$file = Join-Path $PSScriptRoot 'variables.txt'

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