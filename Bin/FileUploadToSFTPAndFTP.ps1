$wifiName = (get-netconnectionProfile).Name
if ($wifiName -eq "JP_Hundsun_5G_R&D"){
    Write-Output "connecting local server"
    $source = "C:\SecurityLog"
    $destination = "ftp://onepay:onepay001@192.168.0.77:21//Public"
    $webclient = New-Object -TypeName System.Net.WebClient
    $files = Get-ChildItem $source
    foreach ($file in $files){
        $webclient.UploadFile("$destination/$file", $file.FullName)
    }
    $webclient.Dispose()
}else{
    Write-Output "connecting public wifi"
    $Password = ConvertTo-SecureString 'EwWmtL5N6xtPYgnF' -AsPlainText -Force
    $Credential = New-Object System.Management.Automation.PSCredential ('OA010832', $Password)
    $LocalPath = get-childitem "C:\SecurityLog\"
    $SftpPath = '/local/test/printservicetest'
    $SftpIp = '54.238.150.121'
    Import-Module 'C:\Program Files\WindowsPowerShell\Modules\Posh-SSH'
    $ThisSession = New-SFTPSession -ComputerName $SftpIp -Credential $Credential -Port 22 -AcceptKey
    ForEach ($Ele in $LocalPath) {
        Set-SFTPItem -SessionId $ThisSession.SessionId -Path $Ele.fullname -Destination $SftpPath -Force
    }
}
