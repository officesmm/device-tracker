$TestString = "  Date: 2023-04-17T10:04:01.5780000Z"

$NewString = $TestString -replace ".*Date: "
#-replace ",.*"

$NewString