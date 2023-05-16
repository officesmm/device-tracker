$file = 'C:\DeviceTracker\Test\variables.txt'

$YesterdayDateFileName = (Get-Date).AddDays(-1).ToString('yyyyMMdd')
$VariableList = Get-Content -Raw $file | ConvertFrom-StringData
$TestVar = $VariableList.testvar

if($TestVar -match "^[\d\.]+$"){
    $dateGap = $YesterdayDateFileName - $TestVar
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
    if ($_ -match "^testvar=") {
        "testvar=$YesterdayDateFileName"
    } else {
        $_
    }
} | Set-Content $file -Encoding utf8
