# For manual or scheduled use.
# Targets: Only explicitly included OUs. Computers not logged into in over 6 months.
# Exludes: whitelisted computers.

$ous = @("OU=grandchild1,OU=child,OU=parent,DC=network,DC=local","OU=grandchild2,OU=child,OU=parent,DC=network,DC=local")

# Use sAMAccountName
$whitelist = @("computer01$","server01$","laptop01$")

# Runs in parallel for each OU, limited to 5 at a time.
$computers = ($ous | Foreach-Object -ThrottleLimit 5 -Parallel {
    Get-ADComputer -filter * -SearchBase $_ -properties * |
    Where-Object {
        ($_.lastLogonDate -le (get-date).adddays(-182)) -or
        ($_.lastLogonDate) -eq $null -and
        ($_.whenCreated -le (get-date).adddays(-2)) -and
        ($using:whitelist -notcontains $_.sAMAccountName)
    }
} |
Select-Object name, lastLogon, lastLogonDate, lastLogonTimestamp, objectSid, sAMAccountName, distinguishedName, Description)

$computers | Export-Csv -Path .\Computers.csv -NoTypeInformation