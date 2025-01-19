$ou1 = ("OU=grandchild,OU=child,OU=parent,DC=network,DC=local")
$ou2 = ("OU=grandchild,OU=child,OU=parent,DC=network,DC=local")

$ous = $ou1,$ou2
$data = foreach ($ou in $ous)
{
    Get-ADUser -Filter * -SearchBase $ou -Properties HomeDirectory, sAMAccountName | Select-Object HomeDirectory, sAMAccountName
}

$data | Export-Csv -Path .\data.csv -NoTypeInformation
