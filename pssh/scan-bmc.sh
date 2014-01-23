cmd="ipmitool -U admin"
timeout=3

subdir=subdir
sum=sum.log

if ! [ -e $subdir ];then
	mkdir $subdir
fi

# for i in {1..5};do
# 	$cmd $i > $subdir/$i.pid.log &
# done

for i in {11..255};do
        # echo $i
        ipmitool -U admin -P admin -H 192.168.0.$i raw 6 1 > $subdir/192.168.0.$i.pid.log &
done

for i in {0..255};do
        # echo $i
        ipmitool -U admin -P admin -H 192.168.1.$i raw 6 1 > $subdir/192.168.1.$i.pid.log &
done

for i in {0..255};do
        # echo $i
        ipmitool -U admin -P admin -H 192.168.2.$i raw 6 1 > $subdir/192.168.2.$i.pid.log &
done

i=1
while [ $(ps ax| grep "$cmd" | grep -v grep | wc -l) -ne 0 ];do
	if [ $i -gt $timeout ];then
		echo timeout
		ps ax|gawk -v cmd="$cmd" '$0~cmd{print $1}'|xargs kill -9 > /dev/null 2>&1
	fi
	let i+=1
	# echo sleep $i
	echo -n "$i "
	sleep 1
done

echo
echo

dir=$(pwd)
cd $subdir
rm -f $sum
for i in $(ls *|sort);do
	echo $i >> $sum
	cat $i >> $sum
done

grep . *.pid.log | gawk '//{print substr($1,1,length($1)-9)}' > bmc.ip.log

mv $sum $dir
mv bmc.ip.log $dir
cd $dir
#rm -fr $subdir

wc bmc.ip.log
