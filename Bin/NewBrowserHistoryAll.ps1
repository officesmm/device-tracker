$UserName = $env:UserName
$pcname = whoami
$ComputerName = $pcname.Split("\")
$YesterdayDateFileName = (Get-Date).AddDays(-1).ToString('yyyyMMdd')
$YesterdayDateFilterName = (Get-Date).AddDays(-1).ToString('yyyy-MM-dd')
$AllHistory = @()

$NewItemPath = "C:\SecurityLog\" + $YesterdayDateFileName
if (-Not(Test-Path -Path $NewItemPath))
{
    New-Item -Path $NewItemPath -ItemType Directory
}
$BrowserHistoryFilePath = $NewItemPath + "\BrowserHistory" + $YesterdayDateFileName + $ComputerName[0] + ".csv"

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
#Chrome Start here
try
{
    $DataDestinationPath = "C:\Users\" + $UserName + "\AppData\Local\Google\Chrome\User Data\Default\HistoryTemp.sqlite"
    $DataSourcePath = "C:\Users\" + $UserName + "\AppData\Local\Google\Chrome\User Data\Default\History"
    Copy-Item $DataSourcePath $DataDestinationPath
    $tables = C:\SQLite3\sqlite-tools-win32-x86-3380500\sqlite3.exe $DataDestinationPath .tables
    if ($tables -match "urls")
    {
        $SQLiteArrayChrome = C:\SQLite3\sqlite-tools-win32-x86-3380500\sqlite3.exe $DataDestinationPath "SELECT url, datetime(last_visit_time / 1000000 + (strftime('%s', '1601-01-01')), 'unixepoch', 'localtime') from urls"
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
For ($i = 0; $i -lt $SQLiteArrayChrome.Length; $i++) {
    try
    {
        if ($YesterdayDateFilterName -eq $SQLiteArrayChrome[$i].split("|")[1].SubString(0, 10))
        {
            $HistoryData = New-Object -TypeName PSObject -Property @{
                User = $UserName
                Browser = 'Chrome'
                DataType = 'History'
                Data = $SQLiteArrayChrome[$i].split("|")[0]
                TimeStamp = $SQLiteArrayChrome[$i].split("|")[1]
            }
            $AllHistory += $HistoryData
        }
    }
    catch
    {
        Write-Host "Index and length error";
    }
}
#Chrome End here

#Firefox Start here
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
            $SQLiteArrayFirefox = C:\SQLite3\sqlite-tools-win32-x86-3380500\sqlite3.exe $DataSource "SELECT url, datetime(last_visit_date / 1000000 + (strftime('%s', '1970-01-01')), 'unixepoch', 'localtime') from moz_places"
        }
    }
}
catch
{
    write-host $_.Exception.Message
}
For ($i = 0; $i -lt $SQLiteArrayFirefox.Length; $i++) {
    try
    {
        if ($YesterdayDateFilterName -eq $SQLiteArrayFirefox[$i].split("|")[1].SubString(0, 10))
        {
            $HistoryData = New-Object -TypeName PSObject -Property @{
                User = $UserName
                Browser = 'FireFox'
                DataType = 'History'
                Data = $SQLiteArrayFirefox[$i].split("|")[0]
                TimeStamp = $SQLiteArrayFirefox[$i].split("|")[1]
            }
            $AllHistory += $HistoryData
        }
    }
    catch
    {
        Write-Host "Index and length error";
    }

}
#Firefox End here

#Edge Start here
try
{
    $DataDestinationPath = "C:\Users\" + $UserName + "\AppData\Local\Microsoft\Edge\User Data\Default\HistoryTemp.sqlite"
    $DataSourcePath = "C:\Users\" + $UserName + "\AppData\Local\Microsoft\Edge\User Data\Default\History"
    Copy-Item $DataSourcePath $DataDestinationPath
    $tables = C:\SQLite3\sqlite-tools-win32-x86-3380500\sqlite3.exe $DataDestinationPath .tables
    if ($tables -match "urls")
    {
        $SQLiteArrayEdge = C:\SQLite3\sqlite-tools-win32-x86-3380500\sqlite3.exe $DataDestinationPath "SELECT url, datetime(last_visit_time / 1000000 + (strftime('%s', '1601-01-01')), 'unixepoch', 'localtime') from urls"
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
For ($i = 0; $i -lt $SQLiteArrayEdge.Length; $i++) {
    try
    {
        if ($YesterdayDateFilterName -eq $SQLiteArrayEdge[$i].split("|")[1].SubString(0, 10))
        {
            $HistoryData = New-Object -TypeName PSObject -Property @{
                User = $UserName
                Browser = 'Edge'
                DataType = 'History'
                Data = $SQLiteArrayEdge[$i].split("|")[0]
                TimeStamp = $SQLiteArrayEdge[$i].split("|")[1]
            }
            $AllHistory += $HistoryData
        }
    }
    catch
    {
        Write-Host "Index and length error";
    }
}
#Edge End here

$AllHistory | Export-Csv -Encoding UTF8 -Path $BrowserHistoryFilePath
