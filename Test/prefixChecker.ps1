$PrefixList = @('HUND', 'DSUN', 'FPRO')
$InputString = "DSUN 123"

$ContainsPrefix = $PrefixList | Where-Object { $InputString -like "$_*" }

if ($ContainsPrefix) {
    Write-Host "The input string contains one of the prefixes."
} else {
    Write-Host "The input string does not contain any of the prefixes."
}