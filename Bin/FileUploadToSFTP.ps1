$wifiList = @('JP_Hundsun_5G_R&D', 'JP_Hundsun_9F_Plus', 'JP_Hundsun_9F_Pro','JP_Hundsun_Guest')

Get-Content C:\DeviceTracker\settings.txt | Foreach-Object{
    $var = $_.Split('=')
    New-Variable -Name $var[0] -Value $var[1]
}
[bool]$AvailableWifi = $false
$wifiName = (get-netconnectionProfile).Name

$ContainsPrefix = $wifiList | Where-Object { $wifiName -like "$_*" }

if ($ContainsPrefix)
{
    Write-Output "connecting local server"
    $wifiName
    $Password = ConvertTo-SecureString 'onepay001' -AsPlainText -Force
    $Credential = New-Object System.Management.Automation.PSCredential ('onepay', $Password)
    $LocalPath = get-childitem $LogPath
    $SftpPath = '/Public/test/securitylog'
    $SftpIp = '192.168.0.77'
    Import-Module 'C:\Program Files\WindowsPowerShell\Modules\Posh-SSH'
    $ThisSession = New-SFTPSession -ComputerName $SftpIp -Credential $Credential -Port 2836 -AcceptKey
    ForEach ($Ele in $LocalPath) {
        Set-SFTPItem -SessionId $ThisSession.SessionId -Path $Ele.fullname -Destination $SftpPath -Force
    }
}
else
{
    Write-Output "WIFI DO NOT CONNECT LOCAL COMPANY WIFI."
    $wifiName
}
