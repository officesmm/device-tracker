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
    $DataDestinationPath = "C:\Users\"+$UserName+"\AppData\Local\Microsoft\Edge\User Data\Default\HistoryTemp.sqlite"
    $DataSourcePath = "C:\Users\"+$UserName+"\AppData\Local\Microsoft\Edge\User Data\Default\History"
    Copy-Item $DataSourcePath $DataDestinationPath
    $tables = C:\SQLite3\sqlite-tools-win32-x86-3380500\sqlite3.exe $DataDestinationPath .tables
    if ($tables -match "urls")
    {
        $SQLiteArray = C:\SQLite3\sqlite-tools-win32-x86-3380500\sqlite3.exe $DataDestinationPath "SELECT url, datetime(last_visit_time / 1000000 + (strftime('%s', '1601-01-01')), 'unixepoch', 'localtime') from urls"
    }
    if (Test-Path $DataSource)
    {
        Remove-Item $DataSource
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
            Browser = 'Edge'
            DataType = 'History'
            Data = $SQLiteArray[$i].split("|")[0]
            TimeStamp = $SQLiteArray[$i].split("|")[1]
        }
        $AllHistory += $HistoryData
    }
}
#$AllHistory
$AllHistory | Export-Csv -Path "C:\temp\NewEdgeHistory.csv"
