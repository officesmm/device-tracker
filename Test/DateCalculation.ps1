# Get the current date
$Today = Get-Date

# Convert the previous date to a DateTime object
$PreviousDate = [datetime]::ParseExact('20230429', 'yyyyMMdd', $null)

# Calculate the date gap
$DateGap = $Today - $PreviousDate

# Output the date gap in days
$DateGap.Days