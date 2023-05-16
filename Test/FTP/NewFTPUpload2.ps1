$file = "C:\PrintAndDriverFrameLog\file.txt"
$ftpuri = "ftp://onepay:onepay001@192.168.0.77:21/Home/file.txt"
$webclient = New-Object System.Net.WebClient
$uri = New-Object System.Uri($ftpuri)
$webclient.UploadFile($uri, $file)

$file = "C:\PrintAndDriverFrameLog\dfile.txt"
$ftpuri = "ftp://onepay:onepay001@192.168.0.77/Home/Download/dfile.txt"
$webclient = New-Object System.Net.WebClient
$uri = New-Object System.Uri($ftpuri)
$webclient.DownloadFile($uri, $file)