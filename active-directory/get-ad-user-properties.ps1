# Specify properties that Get-AdUser does not return by default.
# Pipe the output to Select-Object to return just the specified properties.
Get-ADUser -Identity [username] -Properties HomeDirectory, sAMAccountName | Select-Object HomeDirectory, sAMAccountName
