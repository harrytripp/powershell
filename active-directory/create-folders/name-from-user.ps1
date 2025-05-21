
$name = Get-ADUser -Identity j.doe -Properties Surname, GivenName | Select-Object Surname, GivenName
New-Item -ItemType "directory" -Path "C:\temp\$($name.Surname + $name.GivenName)" -Force