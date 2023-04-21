$source = "C:\SecurityLog"
$destination = "ftp://onepay:onepay001@192.168.0.77:21//Public"
$webclient = New-Object -TypeName System.Net.WebClient
$files = Get-ChildItem $source -recurse -force
foreach ($file in $files){
    $webclient.UploadFile("$destination/$file", $file.FullName)
}
$webclient.Dispose()


$Dir="C:\path\Generate XML Files"
$DirArch="C:\path\Archive"

#ftp server
$ftp = "server"
$user = "Froot"
$pass = "Fr00tDr1v3nc"

$webclient = New-Object System.Net.WebClient

$webclient.Credentials = New-Object System.Net.NetworkCredential($user,$pass)

#remove junk and old xml files
Remove-Item ($DirArch + "\*.xml") -Force
Remove-Item ($Dir + "\*_.xml") -Force

#list every xml file
foreach($item in (dir $Dir "*.xml")){
    "Uploading $item..."
    $uri = New-Object System.Uri($ftp+$item.Name)
    $webclient.UploadFile($uri, $item.FullName)
    #Archive Uploaded Files By Date
    $date = (Get-Date).ToString('MM-dd-yyyy')
    #$path = ($DirArch + $date)
    $path = ($DirArch)
    #If Today's folder doesn't exist, make one.
    If(!(test-path $DirArch))
    {
        New-Item -ItemType Directory -Force -Path $path
    }
    #Move file to today's folder
    Move-Item $item.FullName -destination $path -Force
}
#Beep When Finished
function b($a,$b){
    [console]::beep($a,$b)
}