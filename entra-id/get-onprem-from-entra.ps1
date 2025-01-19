Install-Module -Name AzureAD -AllowClobber
Import-Module AzureAD
Get-Module AzureAD

Connect-AzureAD

Get-ADGroup -Identity "SG All Staff OLD" | Select-Object * # Name, SamAccountName, ObjectGUID, SID
Get-AzureADGroup -SearchString "SG All Staff" | Select-Object * # DisplayName, ObjectId, onPremisesSecurityIdentifier
