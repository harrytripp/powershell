# Targets: Only explicitly included OUs. Computers not logged into in over 6 months.
# Exludes: whitelisted computers.

$whitelist = @("computer01$","server01$","laptop01$")

Get-ADComputer -filter * -SearchBase "OU=grandchild,OU=child,OU=parent,DC=network,DC=local" -properties * |
Where-Object {
    ($_.lastLogonDate -le (get-date).adddays(-182)) -or
    ($_.lastLogonDate) -eq $null -and
    ($_.whenCreated -le (get-date).adddays(-2)) -and
    ($whitelist -notcontains $_.sAMAccountName)
} |
Select-Object name, lastLogon, lastLogonDate, lastLogonTimestamp, objectSid, sAMAccountName |

Export-Csv -Path .\Computers.csv -NoTypeInformation