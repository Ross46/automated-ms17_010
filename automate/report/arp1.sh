#!/bin/bash
echo "**HOSTS AVAILABLE ON NETWORK**">arpscan_ip_mac.txt
date>>arpscan_ip_mac.txt
echo " ">>arpscan_ip_mac.txt
echo "     IP                MAC">>arpscan_ip_mac.txt
echo " ">>arpscan_ip_mac.txt
sed '1d;2d;$d' ../data/clientlist.txt>temp.txt
sed '$d' temp.txt>arpscan.txt
g=`wc -l<arpscan.txt`
cat arpscan.txt |colrm 36 >d.txt
for((i=1;i<=g;i++))
 do
   data=$(sed -n "$i"p d.txt)
   echo "$data">>arpscan_ip_mac.txt
 done
rm arpscan.txt
sed '1d' arpscan_ip_mac.txt>mac1.txt
cat mac1.txt |colrm 13 >arpscan_ip.txt
rm mac1.txt

ip()
{
f=`wc -l<d.txt`
for((k=1;k<=f;k++))
do
ff=$1;
g=`grep "$ff" d.txt`
t=`echo $g |wc -c`
if [ $t -eq 29 ]
then
data3=${g:10}
fi
if [ $t -eq 30 ]
then
data3=${g:11}
fi
if [ $t -eq 31 ]
then
data3=${g:12}
fi
done
}

sed '1d;$d' ../data/port.txt > x.txt
d=`wc -l<x.txt`
sed '/Up/d' x.txt > l.txt
echo " PORT  STATUS          IP     " > finalport.txt
sed 's/Host: //' ../data/port.txt > t.txt
sed 's/(.*//' t.txt > port_ip1.txt
sed '1d;2d;$d' port_ip1.txt > port_ip2.txt
sed 'n; d' port_ip2.txt > k.txt
rm port_ip1.txt
rm t.txt
rm port_ip2.txt
for((i=1;i<d;i++))
 do
   data1=$(sed -n "$i"p k.txt);
   data2=$(sed -n "$i"p l.txt);
   if echo "$data2" | grep -q "open"; then
    echo " 445    open       $data1">>finalport.txt
   fi
   if echo "$data2" | grep -q "closed"; then
    echo " 445   closed      $data1">>finalport.txt
   fi
   if echo "$data2" | grep -q "filtered"; then
    echo " 445  filtered     $data1">>finalport.txt
   fi
 done
rm k.txt
rm x.txt
rm l.txt
rm temp.txt
echo "                  VULNERABILITY SCAN REPORT                      ">finalmsf.txt
b=`date`
echo "                 $b                         ">>finalmsf.txt
echo " ">>finalmsf.txt
echo " VULNERABILITY   PORT            IP                  MAC                OPEATING SYSTEM ">>finalmsf.txt
echo " ">>finalmsf.txt
sed '1d;2d;3d;4d;5d;$d' ../data/msf.txt>msf1.txt
sed '$d' msf1.txt>msf2.txt
sed '$d' msf2.txt>msf3.txt
sed '$d' msf3.txt>msf4.txt
sed '/Scanned/d' ./msf4.txt>msf5.txt
rm msf1.txt
rm msf2.txt
rm msf3.txt
rm msf4.txt
grep -o '0m .*445' msf5.txt>msf6.txt
grep -o ' .*:' msf6.txt>msf7.txt
sed 's/.$//' msf7.txt>msf8.txt
grep likely msf5.txt>l.txt
sed 's/^.*! -//' l.txt>os.txt
y=`wc -l <os.txt`
t=`wc -l <msf5.txt`
for((i=1;i<=y;i++))
 do
opera[i]=$(sed -n "$i"p os.txt);
 done
rm msf6.txt
rm msf7.txt
q=1;
for((i=1;i<=t;i++))
 do
   data1=$(sed -n "$i"p msf5.txt);
   data2=$(sed -n "$i"p msf8.txt);
   if echo "$data1" | grep -q "likely"; then
       ip $data2
    echo "    Likely       445      $data2       $data3     ${opera[q]} ">>finalmsf.txt
    q=$((q+1));
   fi
   if echo "$data1" | grep -q "NOT"; then

     ip $data2
    echo " Not vulnerable  445      $data2       $data3      Unknown">>finalmsf.txt
   fi
 done
rm msf5.txt
rm os.txt
rm l.txt
rm msf8.txt
rm d.txt
rm arpscan_ip.txt
./print1.sh
exit

