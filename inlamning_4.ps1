#Made by: 
#Emil Privér s183156, Viktor Arvidsson s182768, Pia Hacksell s184823


#Load config
#$config fetching the information you added into config.json
$config = Get-Content -Raw -Path config.json | ConvertFrom-Json
#$computers are now all the clients added to the config file
$computers = @($config.clients)
#$password fetches the password added in the config file and transforms to a secure password
$password = $config.user.password | ConvertTo-SecureString -asPlainText -Force
#$username are domain and username together. DOMAIN\USERNAME
$username = $config.user.domain + '\' + $config.user.username
#$credential fetches the information provided in $password and $username and creates a pscredential to be used when fetching information
$credential = New-Object System.Management.Automation.PSCredential($username, $password) 
#End load coonfig

#log file
$log_file = 'log.txt'


#See if all files that is in need are created
write-host "Looking for needed files, I will create the files i don't find that I need"

#BIOS
if ($config.settings.bios) {
    if ((test-path -Path "output/Bios.csv") -eq $false) {
        New-Item -Path "output/" -Name "Bios.csv" -ItemType "file"
        '"{0}";"{1}";"{2}";"{3}"' -f '"Computer name"', 'Version', '"Manufacturer"', '"Releasedate"' | add-content -Path "output\Bios.csv"         
    }
}

#MotherBoard
if ($config.settings.baseBord) {
    if ((test-path -Path "output/Mboard.csv") -eq $false) {
        New-Item -Path "output/" -Name "Mboard.csv" -ItemType "file"
        '"{0}";"{1}";"{2}";"{3}"' -f 'Computer name',  'Manufacturer', 'Product' , 'SerialNumber' | add-content -Path "output\Mboard.csv"         
    }
}

#CPU
if ($config.settings.proccessor) {
    if ((test-path -Path "output/Cpu.csv") -eq $false) {
        New-Item -Path "output/" -Name "Cpu.csv" -ItemType "file"
        '"{0}";"{1}";"{2}";"{3}";"{4}"' -f 'Computer name',  'Name', 'processortype' , 'Numberofcores', 'numberoflogicalprocessors' | add-content -Path "output\Cpu.csv"         
    }
}
#Ram

if ($config.settings.physical_memory) {
    if ((test-path -Path "output/Ram.csv") -eq $false) {
        New-Item -Path "output/" -Name "Ram.csv" -ItemType "file"
        '"{0}";"{1}";"{2}";"{3}";"{4}";"{5}"' -f 'Computer name',  'devicelocator', 'capacity' , 'manufacturer', 'partnumber' , 'serialnumber' | add-content -Path "output\Ram.csv"         
    }
}

#HDD
if ($config.settings.diskdrive) {
    if ((test-path -Path "output/Hdd.csv") -eq $false) {
        New-Item -Path "output/" -Name "Hdd.csv" -ItemType "file"
        '"{0}";"{1}";"{2}";"{3}";"{4}"' -f 'Computer name',  'Manufacturer', 'Model' , 'SerialNumber', 'Size' | add-content -Path "output\Hdd.csv"         
    }
}

#Logic disks
if ($config.settings.logicaldisk) {
    if ((test-path -Path "output/Hddlogic.csv") -eq $false) {
        New-Item -Path "output/" -Name "Hddlogic.csv" -ItemType "file"
        '"{0}";"{1}";"{2}";"{3}";"{4}"' -f 'Computer name',  'DeviceID', 'Filesystem' , 'size', 'freespace' | add-content -Path "output\Hddlogic.csv"         
    }
}

#Windows Updates
if ($config.settings.windows_update) {
    if ((test-path -Path "output/Wupdate.csv") -eq $false) {
        New-Item -Path "output/" -Name "Wupdate.csv" -ItemType "file"
        '"{0}";"{1}";"{2}"' -f 'Computer name',  'description', 'hotfixid' | add-content -Path "output\Wupdate.csv"         
    }
}

#Softwares
if ($config.settings.software) {
    if ((test-path -Path "output/Software.csv") -eq $false) {
        New-Item -Path "output/" -Name "Software.csv" -ItemType "file"
        '"{0}";"{1}"' -f 'Computer name',  'name'  | add-content -Path "output\Software.csv"         
    }
}

#IP
if ($config.settings.ip) {
    if ((test-path -Path "output/IP.csv") -eq $false) {
        New-Item -Path "output/" -Name "IP.csv" -ItemType "file"
        '"{0}";"{1}";"{2}";"{3}";"{4}"' -f 'Computer', 'IP Adrress', 'Default IP Gateway', 'DNS Domain', 'DHCP Enabled' | add-content -Path "output\IP.csv"         
    }
}
#end see all files

#execute the job   
#Foreach computer that are defined in the config.json file will this loop go thrue.
foreach ($computer in $computers) {
    
    write-host "Starting with $computer" 

    #If computers name = the selected computer
    if (!([string]$env:computername -eq [string]$computer.ToUpper())) {
        #define auth for remote computer
        $auth = @{
            ComputerName = $computer 
            Credential   = $credential
        }
    }
    else {
        #Dont use auth for local computer            
        $auth = ''
    }

    #check if computer is online
    try {
        $check_computer = get-wmiobject @auth -class win32_computersystem -ErrorAction Stop
        if ($check_computer.powersupplystate) {
        #end check if computer is online
            #bios
            #if bios is true
            if ($config.settings.bios) {
                #try to fetch data, else write error
                try {
                    $data = Get-WmiObject win32_bios @auth  -ErrorAction Stop | Select-Object Version, Manufacturer, releasedate -ErrorAction Stop 
                    '"{0}";{1};"{2}";"{3}"' -f [string]$computer,  [string]$data.Version, [string]$data.Manufacturer,[string]$data.releasedate | add-content -Path "output\Bios.csv" 
                }
                catch {
                    write-host "Failed to fetch bios"
                    if ((test-path -Path $log_file) -eq $false) {
                        New-Item -Name $log_file -ItemType "file"
                    }
                    add-content -path $log_file -value "Failed to fetch bios for $computer" $_
                }
            }
            #motherboard
            #if motherboard is true
            if ($config.settings.baseBord) {
                try {
                    #try to fetch data, else write error
                    $data = Get-WmiObject Win32_BaseBoard @auth -ErrorAction Stop | Select-Object Manufacturer, Product , Serialnumber -ErrorAction Stop 
                    '"{0}";"{1}";"{2}";"{3}"' -f [string]$computer,  [string]$data.Manufacturer, [string]$data.Product,[string]$data.Serialnumber | add-content -Path "output\Mboard.csv" 
                }
                catch {
                    write-host "Failed fetching motherboard"
                    if ((test-path -Path $log_file) -eq $false) {
                        New-Item -Name $log_file -ItemType "file"
                    }
                    add-content -path $log_file -value "Failed to fetch motherboard for $computer" $_
                }
            }
            #CPU
            #if cpu ist rue
            if ($config.settings.proccessor) {
                try {
                    #try to fetch data, else write error
                    $data = Get-WmiObject  win32_processor @auth -ErrorAction Stop | Select-Object Name, processortype, Numberofcores, numberoflogicalprocessors 
                    '"{0}";"{1}";{2};{3};{4}' -f [string]$computer,  [string]$data.Name, [string]$data.processortype,[string]$data.Numberofcores, [string]$data.numberoflogicalprocessors  | add-content -Path "output\Cpu.csv" 
                }
                catch {
                    write-host "Could not fetch proccessor"
                    if ((test-path -Path $log_file) -eq $false) {
                        New-Item -Name $log_file -ItemType "file"
                    }
                    add-content -path $log_file -value "Failed to fetch proccessor for $computer" $_
                }
            }
            #ram
            #If ram is set to true
            if ($config.settings.physical_memory) {
                try {
                    #try to fetch data,else write error
                    $data = Get-WmiObject  win32_physicalmemory @auth -ErrorAction Stop  | Select-Object devicelocator , capacity, manufacturer, partnumber, serialnumber 
                    '"{0}";"{1}";"{2}";"{3}";"{4}"' -f [string]$computer,  [string]$data.devicelocator, [string]$data.capacity,[string]$data.manufacturer, [string]$data.partnumber ,[string]$data.serialnumber  | add-content -Path "output\Ram.csv" 
                }
                catch {
                    write-host 'Could not fetch RAM'
                    if ((test-path -Path $log_file) -eq $false) {
                        New-Item -Name $log_file -ItemType "file"
                    }
                    add-content -path $log_file -value "Failed to fetch RAM for $computer" $_
                }
            }
            #HDD
            #if HDD is set to true
            if ($config.settings.diskdrive) {
                try {
                    #try to fetch data else write error
                    $data = Get-WmiObject Win32_DiskDrive @auth -ErrorAction Stop | Select-Object Manufacturer, Model, SerialNumber, Size
                    '"{0}";"{1}";"{2}";"{3}";{4}' -f [string]$computer,  [string]$data.Manufacturer, [string]$data.Model,[string]$data.SerialNumber, [string]$data.Size  | add-content -Path "output\Hdd.csv"  
                }
                catch {
                    write-host 'Could not fetch HDD'
                    if ((test-path -Path $log_file) -eq $false) {
                        New-Item -Name $log_file -ItemType "file"
                    }
                    add-content -path $log_file -value "Failed to fetch HDD for $computer" $_
                }
            }
            #logic disks
            #is logic disk is true
            if ($config.settings.logicaldisk) {
                try {
                    #try to fetch data else write error
                    $data = Get-WmiObject win32_logicaldisk @auth -ErrorAction Stop | Select-Object DeviceID, Filesystem, size, freespace 
                    '"{0}";"{1}";"{2}";{3};{4}' -f [string]$computer,  [string]$data.DeviceID, [string]$data.Filesystem,[string]$data.size, [string]$data.freespace  | add-content -Path "output\Hddlogic.csv"  
                }
                catch {
                    write-host 'Could not fetch Logic disks'
                    if ((test-path -Path $log_file) -eq $false) {
                        New-Item -Name $log_file -ItemType "file"
                    }
                    add-content -path $log_file -value "Failed to fetch Logic disks for $computer" $_
                }
            }
            #windows updates
            #if windows updates is set to true
            if ($config.settings.windows_update) {
                try {
                    #try fetch data else write error
                    $data = Get-WmiObject win32_quickfixengineering @auth -ErrorAction Stop  | Select-Object description, hotfixid 
                    foreach($item in $data){
                        '"{0}";"{1}";{2}' -f [string]$computer,  [string]$item.description, $item.hotfixid | add-content -Path "output\Wupdate.csv" 
                    }
                }
                catch {
                    write-host "Failed to fetch Windows Updates"
                    if ((test-path -Path $log_file) -eq $false) {
                        New-Item -Name $log_file -ItemType "file"
                    }
                    add-content -path $log_file -value "Failed to fetch Windows Updates for $computer" $_
                }
            }
            #Software
            #if software is true
            if ($config.settings.software) {
                try {
                    #try to fetch data else write error
                    $data = Get-WmiObject win32_product @auth -ErrorAction Stop | Select-Object name 
                    '"{0}";"{1}"' -f [string]$computer,  [string]$data.name | add-content -Path "output\Software.csv" 
                }
                catch {
                    write-host "Failed to fetch Softwares"
                    if ((test-path -Path $log_file) -eq $false) {
                        New-Item -Name $log_file -ItemType "file"
                    }
                    add-content -path $log_file -value "Failed to fetch Softwares for $computer" $_
                }
            }
            #ip
            #if ip is true        
            if ($config.settings.ip) {
                try {   
                    #try to fetch data else write error
                    $data = Get-WmiObject win32_networkadapterconfiguration @auth -ErrorAction Stop 
                    $i = 0
                    foreach ($item in $data) {
                        if($item.ipaddress.length){
                            '"{0}";"{1}";"{2}";"{3}";"{4}"' -f $computer,[string]$data[$i].ipaddress, [string]$data[$i].DefaultIPGateway, [string]$data[$i].dnsdomain, [string]$data[$i].dhcpenabled  | add-content -Path "output\IP.csv"                    
                        }
                        $i = $i + 1
                    }
                }
                catch {
                    write-host "Failed to fetch ip"
                    if ((test-path -Path $log_file) -eq $false) {
                        New-Item -Name $log_file -ItemType "file"
                    }
                    add-content -path $log_file -value "Failed to fetch IP for $computer" $_
                }
            }
            #-computer COMPUTERNAME

            write-host $computer ' Done'
        }else {
            write-host $computer " is not online"
            if ((test-path -Path $log_file) -eq $false) {
                New-Item -Name $log_file -ItemType "file"
            }
            add-content -path $log_file -value $computer " is not online"
        }
    }
    catch {
        write-host $computer " is not online"
        if ((test-path -Path $log_file) -eq $false) {
            New-Item -Name $log_file -ItemType "file"
        }
        add-content -path $log_file -value  "$computer is not online. "
    }
}
