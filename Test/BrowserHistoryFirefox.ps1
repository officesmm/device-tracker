$UserName = $env:UserName

#DOWNLOAD SQLITE
if (-not(Test-Path -Path C:\sqlite.zip -PathType Leaf))
{
    Invoke-WebRequest -Uri "https://www.sqlite.org/2022/sqlite-tools-win32-x86-3380500.zip" -OutFile C:\sqlite.zip
}

#Extract to SQLITE Folder
if (-not(Test-Path -Path "C:\SQLite3\sqlite-tools-win32-x86-3380500\sqlite3.exe"))
{
    Expand-Archive C:\sqlite.zip -DestinationPath C:\SQLite3 -Force
}

#READ DATA FROM TABLE
try
{
    $Path = "C:\Users\$UserName\AppData\Roaming\Mozilla\Firefox\Profiles\"
    $Profiles = Get-ChildItem -Path "$Path\*.default-release*\" -ErrorAction SilentlyContinue

    ForEach ($item in $Profiles)
    {
        $DataSource = "$item\places.sqlite"
        $tables = C:\SQLite3\sqlite-tools-win32-x86-3380500\sqlite3.exe $DataSource .tables
        if ($tables -match "moz")
        {
#            SELECT url from moz_places
            $SQLiteArray = C:\SQLite3\sqlite-tools-win32-x86-3380500\sqlite3.exe $DataSource "SELECT datetime(visit_date/1000000,'unixepoch') AS visit_date, url from moz_places, moz_historyvisits WHERE moz_places.id = moz_historyvisits.place_id"
        }
    }
}
catch
{
    write-host $_.Exception.Message
}

$AllHistory = @()
For ($i=0; $i -lt $SQLiteArray.Length; $i++) {
    $HistoryData = New-Object -TypeName PSObject -Property @{
        User = $UserName
        Browser = 'Firefox'
        DataType = 'History'
        Data = $SQLiteArray[$i]
    }
    $AllHistory += $HistoryData
}
$AllHistory | Export-Csv -Path C:\temp\FirefoxHistory.csv
