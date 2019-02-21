BEFORE YOU RUN THE SCRIPT
- Make sure you have downloaded inlaming_4.ps1 config.json , log.txt and readme.md.
- Make sure 'output' map exists in the folder you have the files in.

HOW TO USE
- Define witch data you want in the config.json file and name of the computers you want information from.
- if you want to add a computer name hej123 then you add 'hej123' to the array named clients. ex = ['Klient01', 'hej123']
- You add true to the information you want and false to the information you dont need.
- Before you run the script, please check the information under user. Add the right domain and username and password. The username should be and administrator.

- HOW THE SCRIPT WORKS
- when you run the script will the script fetch all information from the config.json file
- the script will after that create an login to use while the system fetches information from other systems.
- The script will create all files the script needs
- foreach computer defined in the config.json file will the script loop thrue and execute commands
- the script will then add information to respective file


INFORMATION
The script will get all info and print it to the output mapp.
If any error will happen, the script will print the error to log file. If file dont exists then the file will be created and used.

HOW THIS SCRIPT CAN BE USED
This script can be used by an domain admin to fetch informatin about all computers. For exempel fetch alla softwares that computers on the domain have installed.

EXAMPLE OF OUT DATA TO CSV FILES
In this exempel we fetch softwars:
Computer Name, Name
Klient01, Spotify
Klient01, Chrome
Klient01, Edge
Klient01, Steam
Klient02, Spotify
Klient02, Chrome
Klient02, Edge
Klient02, Visual Studio Code


EXAMPLE FOR DATA BIOS
COMPUTER NAME - VERSION - MANUFACTURER - RELEASEDATE
Klient01 - HPQOEM - 1072009 - Hewlett-Packard -20150219000000.000000+000

EXAMPLE FOR DATA CPU
COMPUTER NAME - NAME - PROCESSORTYPE - NUMBER OF CORES - NUMBEROFLOGICALPROCESSORS
Klient01 - "Intel(R) Core(TM) i5-2500S CPU @ 2.70GHz" - 3 - 4 - 4


EXAMPLE FOR DATA HDD
"Computer name";"Manufacturer";"Model";"SerialNumber";"Size"
"Klient01";"(Standard disk drives)";"MTFDDAK128MAM-1J1";"        1223090C777E";128034708480

EXAMPLTE FOR DATA HDDLOGIC
"Computer name";"DeviceID";"Filesystem";"size";"freespace"
"Klient01";"C: D:";"NTFS ";127389396992 ;86200963072 

EXAMPLRE FOR DATA IP 
"Computer";"IP Adrress";"Default IP Gateway";"DNS Domain";"DHCP Enabled"
"Klient01";"172.17.230.113";"";"";"False"

EXAMPLE FOR DATA MBOARD
"Computer name";"Manufacturer";"Product";"SerialNumber"
"Klient01";"Hewlett-Packard";"3395";"CZC2288TCW"

EXAMPLE FOR DATA RAM
"Computer name";"devicelocator";"capacity";"manufacturer";"partnumber";"serialnumber"
"Klient01";"DIMM1 DIMM3";"4294967296 4294967296";"Hynix Semiconduc Hynix Semiconduc";"HMT351S6CFR8C-H9   HMT351S6CFR8C-H9  "

EXAMPLE FOR DATA SOFTWARE
"Computer name";"name"
"Klient01";"Microsoft Visual C++ 2015 x64 Minimum Runtime - 14.0.24215 Microsoft Visual C++ 2015 x86 Minimum Runtime - 14.0.24215 Microsoft Visual C++ 2015 x64 Additional Runtime - 14.0.24215 Google Update Helper Microsoft Visual C++ 2015 x86 Additional Runtime - 14.0.24215 VMware Workstation"

EXAMPLE FOR DATA HOTFIXID
"Computer name";"description";"hotfixid"
"Klient01";"Update";KB4483452


In this case Computer Name are the name of the computer the script fetch information from. and Name are the name of the software.
