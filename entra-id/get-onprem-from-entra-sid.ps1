Install-Module -Name AzureAD -AllowClobber
Import-Module AzureAD
Get-Module AzureAD

Connect-AzureAD

$AzSID = Get-AzureADGroup -SearchString "SG All Staff" | Select-Object onPremisesSecurityIdentifier

$string = "$($AzSID[0])"
$trim = $string.Trim("@","{","}"," ")
$SID = $trim.substring($trim.IndexOf("=") + 1)
Write-Host "Azure Object SID is: $($SID)"

Write-Host "On Prem AD Object is:"
Get-ADGroup -Identity "$($SID)" | Select-Object * #Name, SID
