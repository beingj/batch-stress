cmd="ipmitool -U admin"
timeout=3

subdir=subdir
sum=sum.log

rm -fr $subdir
if ! [ -e $subdir ];then
	mkdir $subdir
fi

function ping_test() {
	ip=$1
	ipmitool -U admin -P admin -H $ip raw 6 1 > $subdir/$ip.pid.log &
	ping -c 1 -W $timeout $ip | grep '1 received' > $subdir/$ip.pid2.log &
}

for i in {11..255};do
        # echo $i
	ping_test 192.168.0.$i
done

for i in {0..250};do
	for j in {1..2};do
		# echo $i
		# ipmitool -U admin -P admin -H 192.168.1.$i raw 6 1 > $subdir/192.168.1.$i.pid.log &
		ping_test 192.168.$j.$i
	done
done

i=1
# while [ $(ps ax| gawk -v cmd="$cmd" '$0~$cmd' | wc -l) -ne 0 ];do
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

grep . *.pid2.log | gawk '//{print substr($1,1,length($1)-11)}' > all.ip.log
diff all.ip.log bmc.ip.log | gawk '/</{print $2}' > os.ip.log

mv $sum $dir
mv bmc.ip.log $dir
mv os.ip.log $dir
cd $dir
#rm -fr $subdir

wc -l bmc.ip.log
wc -l os.ip.log
