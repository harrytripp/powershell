Install-Module -Name AzureAD -AllowClobber
Import-Module AzureAD
Get-Module AzureAD

Connect-AzureAD

$AzInfo = Get-AzureADGroup -SearchString "All Staff" | Select-Object *
$AzSID = Get-AzureADGroup -SearchString "All Staff" | Select-Object onPremisesSecurityIdentifier

$AzSidStr = "$($AzSID[0])"
$trim = $AzSidStr.Trim("@","{","}"," ")
$SID = $trim.substring($trim.IndexOf("=") + 1)
Write-Host "Azure Object SID is: $($SID)"

$adInfo = Get-ADGroup -Identity "$($SID)" | Select-Object *
Write-Host "On Prem AD Object is: $($adInfo.Name)"

$data = Get-ADGroupMember -Identity "$($SID)" -Recursive | Get-ADUser | Select-Object *

$AzInfo | Export-Csv -Path "C:\Export\AzureInfo.csv" -NoTypeInformation -Force
$adInfo | Export-Csv -Path "C:\Export\ADInfo.csv" -NoTypeInformation -Append -Force
$data | Export-Csv -Path "C:\Export\Membership.csv" -NoTypeInformation -Append -Force
