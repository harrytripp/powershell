# This script creates a one time SSH connection and uses SCP
# It searches multiple folders for the required files
# Opens the connection to a remote host
# Copies the files

$username = "username"
$serverIp = "x.x.x.x"
$destination = "/data/compose/6/consume"
$data = Get-Content .\files.json | ConvertFrom-Json

# Build list of files to copy
$filesToCopy = @()
foreach ($file in $data.files) {
    foreach ($src in $data.src) {
        $fullPath = Join-Path $src $file
        if (Test-Path $fullPath) {
            Add-Content .\filesToCopy.log $fullPath
            $filesToCopy += $fullPath
            break
        }
    }
}

if ($filesToCopy.Count -gt 0) {

    # Using a remote shell command to create the destination folder if it doesn't exist
    $remoteCommand = "mkdir -p '$destination'"
    ssh -o PubkeyAuthentication=no -o PreferredAuthentications=password "$username@$serverIp" $remoteCommand

    # Copy all files in one SCP call
    Write-Host "Copying $($filesToCopy.Count) files to $destination"
    scp $filesToCopy "$username@${serverIp}:$destination"

    Write-Host "Files copied successfully!"
} else {
    Write-Host "No local files found to copy."
}