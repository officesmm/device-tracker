#Get-AppxPackage -name Facebook.InstagramBeta
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
$SoftwareList
#$SoftwareList = @(
#[pscustomobject]@{Name='Facebook';Code='FACEBOOK.FACEBOOK'}
#[pscustomobject]@{Name='Line'; Code='NAVER.LINEwin8'}
#[pscustomobject]@{Name='TikTok'; Code='BytedancePte.Ltd.TikTok'}
#[pscustomobject]@{Name='Instagram'; Code='Facebook.InstagramBeta'}
#)
#
#$Software
#$Code