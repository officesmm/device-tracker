function BrowserHistory($GapDate)
{
    $UserName = $env:UserName
    $pcname = whoami
    $ComputerName = $pcname.Split("\")
    $YesterdayDateFileName = (Get-Date).AddDays($GapDate).ToString('yyyyMMdd')
    $YesterdayDateFilterName = (Get-Date).AddDays($GapDate).ToString('yyyy-MM-dd')
    $AllHistory = @()

    $scriptPathLocal = $PSScriptRoot
    $parentPathLocal = Split-Path -Parent -Path $scriptPathLocal
    $thePath = Join-Path $parentPathLocal 'settings.txt'

    Get-Content $thePath | Foreach-Object{
        $var = $_.Split('=')
        New-Variable -Name $var[0] -Value $var[1]
    }

    $PreLogPath = Join-Path $parentPathLocal $LogPath
    $NewItemPath = $PreLogPath + $YesterdayDateFileName
    if (-Not(Test-Path -Path $NewItemPath))
    {
        New-Item -Path $NewItemPath -ItemType Directory
    }
    $BrowserHistoryFilePath = $NewItemPath + "\BrowserHistory" + $YesterdayDateFileName + $ComputerName[0] + ".csv"

    Write-Host "Browser history path $BrowserHistoryFilePath"

#    $CurrentDriveName = (Get-Location).Drive.Name
    $CurrentDriveName = (Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -like 'C:\*' }).Name
    #To install SQLite File
    $SQliteZipPath = Join-Path $parentPathLocal Database/sqlite.zip

    #Extract to SQLITE Folder
    $SQLiteInstallPath = $CurrentDriveName + ":\SQLite3\sqlite-tools-win32-x86-3380500\sqlite3.exe"
    if (-not(Test-Path -Path $SQLiteInstallPath))
    {
        $SQLiteInstallSQLite3ForcePath = $CurrentDriveName + ":\SQLite3"
        Expand-Archive $SQliteZipPath -DestinationPath $SQLiteInstallSQLite3ForcePath -Force
        Write-Host "Installing SQLite in this Path : $SQLiteInstallSQLite3ForcePath";
    }
    else {
        Write-Host "The SQLit file is exist in this Path : $SQLiteInstallPath"
    }
    #READ DATA FROM TABLE

    #Chrome Start here
    #Chrome Possible file
    $ChromePossibleProfiles = @(
    "Default",    "Profile 1",    "Profile 2",    "Profile 3",    "Profile 4",    "Profile 5"
    )
    $ExistingChromePossibleProfilesPaths = @()

    foreach ($ChromePossibleProfile in $ChromePossibleProfiles)
    {
        $UserNameAndChromeHistoryPath0Intro = $CurrentDriveName + ":\Users\"
        $ChromeHistoryPath1 = Join-Path $UserNameAndChromeHistoryPath0Intro $UserName
        $ChromeHistoryPath2 = Join-Path  $ChromeHistoryPath1 "\AppData\Local\Google\Chrome\User Data\"
        $ChromeHistoryPath = Join-Path  $ChromeHistoryPath2 $ChromePossibleProfile
        if (Test-Path $ChromeHistoryPath) {
            $ExistingChromePossibleProfilesPaths += $ChromeHistoryPath
        }
    }

    foreach ($CurrentUsingExistingchromePossibleProfilesPath in $ExistingChromePossibleProfilesPaths)
    {
        $CurrentUsingExistingchromePossibleProfilesPath
        try
        {
            $DataDestinationPath = $CurrentUsingExistingchromePossibleProfilesPath + "\HistoryTemp.sqlite"
            $DataSourcePath = $CurrentUsingExistingchromePossibleProfilesPath + "\History"
            Copy-Item $DataSourcePath $DataDestinationPath
            $tables = sqlite3.exe $DataDestinationPath .tables

            if ($tables -match "urls")
            {
                $SQLiteArrayChrome = sqlite3.exe $DataDestinationPath "SELECT url, datetime(last_visit_time / 1000000 + (strftime('%s', '1601-01-01')), 'unixepoch', 'localtime') from urls"
            }
            if (Test-Path $DataDestinationPath)
            {
                Remove-Item $DataDestinationPath
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
                Write-Host "Chrome Index and length error";
            }
        }
    }
    #Chrome End here

    Write-Host "after chrome before firefox"
    #Firefox Start here
    try
    {
        $Path = $CurrentDriveName +":\Users\$UserName\AppData\Roaming\Mozilla\Firefox\Profiles\"
        $Profiles = Get-ChildItem -Path "$Path\*.default-release*\" -ErrorAction SilentlyContinue

        ForEach ($item in $Profiles)
        {
            $DataSource = "$item\places.sqlite"
            $tables = sqlite3.exe $DataSource .tables
            if ($tables -match "moz")
            {
                $SQLiteArrayFirefox = sqlite3.exe $DataSource "SELECT url, datetime(last_visit_date / 1000000 + (strftime('%s', '1970-01-01')), 'unixepoch', 'localtime') from moz_places"
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
            Write-Host "Firefox Index and length error";
        }
    }
    #Firefox End here

    #Edge Start here
    try
    {
        $DataDestinationPath = $CurrentDriveName +":\Users\" + $UserName + "\AppData\Local\Microsoft\Edge\User Data\Default\HistoryTemp.sqlite"
        $DataSourcePath = $CurrentDriveName + ":\Users\" + $UserName + "\AppData\Local\Microsoft\Edge\User Data\Default\History"
        Copy-Item $DataSourcePath $DataDestinationPath
        $tables = sqlite3.exe $DataDestinationPath .tables
        if ($tables -match "urls")
        {
            $SQLiteArrayEdge = sqlite3.exe $DataDestinationPath "SELECT url, datetime(last_visit_time / 1000000 + (strftime('%s', '1601-01-01')), 'unixepoch', 'localtime') from urls"
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
            Write-Host "Edge Index and length error";
        }
    }
    #Edge End here
    Write-Host "last time browser path $BrowserHistoryFilePath"
    $AllHistory | Export-Csv -Encoding UTF8 -Path $BrowserHistoryFilePath
}
#Last Run Action

$file = Join-Path $PSScriptRoot 'lastrun.txt'

$YesterdayDateFileName = (Get-Date).AddDays(-1).ToString('yyyyMMdd')
$VariableList = Get-Content -Raw $file | ConvertFrom-StringData
$BrowserVar = $VariableList.BrowserHistory

if ($BrowserVar -match "^[\d\.]+$")
{
    $Today = Get-Date
    $PreviousDate = [datetime]::ParseExact($BrowserVar, 'yyyyMMdd', $null)
    $Gap = $Today - $PreviousDate
    $dateGap = $Gap.Days - 1
    if ($dateGap -gt 7)
    {
        $dateGap = 7
    }
}
else
{
    $dateGap = 7
}
while ($dateGap -ge 1)
{
    $gettingDatetoRun = -1 * ($dateGap);
    BrowserHistory $gettingDatetoRun
    $runningDate = (Get-Date).AddDays($gettingDatetoRun).ToString('yyyyMMdd')
    Write-Host "Browser History, $runningDate is running"
    $dateGap --
}

(Get-Content $file -Encoding utf8) | ForEach-Object {
    if ($_ -match "^BrowserHistory=")
    {
        "BrowserHistory=$YesterdayDateFileName"
    }
    else
    {
        $_
    }
} | Set-Content $file -Encoding utf8

