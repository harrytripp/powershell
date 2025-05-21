Get-ADComputer -filter * -SearchBase "OU=grandchild,OU=child,OU=parent,DC=network,DC=local" -properties * |
Where-Object {$_.lastlogondate -le (get-date).adddays(-182)} |
Select-Object name, lastLogon, lastLogonDate, lastLogonTimestamp, objectSid, sAMAccountName |
Export-Csv -Path .\Computers.csv -NoTypeInformation