# Get cutoff date formatted like LastLogonDate
$cutOff = ((get-date).AddDays(-90)).ToString("dd MMMM yyyy H:mm:ss")

Write-Host "90 day cutoff date: $cutOff"

Write-Host (Get-ADComputer -Properties * -filter "LastLogonDate -le ""$cutOff""")