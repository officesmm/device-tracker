# Define Server Name
$ComputerName = "192.168.0.77"

# Define UserName
$username = "onepay"

#$password = "onepay001"
$encrypted = "01000000d08c9ddf0115d1118c7a00c04fc297eb01000000581372cb316fb94583205e54a129f4ac00000000020000000000106600000001000020000000391e6322c6baa54bb214c49bc520d7ce7672ee1931423b09f7b4cbd6952e8b2f000000000e8000000002000020000000de11112ddbcae8d60861156c3353846bd9f2c38f27fb5c8274645ae0e0f3d90d20000000eb73603c620eeca080c45ed5d308d2350e6da710b74e0e7d814dfd19ddf56efe40000000e8005db11f1421910a19d7604a1c099289b81f84bfcf091d40312cf9845ada0933cb9f4724318b5c24079b3d76453b383f9ce435d3719ebf9b036843f93cdc52"

$password = ConvertTo-SecureString -String $encrypted

#Set Credetials to connect to server
$Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $username, $password

# Set local file path and SFTP path
$LocalPath = get-childitem "C:\PrintAndDriverFrameLog\"
$SftpPath = '/Home/Test/'

# Establish the SFTP connection
$SFTPSession = New-SFTPSession -ComputerName $ComputerName -Credential $Credential -Port 21 -AcceptKey

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