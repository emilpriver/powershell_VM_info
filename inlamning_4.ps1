#computers
#HOW TO USE
#Define witch data you want in the config.json file and name of the computers you want information from.
#The script will get all info and print it to the output mapp.


$config = Get-Content -Raw -Path config.json | ConvertFrom-Json
$computers = @($config.clients)
$password = $config.user.password | ConvertTo-SecureString -asPlainText -Force
$username = $config.user.domain + '\' + $config.user.username
$credential = New-Object System.Management.Automation.PSCredential($username, $password) 

#check fiels
write-host "Looking for needed files, I will create the files i don't find that I need"
#BIOS
if ($config.settings.bios) {
    if ((test-path -Path "output/Bios.csv") -eq $false) {
        New-Item -Path "output/" -Name "Bios.csv" -ItemType "file"
        "{0},{1},{2},{3}" -f 'Computer name', 'Version', 'Manufacturer', 'Releasedate' | add-content -Path "output\Bios.csv"         
    }
}
#MotherBoard
if ($config.settings.baseBord) {
    if ((test-path -Path "output/Mboard.csv") -eq $false) {
        New-Item -Path "output/" -Name "Mboard.csv" -ItemType "file"
        "{0},{1},{2},{3}" -f 'Computer name',  'Manufacturer', 'Product' , 'SerialNumber' | add-content -Path "output\Mboard.csv"         
    }
}
#CPU
if ($config.settings.proccessor) {
    if ((test-path -Path "output/Cpu.csv") -eq $false) {
        New-Item -Path "output/" -Name "Cpu.csv" -ItemType "file"
        "{0},{1},{2},{3},{4}" -f 'Computer name',  'Name', 'processortype' , 'Numberofcores', 'numberoflogicalprocessors' | add-content -Path "output\Cpu.csv"         
    }
}


#Ram
if ($config.settings.physical_memory) {
    if ((test-path -Path "output/Ram.csv") -eq $false) {
        New-Item -Path "output/" -Name "Ram.csv" -ItemType "file"
        "{0},{1},{2},{3},{4},{5}" -f 'Computer name',  'devicelocator', 'capacity' , 'manufacturer', 'partnumber' , 'serialnumber' | add-content -Path "output\Ram.csv"         
    }
}

#HDD
if ($config.settings.diskdrive) {
    if ((test-path -Path "output/Hdd.csv") -eq $false) {
        New-Item -Path "output/" -Name "Hdd.csv" -ItemType "file"
        "{0},{1},{2},{3},{4}" -f 'Computer name',  'Manufacturer', 'Model' , 'SerialNumber', 'Size' | add-content -Path "output\Hdd.csv"         
    }
}
#Logic disks
if ($config.settings.logicaldisk) {
    if ((test-path -Path "output/Hddlogic.csv") -eq $false) {
        New-Item -Path "output/" -Name "Hddlogic.csv" -ItemType "file"
        "{0},{1},{2},{3},{4}" -f 'Computer name',  'DeviceID', 'Filesystem' , 'size', 'freespace' | add-content -Path "output\Hddlogic.csv"         
    }
}
#Windows Updates
if ($config.settings.windows_update) {
    if ((test-path -Path "output/Wupdate.csv") -eq $false) {
        New-Item -Path "output/" -Name "Wupdate.csv" -ItemType "file"
        "{0},{1},{2}" -f 'Computer name',  'description', 'hotfixid' | add-content -Path "output\Wupdate.csv"         
    }
}
#Softwares
if ($config.settings.software) {
    if ((test-path -Path "output/Software.csv") -eq $false) {
        New-Item -Path "output/" -Name "Software.csv" -ItemType "file"
        "{0},{1}" -f 'Computer name',  'name'  | add-content -Path "output\Software.csv"         
    }
}
#IP
if ($config.settings.ip) {
    if ((test-path -Path "output/IP.csv") -eq $false) {
        New-Item -Path "output/" -Name "IP.csv" -ItemType "file"
        "{0},{1},{2},{3},{4}" -f 'Computer', 'IP Adrress', 'Default IP Gateway', 'DNS Domain', 'DHCP Enabled' | add-content -Path "output\IP.csv"         
    }
}

#Foreach computer that the user want to get information from
foreach ($computer in $computers) {
    #check if computer is up
    if (Test-Connection -ComputerName $computer -Count 1 -Quiet ) {
        #If computers name = the selected computer
        if (!([string]$env:computername -eq [string]$computer.ToUpper())) {
            $auth = @{
                ComputerName = $computer 
                Credential   = $credential
            }
        }
        else {
            $auth = ''
        }
        #bios
        if ($config.settings.bios) {
            try {
                $data = Get-WmiObject win32_bios @auth -ErrorAction Stop | Select-Object Version, Manufacturer, releasedate -ErrorAction Stop 
                "{0},{1},{2},{3}" -f [string]$computer,  [string]$data.Version, [string]$data.Manufacturer,[string]$data.releasedate | add-content -Path "output\Bios.csv" 
            }
            catch {
                write-host 'Failed to fetch bios'
            }
        }
        #motherboard
        if ($config.settings.baseBord) {
            try {
                $data = Get-WmiObject Win32_BaseBoard @auth -ErrorAction Stop | Select-Object Manufacturer, Product , Serialnumber -ErrorAction Stop 
                "{0},{1},{2},{3}" -f [string]$computer,  [string]$data.Manufacturer, [string]$data.Product,[string]$data.Serialnumber | add-content -Path "output\Mboard.csv" 
            }
            catch {
                write-host 'Failed fetching motherboard'
            }
        }
        #CPU
        if ($config.settings.proccessor) {
            try {
                $data = Get-WmiObject  win32_processor @auth -ErrorAction Stop | Select-Object Name, processortype, Numberofcores, numberoflogicalprocessors 
                "{0},{1},{2},{3},{4}" -f [string]$computer,  [string]$data.Name, [string]$data.processortype,[string]$data.Numberofcores, [string]$data.numberoflogicalprocessors  | add-content -Path "output\Cpu.csv" 
            }
            catch {
                write-host 'Could not fetch proccessor'
            }
        }
        #ram
        if ($config.settings.physical_memory) {
            try {
                $data = Get-WmiObject  win32_physicalmemory @auth -ErrorAction Stop  | Select-Object devicelocator , capacity, manufacturer, partnumber, serialnumber 
                "{0},{1},{2},{3},{4},{5}" -f [string]$computer,  [string]$data.devicelocator, [string]$data.capacity,[string]$data.manufacturer, [string]$data.partnumber ,[string]$data.serialnumber  | add-content -Path "output\Ram.csv" 
            }
            catch {
                write-host 'Could not fetch RAM'
            }
        }
        #HDD
        if ($config.settings.diskdrive) {
            try {
                $data = Get-WmiObject Win32_DiskDrive @auth -ErrorAction Stop | Select-Object Manufacturer, Model, SerialNumber, Size
                "{0},{1},{2},{3},{4}" -f [string]$computer,  [string]$data.Manufacturer, [string]$data.Model,[string]$data.SerialNumber, [string]$data.Size  | add-content -Path "output\Hdd.csv"  
            }
            catch {
                write-host 'Could not fetch HDD'
            }
        }
        #logic disks
        if ($config.settings.logicaldisk) {
            try {
                $data = Get-WmiObject win32_logicaldisk @auth -ErrorAction Stop | Select-Object DeviceID, Filesystem, size, freespace 
                "{0},{1},{2},{3},{4}" -f [string]$computer,  [string]$data.DeviceID, [string]$data.Filesystem,[string]$data.size, [string]$data.freespace  | add-content -Path "output\Hddlogic.csv"  
            }
            catch {
                write-host 'Could not fetch Loguic disks'
            }
        }
        #windows updates
        if ($config.settings.windows_update) {
            try {
                $data = Get-WmiObject win32_quickfixengineering @auth -ErrorAction Stop  | Select-Object description, hotfixid 
                "{0},{1},{2},{3},{4}" -f [string]$computer,  [string]$data.description, $data.hotfixid | add-content -Path "output\Wupdate.csv" 
            }
            catch {
                write-host 'Failed to fetch Windows Updates'
                write-host $_
            }
        }
        #Software
        if ($config.settings.software) {
            try {
                $data = Get-WmiObject win32_product @auth -ErrorAction Stop | Select-Object name 
                "{0},{1}" -f [string]$computer,  [string]$data.name | add-content -Path "output\Software.csv" 
            }
            catch {
                write-host 'Failed to fetch Softwares'
            }
        }
        #ip
        if ($config.settings.ip) {
            try {   
                $data = Get-WmiObject win32_networkadapterconfiguration @auth -ErrorAction Stop 
                $i = 0
                foreach ($item in $data) {
                    "{0},{1},{2},{3}" -f [string]$data[$i].ipaddress, [string]$data[$i].DefaultIPGateway, [string]$data[$i].dnsdomain, [string]$data[$i].dhcpenabled  | add-content -Path "output\IP.csv"                    
                    $i = $i + 1
                }
            }
            catch {
                write-host 'failed to fetch ip'
            }
        }
        #-computer COMPUTERNAME

        write-host $computer ' Done'
    }
    else {
        write-host $computer " is not online"
    }
}
#-computer COMPUTERNAME
