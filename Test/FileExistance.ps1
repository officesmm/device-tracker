
$folderPaths = @(
"C:\Path\To\Folder1",
"C:\Path\To\Folder2",
"C:\Path\To\Folder3"
)

$existingPaths = @()

foreach ($path in $folderPaths) {
    if (Test-Path $path) {
        $existingPaths += $path
    }
}
Write-Host "Existing paths:"
$existingPaths