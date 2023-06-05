$InstallerList = @()

$InstallerList1 = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | select-object DisplayName, InstallDate
For ($i = 0; $i -lt $InstallerList1.Length; $i++) {
    $InstallerTemp = New-Object -TypeName PSObject -Property @{
        SoftwareName = $InstallerList1[$i].DisplayName
        InstallDate = $InstallerList1[$i].InstallDate
    }
    $InstallerList += $InstallerTemp
}

$InstallerList2  = AppxPackage
For ($i = 0; $i -lt $InstallerList2.Length; $i++) {
    $InstallerTemp = New-Object -TypeName PSObject -Property @{
        SoftwareName = $InstallerList2[$i].Name
    }
    $InstallerList += $InstallerTemp
}

#$InstallerList
$HeheList = "Unity Hub 3.4.2"," "
For ($i = 0; $i -lt $InstallerList.Length; $i++) {
    for ($j = 0; $j -lt $HeheList.Length; $j++) {
        if ($InstallerList[$i].SoftwareName -eq $HeheList[$j])
        {
            $InstallerList.Remove($InstallerList[$i])
            break
        }
    }
}

$InstallerList | Export-Csv -Encoding UTF8 -Path C:/SecurityLog/heheallInstaller.csv
