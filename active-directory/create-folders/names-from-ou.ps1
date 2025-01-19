$names = Get-ADUser -Filter * -SearchBase "OU=grandchild,OU=child,OU=parent,DC=network,DC=local" -Properties Surname, GivenName | Select-Object Surname, GivenName

foreach ($name in $names)
{
    New-Item -ItemType "directory" -Path "C:\VSCode\PowerShell\ps-test\$($name.Surname), $($name.GivenName)" -Force
}
