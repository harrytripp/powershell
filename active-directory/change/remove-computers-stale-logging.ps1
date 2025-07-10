# For manual or scheduled use.
# Targets: Only explicitly included OUs. Computers not logged into in over 6 months.
# Exludes: Whitelisted computers.

$rundate = (get-date).ToString("dd_MMMM_yyyy_H_mm_ss")
$logpath = ".\logfiles\errors\ErrorLog_$($rundate).log"
$csvpath = ".\logfiles\computers\StaleComputers_$($rundate).csv"
$rempath = ".\logfiles\computers\RemovedComputers_$($rundate).log"
$parentdir = @(".\logfiles\errors",".\logfiles\computers")

# Check if logging parent directories exist and silently create if not.
foreach ($path in $parentdir) {
    If(!(test-path -PathType Container $path)) {
        New-Item -ItemType Directory -Path $path | Out-Null
    }
}

$ous = @("OU=grandchild1,OU=child,OU=parent,DC=network,DC=local","OU=grandchild2,OU=child,OU=parent,DC=network,DC=local")
# Use sAMAccountName
$whitelist = @("computer01$","server01$","laptop01$")

# Runs in parallel for each OU, limited to 5 at a time.
$getcomputers = $ous | Foreach-Object -ThrottleLimit 5 -Parallel {
    try {
        Get-ADComputer -filter * -SearchBase $_ -properties * |
        Where-Object {
            ($_.lastLogonDate -le (get-date).adddays(-182)) -or
            ($_.lastLogonDate) -eq $null -and
            ($_.whenCreated -le (get-date).adddays(-2)) -and
            ($using:whitelist -notcontains $_.sAMAccountName)
        }
    }
    catch {
        # Have to build custom object to return errors from within the -Parallel block.
        [PSCustomObject]@{
            IsError = $true
            OU = $_.TargetObject
            Message = $_.Exception.Message
            ScriptLine = $_.InvocationInfo.ScriptLineNumber
            Line = $_.InvocationInfo.Line
            Position = $_.InvocationInfo.PositionMessage
            StackTrace = $_.ScriptStackTrace
        }
    }
    
}

# Separate $getcomputers output
$geterrors = $getcomputers | Where-Object { $_.IsError }
$computers = $getcomputers | Where-Object { -not $_.IsError }

# Log errors related to getting computers
foreach ($err in $geterrors) {
    Add-Content -Path $logpath -Value "$((Get-Date).ToString("dd MMMM yyyy H:mm:ss")) - [AD Query Error]`n- OU: $($err.OU)`n- Message: $($err.Message)`n- Line: $($err.Line)`n- Position: $($err.Position)`n- StackTrace: $($err.StackTrace)`n`n===== END OF AD QUERY ERROR =====`n`n" -Force
}

# Export successfully returned computers and relevant properties
$computers | Select-Object name, sAMAccountName, lastLogon, lastLogonDate, lastLogonTimestamp, whenCreated, objectSid, distinguishedName, Description | Export-Csv -Path $csvpath -NoTypeInformation

# Try to remove each successfully returned computer
Foreach ($computer in $computers) {
    try {
        Remove-ADComputer -Identity $computer.sAMAccountName -Confirm:$false -WhatIf
        Add-Content -Path $rempath -Value "$((get-date).ToString("dd MMMM yyyy H:mm:ss")) $($computer.sAMAccountName) was successfully removed." -Force
    }
    catch {
        Add-Content -Path $logpath -Value "$((get-date).ToString("dd MMMM yyyy H:mm:ss")) - [Remove-Computer Error]`n- Computer: $($computer.sAMAccountName)`n- Exception Message: $($_.Exception.Message)`n- Line: $($_.InvocationInfo.Line)`n- Position: $($_.InvocationInfo.PositionMessage)`n- StackTrace: $($_.ScriptStackTrace)`n`n===== END OF REMOVE COMPUTER ERROR =====`n`n" -Force
    }
}