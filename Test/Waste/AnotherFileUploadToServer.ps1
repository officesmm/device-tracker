# Set the credentials
$Password = ConvertTo-SecureString 'onepay001' -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ('onepay', $Password)

# Set local file path, SFTP path, and the backup location path which I assume is an SMB path
$LocalPath = get-childitem "C:\PrintAndDriverFrameLog\"
$FilePath = "C:\PrintAndDriverFrameLog\file.txt"
$SftpPath = '/Home/Test'

# Set the IP of the SFTP server
$SftpIp = '192.168.0.77'

# Load the Posh-SSH module
Import-Module 'C:\Program Files\WindowsPowerShell\Modules\Posh-SSH'

# Establish the SFTP connection
$ThisSession = New-SFTPSession -ComputerName $SftpIp -Credential $Credential -Port 21 -AcceptKey
ForEach ($Ele in $LocalPath)
{
    Set-SFTPItem -SessionId $ThisSession.SessionId -Path $Ele.fullname -Destination $SftpPath -Force
}
# Upload the file to the SFTP path
#Set-SFTPItem -SessionId $ThisSession.SessionId -Path $FilePath -Destination $SftpPath -Force

#set-sftpitem -SessionId $SFTPSession.SessionID -Path $Ele.fullname -Destination $SftpPath -Force

#Disconnect all SFTP Sessions
#Get-SFTPSession | % { Remove-SFTPSession -SessionId ($_.SessionId) }

# Copy the file to the SMB location
#Copy-Item -Path $FilePath -Destination $SmbPath