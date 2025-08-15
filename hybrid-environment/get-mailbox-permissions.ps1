Import-Module ExchangeOnlineManagement

$principal = "harry@domain.com"
$target = "user@domain.com"

Connect-ExchangeOnline -UserPrincipalName $principal -InlineCredential

# Get all mailboxes in tenant where the target user has delegated access
Get-EXOMailbox -ResultSize Unlimited | Get-EXOMailboxPermission -Identity $_.Identity | Where-Object {$_.User -eq $target}

Disconnect-ExchangeOnline -Confirm