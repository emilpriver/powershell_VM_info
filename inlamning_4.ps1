#computers
$config  = Get-Content -Raw -Path config.json | ConvertFrom-Json
$computers = @($config.clients)
$password = $config.user.password | ConvertTo-SecureString -asPlainText -Force
$username =  $config.user.domain+'\'+$config.user.username
$credential = New-Object System.Management.Automation.PSCredential($username,$password) 

foreach ($computer in $computers) {
    #bios
    if($config.settings.bios){
        try 
        {
            Get-WmiObject win32_bios -ComputerName $computer  -Credential $credential -ErrorAction Stop | Select-Object Version, Manufacturer, releasedate -ErrorAction Stop | Export-Csv -Path "output\($computer)_Bios.csv" -ErrorAction Stop
        }
        catch 
        {
            write-host 'Failed to fetch bios'
        }
    }
    #motherboard
    if($config.settings.baseBord){
        try 
        {
            Get-WmiObject Win32_BaseBoard -ComputerName $computer -Credential $credential -ErrorAction Stop | Select-Object Manufacturer, Product , Serialnumber -ErrorAction Stop | Export-Csv -Path "output\($computer)_Mboard.csv" -ErrorAction Stop
        }
        catch 
        {
            write-host 'Failed fetching motherboard'
        }
    }
    #CPU
    if($config.settings.proccessor){
        try 
        {
            Get-WmiObject  win32_processor -ComputerName $computer  -Credential $credential -ErrorAction Stop | Select-Object Name,processortype, Numberofcores, numberoflogicalprocessors | Export-csv -Path "output\($computer)_Cpu.csv"
        }
        catch 
        {
            write-host 'Could not fetch proccessor'
        }
    }
    #ram
    if($config.settings.physical_memory){
        try 
        {
            Get-WmiObject  win32_physicalmemory -ComputerName $computer  -Credential $credential -ErrorAction Stop  | Select-Object devicelocator , capacity,manufacturer, partnumber, serialnumber | export-csv -Path "output\($computer)_Ram.csv"
        }
        catch 
        {
            write-host 'Could not fetch RAM'
        }
    }
    #HDD
    if($config.settings.diskdrive){
        try 
        {
            Get-WmiObject Win32_DiskDrive -ComputerName $computer  -Credential $credential -ErrorAction Stop | Select-Object Manufacturer, Model,SerialNumber,Size | Export-Csv -Path "output\($computer)_hdd.csv"
        }
        catch 
        {
            write-host 'Could not fetch HDD'
        }
    }
    #logic disks
    if($config.settings.logicaldisk){
        try 
        {
            Get-WmiObject win32_logicaldisk -ComputerName $computer  -Credential $credential -ErrorAction Stop | Select-Object DeviceID, Filesystem, size, freespace | Export-Csv -Path "output\($computer)_hddlogic.csv"
        }
        catch 
        {
            write-host 'Could not fetch Loguic disks'
        }
    }
    #windows updates
    if($config.settings.windows_update){
        try 
        {
            Get-WmiObject win32_quickfixengineering -ComputerName $computer  -Credential $credential -ErrorAction Stop  | Select-Object description,hotfixid | Export-Csv -Path "output\($computer)_wupdate.csv"
        }
        catch 
        {
            write-host 'Failed to fetch Windows Updates'
        }
    }
    #Software
    if($config.settings.software){
        try 
        {
            Get-WmiObject win32_product -ComputerName $computer  -Credential $credential -ErrorAction Stop | Select-Object name | Export-Csv -Path "output\($computer)_mjukvara.csv"    
        }
        catch 
        {
            write-host 'Failed to fetch Softwares'
        }
    }
    #ip
    if($config.settings.ip) {
        try 
        {
            Get-WmiObject win32_networkadapterconfiguration -ComputerName $computer  -Credential $credential -ErrorAction Stop | Select-Object ipaddress,defaultgateway,dnsdomain,dhcpenabled | Export-Csv -Path "output\($computer)_IP.csv"
        }
        catch 
        {
            write-host 'Faield to fetch IP'
        }
    }

    write-host $computer ' Done'

}
#-computer COMPUTERNAME
