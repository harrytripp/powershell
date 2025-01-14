$ou1 = ("OU=grandchild,OU=child,OU=parent,DC=network,DC=local")
$ou2 = ("OU=grandchild,OU=child,OU=parent,DC=network,DC=local")

$ous = $ou1,$ou2
foreach ($ou in $ous)
{
    Get-ADUser -Filter * -SearchBase $ou -Properties HomeDirectory, sAMAccountType | Select-Object HomeDirectory, sAMAccountType | Export-Csv -Path .\"$($ou.Substring(21, 15))".csv -NoTypeInformation
}
# .Substring(Start, Length)
