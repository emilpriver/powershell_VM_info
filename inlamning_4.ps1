#computers
$computers = @('Klient01', 'Klient02','Klient03')
$password = "Test123" | ConvertTo-SecureString -asPlainText -Force
$username = "grupp04.lab\Emil"
$credential = New-Object System.Management.Automation.PSCredential($username,$password) 

foreach ($computer in $computers) {
    #bios
    Get-WmiObject win32_bios -ComputerName $computer  -Credential $credential | Select-Object Version, Manufacturer, releasedate | Export-Csv -Path "output\($computer)_Bios.csv"
    #motherboard
    Get-WmiObject Win32_BaseBoard -ComputerName $computer -Credential $credential | Select-Object Manufacturer, Product , Serialnumber | Export-Csv -Path "output\($computer)_Mboard.csv"
    #CPU
    Get-WmiObject  win32_processor -ComputerName $computer  -Credential $credential | Select-Object Name,processortype, Numberofcores, numberoflogicalprocessors | Export-csv -Path "output\($computer)_Cpu.csv"
    #ram
    Get-WmiObject  win32_physicalmemory -ComputerName $computer  -Credential $credential  | Select-Object devicelocator , capacity,manufacturer, partnumber, serialnumber | export-csv -Path "output\($computer)_Ram.csv"
    #HDD
    Get-WmiObject Win32_DiskDrive -ComputerName $computer  -Credential $credential | Select-Object Manufacturer, Model,SerialNumber,Size | Export-Csv -Path "output\($computer)_hdd.csv"
    #Logic disks
    Get-WmiObject win32_logicaldisk -ComputerName $computer  -Credential $credential | Select-Object DeviceID, Filesystem, size, freespace | Export-Csv -Path "output\($computer)_hddlogic.csv"
    #windows updates
    Get-WmiObject win32_quickfixengineering -ComputerName $computer  -Credential $credential  | Select-Object description,hotfixid | Export-Csv -Path "output\($computer)_wupdate.csv"
    #Software
    Get-WmiObject win32_product -ComputerName $computer  -Credential $credential | Select-Object name | Export-Csv -Path "output\($computer)_mjukvara.csv"
    #ip
    Get-WmiObject win32_networkadapterconfiguration -ComputerName $computer  -Credential $credential | Select-Object ipaddress,defaultgateway,dnsdomain,dhcpenabled | Export-Csv -Path "output\($computer)_IP.csv"

    write-host $computer ' Done'

}
#-computer COMPUTERNAME
