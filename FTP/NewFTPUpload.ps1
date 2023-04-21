$client = New-Object System.Net.WebClient
$client.Credentials = New-Object System.Net.NetworkCredential("onepay", "onepay001")
$client.UploadFile("ftp://onepay:onepay001@192.168.0.77/Home/Test/file.txt", "C:\PrintAndDriverFrameLog\file.txt")