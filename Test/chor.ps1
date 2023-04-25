#$DataSource = "C:\Users\SoeMyatMin\AppData\Local\Google\Chrome\User Data\Default\HistoryTemp.sqlite"
#Copy-Item "C:\Users\SoeMyatMin\AppData\Local\Google\Chrome\User Data\Default\History" $DataSource
#if (Test-Path $DataSource) {
#    Remove-Item $DataSource
#}

$UserName = $env:UserName
$DataDestinationPath = "C:\Users\"+$UserName+"\AppData\Local\Google\Chrome\User Data\Default\HistoryTemp.sqlite"
$DataSourcePath = "C:\Users\"+$UserName+"\AppData\Local\Google\Chrome\User Data\Default\History"
Copy-Item $DataSourcePath $DataDestinationPath
 #>