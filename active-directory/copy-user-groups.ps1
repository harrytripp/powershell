# Only use if in same OU to avoid complicating inherited membership
# Must be ran as admin

$reference = "j.doe"
$copy = "b.gates"
$groups = Get-ADPrincipalGroupMembership $reference | Select-Object SamAccountName
$ExistingGroups = Get-ADPrincipalGroupMembership $copy | Select-Object SamAccountName
$MissingGroups = $groups| Where-Object{$ExistingGroups -notcontains $_}

Write-Host 'You are about to add user'$copy' to these groups:'
Write-Host $MissingGroups
$check = Read-Host 'Would you like to continue? y/N'

if ($check -eq 'y') {
    foreach ($group in $MissingGroups){
        Add-ADPrincipalGroupMembership -Identity $copy -MemberOf $group -WhatIf
    }
}else{
    Write-Host 'Operation Cancelled'
    exit
}
