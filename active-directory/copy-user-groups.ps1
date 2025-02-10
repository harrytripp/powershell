# Only use if in same OU to avoid complicating inherited membership

$reference = "j.doe"
$copy = "b.gates"

$groups = Get-ADPrincipalGroupMembership $reference | Select-Object SamAccountName
$ExistingGroups = Get-ADPrincipalGroupMembership $copy | Select-Object SamAccountName
$MissingGroups = $ExistingGroups| ?{$groups -notcontains $_}

Write-Host "You are about to add user"$copy" to these groups:"
Write-Host $MissingGroups

foreach ($group in $MissingGroups){
    Add-ADPrincipalGroupMembership -Identity $copy -MemberOf $group -WhatIf
}
