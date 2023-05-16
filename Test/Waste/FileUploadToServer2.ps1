# Define Server Name
$ComputerName = "54.238.150.121"

# Define UserName
$username = "OA010832"

#$password = "EwWmtL5N6xtPYgnF"
$encrypted = "01000000d08c9ddf0115d1118c7a00c04fc297eb01000000581372cb316fb94583205e54a129f4ac00000000020000000000106600000001000020000000fd8e8291c98ae10eeffc6dbada32b248212b05bd40282237db160d4e8e2326e2000000000e8000000002000020000000a2cb0d7a7bee98587507ad7be375e474f677b8b7503c26ef6c9a8997022d844830000000dbc90d96413afd1c38f62465f6cca737be4d2420b51434c19ec2712360de6dfb842cd6e7d76fac8389c8b514a43ae8b040000000b5be2b776a32bbdb13a815ae4507ca6eb9b65a32cdf766a15e62e93cf92050a71f0e208414384f7c0a024d663a7a9fb5e72f99df8d9f398e5c795aa85736f369"

$password = ConvertTo-SecureString -String $encrypted

#Set Credetials to connect to server
$Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $username, $password

# Set local file path and SFTP path
$LocalPath = get-childitem "C:\PrintAndDriverFrameLog\"
$SftpPath = '/local/test/printservicetest/'

# Establish the SFTP connection
$SFTPSession = New-SFTPSession -ComputerName $ComputerName -Credential $Credential -Port 22 -AcceptKey

# lists directory files into variable
#$FilePath = Get-SFTPChildItem -sessionID $SFTPSession.SessionID -path $SftpPath

#For each file listed in the directory below copies the files to the local directory and then deletes them from the SFTP one at a time looped until all files
#have been copied and deleted
ForEach ($Ele in $LocalPath)
{
#    Set-SFTPItem $SFTPSession.Index $Ele.Name
    set-sftpitem -SessionId $SFTPSession.SessionID -Path $Ele.fullname -Destination $SftpPath -Force
}
#Terminates the SFTP session on the server
Remove-SFTPSession -SessionId $SFTPSession.SessionID