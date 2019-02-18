HOW TO USE
Define witch data you want in the config.json file and name of the computers you want information from.
if you want to add a computer name hej123 then you add 'hej123' to the array named clients. ex = ['Klient01', 'hej123']
You add true to the information you want and false to the information you dont need.
Before you run the script, please check the information under user. Add the right domain and username and password. The username should be and administrator.

INFORMATION
The script will get all info and print it to the output mapp.
If any error will happen, the script will print the error to log file. If file dont exists then the file will be created

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

In this case Computer Name are the name of the computer the script fetch information from. and Name are the name of the software.
