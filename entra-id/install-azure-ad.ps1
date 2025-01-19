# Does not work on PowerShell 7
Install-Module -Name AzureAD -AllowClobber

# Confirm module is available
Import-Module AzureAD
Get-Module AzureAD

Connect-AzureAD
