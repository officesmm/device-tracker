$DestServerIP = '54.238.150.121'
$user = "OA010832"
$pass = "EwWmtL5N6xtPYgnF"
$LocalPath = "C:\PrintAndDriverFrameLog\DriverFrame.txt"
$RemotePath = '/local/test/printservicetest/'

try
{
    $secpasswd = ConvertTo-SecureString $pass -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential ($user, $secpasswd)
    # Opening a new SFTP session
    $session = New-SFTPSession -ComputerName $DestServerIP -Credential $credential -AcceptKey
    If (($session.Host -ne $DestServerIP) -or !($session.Connected)){
        Write-Host "SFTP server Connectivity failed..!" -ForegroundColor Red
        exit 1
    }
    Write-Host "Session established successfully" -ForegroundColor Green
    Write-Host "Started uploading: $LocalPath files to $RemotePath"

    # uploading all the .txt files to remote server:
    Set-SFTPFile -SessionId ($session).SessionId -LocalFile $LocalPath -RemotePath $RemotePath
    Write-Host "Files successfully uploaded"
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
} finally {
    Write-Host "Closing the connection" -ForegroundColor Green
    #Disconnect, clean up
    Remove-SFTPSession -SessionId $session.SessionId -Verbose | out-null
    exit 0
}