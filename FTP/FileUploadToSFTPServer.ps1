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

# $Credential: Set the credentials
# $LocalPath/$SftpPath: Set local file path, SFTP path, and the backup location path which I assume is an SMB path
# $SftpIp: Set the IP of the SFTP server
# Import-Module:  Load the Posh-SSH module
# $ThisSession: Establish the SFTP connection