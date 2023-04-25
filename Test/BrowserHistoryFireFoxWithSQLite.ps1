$UserName = $env:UserName
$YesterdayDateFilterName = (Get-Date).AddDays(-1).ToString('yyyy-MM-dd')

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
            $SQLiteArray = C:\SQLite3\sqlite-tools-win32-x86-3380500\sqlite3.exe $DataSource "SELECT url, datetime(last_visit_date / 1000000 + (strftime('%s', '1970-01-01')), 'unixepoch', 'localtime') from moz_places"
        }
    }
}
catch
{
    write-host $_.Exception.Message
}

$AllHistory = @()
For ($i = 0; $i -lt $SQLiteArray.Length; $i++) {
    if($YesterdayDateFilterName -eq $SQLiteArray[$i].split("|")[1].SubString(0,10)){
        $HistoryData = New-Object -TypeName PSObject -Property @{
            User = $UserName
            Browser = 'FireFox'
            DataType = 'History'
            Data = $SQLiteArray[$i].split("|")[0]
            TimeStamp = $SQLiteArray[$i].split("|")[1]
        }
        $AllHistory += $HistoryData
    }
}
$AllHistory
$AllHistory | Export-Csv -Path C:\temp\NewFirefoxHistory.csv
