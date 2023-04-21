$pcname= whoami
$CharArray = $pcname.Split("\")

$log = Get-WinEvent -ComputerName $CharArray[0] -ListLog 'Microsoft-Windows-DriverFrameworks-UserMode/Operational'
$log.IsEnabled = $True
$log.MaximumSizeInBytes = 1000000
$log.SaveChanges()

$log = Get-WinEvent -ComputerName $CharArray[0] -ListLog 'Microsoft-Windows-PrintService/Operational'
$log.IsEnabled = $True
$log.MaximumSizeInBytes = 1000000
$log.SaveChanges()
