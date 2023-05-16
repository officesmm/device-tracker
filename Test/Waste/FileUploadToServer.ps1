try
{
    # Load WinSCP .NET assembly
    Add-Type -Path "WinSCPnet.dll"

    # Setup session options
    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::Sftp
        HostName = "54.238.150.121"
        UserName = "OA010832"
        Password = "EwWmtL5N6xtPYgnF"
        SshHostKeyFingerprint = "ssh-rsa 2048 xxxxxxxxxxx..."
    }

    $session = New-Object WinSCP.Session

    try
    {
        # Connect
        $session.Open($sessionOptions)

        # Upload files
        $transferOptions = New-Object WinSCP.TransferOptions
        $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary

        $transferResult =
        $session.PutFiles("C:\PrintAndDriverFrameLog\*", "/local/test/printservicetest/", $False, $transferOptions)

        # Throw on any error
        $transferResult.Check()

        # Print results
        foreach ($transfer in $transferResult.Transfers)
        {
            Write-Host "Upload of $($transfer.FileName) succeeded"
        }
    }
    finally
    {
        # Disconnect, clean up
        $session.Dispose()
    }

    exit 0
}
catch
{
    Write-Host "Error: $($_.Exception.Message)"
    exit 1
}