$files = Get-Content .\files.txt
$src = Get-Content .\src.txt

@{
    files = $files
    src = $src
} | ConvertTo-Json | Set-Content .\files.json