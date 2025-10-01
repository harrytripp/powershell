$destination = '172.23.1.12'
$logPath = '.\tracert.log'

Write-Host "Connection monitoring has begun. Target: $destination"

while ($true) {
    # Check if the destination is reachable
    $pingResult = Test-NetConnection -ComputerName $destination
    if (-not $pingResult.PingSucceeded) {
        Write-Host "$(Get-Date -Format "yyyy_MM_dd HH:mm:ss") | Ping to $destination failed, tracing route..."
        # Log the failure timestamp
        Get-Date | Out-File -FilePath $logPath -Append
        # Perform tracert and log the output
        tracert $destination | Out-File -FilePath $logPath -Append
        Write-Host "Trace Route logged to $($logPath)."
        Start-Sleep -Seconds 30
    } else {
        Write-Host "$(Get-Date -Format "yyyy_MM_dd HH:mm:ss") | Ping to $destination succeeded."
        Start-Sleep -Seconds 60
    }
}
