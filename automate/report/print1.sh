#!/bin/bash
cat ../data/exploit.txt | grep -o '> .*:' | sed 's/> //' | sed 's/:.*//' | sed 's/[^ ]* //' | sort -u > ip.txt
grep Computer ../data/exploit.txt -A 6 >extract2.txt
grep "Session ID 1" ../data/exploit.txt >ips.txt
grep -o '> .*:' ips.txt>ips1.txt
sed 's/> //' ips1.txt > t.txt
sed 's/://' t.txt > t1.txt
h=`wc -l<extract2.txt`
i=0
cat extract2.txt>r0.txt
h=$((h+1))
p=1
l=0
t="r0.txt"
j=1
for((i=7;i<=h;i+=8))
do
dd=": $(cat arpscan_ip_mac.txt | grep -w $( sed ${j}!d ip.txt))"
y="r$i.txt"
sed -e "${i}s/.*/IP and MAC      ${dd}/ " $t>$y
rm $t
t=$y
p=$((p+1))
j=$((j+1))
done
cat "$y">g.txt
rm $y
rm t1.txt
rm t.txt
rm ips.txt
rm ips1.txt
g=`wc -l < g.txt`
l=$((g/8))
f=8
for((i=1;i<=g;i+=8))
do
  comp[i]=$(sed -n "$i"p g.txt);
done
for((i=1;i<=g;i+=8))
do
  flag=0
  for((j=i+f;j<=g;j+=8))
    do
        if [ "${comp[i]}" == "${comp[j]}" ]
          then
            flag=1;
        fi
    done
   if [ $flag -eq 0 ]
    then
       r=i+8
       for((k=i;k<r;k++))
          do
             save=$(sed -n "$k"p g.txt)
             echo "$save" >> finalexploit.txt
          done
   fi
done
rm extract2.txt
rm g.txt
rm ip.txt
exit
