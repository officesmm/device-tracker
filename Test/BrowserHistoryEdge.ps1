$UserName = $env:UserName

$Null = New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS
$Paths = Get-ChildItem 'HKU:\' -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'S-1-5-21-[0-9]+-[0-9]+-[0-9]+-[0-9]+$' }
$AllHistory = @()
ForEach($Path in $Paths) {
    $User = ([System.Security.Principal.SecurityIdentifier] $Path.PSChildName).Translate( [System.Security.Principal.NTAccount]) | Select -ExpandProperty Value
    $Path = $Path | Select-Object -ExpandProperty PSPath
    $UserPath = "$Path\Software\Microsoft\Internet Explorer\TypedURLs"
    if (-not (Test-Path -Path $UserPath)) {
        Write-Verbose "[!] Could not find IE History for SID: $Path"
    }
    else {
        Get-Item -Path $UserPath -ErrorAction SilentlyContinue | ForEach-Object {
            $Key = $_
            $Key.GetValueNames() | ForEach-Object {
                $Value = $Key.GetValue($_)
                if ($Value -match $Search) {
                    $HistoryData = New-Object -TypeName PSObject -Property @{
                        User = $UserName
                        Browser = 'IE'
                        DataType = 'History'
                        Data = $Value
                    }
                    $AllHistory += $HistoryData
                }
            }
        }
    }
}
$AllHistory | Export-Csv -Path C:\temp\EdgeHistory.csv