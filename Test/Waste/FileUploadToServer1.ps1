$username = "OA010832"

$password = "EwWmtL5N6xtPYgnF" | ConvertTo-SecureString -AsPlainText -Force

$server = "54.238.150.121"

$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList
  $username,$password

Get-SFTPSession | Remove-SFTPSession

$SFTPSession=New-SFTPSession -ComputerName $server -Credential $credential -Port 22

$FilePath = get-childitem "C:\PrintAndDriverFrameLog\"

$SftpPath = '/local/test/printservicetest/'

ForEach ($LocalFile in $FilePath)
{
Set-SFTPFile -SessionId $SFTPSession.SessionID -LocalFile $LocalFile.fullname -RemotePath $SftpPath -Overwrite
}