Invoke-Command -ScriptBlock {
        $memArray = Get-CimInstance Win32_PhysicalMemoryArray
        $totalMemoryGB = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb;
        $computerInfo = Get-ComputerInfo
        $cpu = Get-CimInstance Win32_Processor

        [PSCustomObject]@{
        ComputerName         = $computerInfo.CsName
        Manufacturer         = $computerInfo.CsManufacturer
        Model                = $computerInfo.CsModel
        BIOS_SerialNumber    = $computerInfo.BiosSerialNumber
        CPU_Name             = $cpu.Name
        MemoryArrayUse       = $memArray.MemoryDevices
        TotalMemoryGB        = $totalMemoryGB
        }

} -ComputerName (Get-ADComputer -Filter {Enabled -eq $True} -SearchBase "OU=grandchild,OU=child,OU=parent,DC=network,DC=local").Name -Credential network.local\user | Export-Csv -Path "C:\Temp\SystemInfoReport.csv" -NoTypeInformation -Encoding UTF8 #-Force