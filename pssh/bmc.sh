ipf=bmc-ip.txt
ipf=bmc.ip.log
cmd="$*"

bg=0

if [ $1 == "b" ];then
	bg=1
	shift
	cmd="$*"
fi

# for i in `cat $ipf | grep -v q | gawk '{print $4}'`;do
for i in `cat $ipf|grep -v '#'`;do
	if [ $bg -eq 1 ];then
		ipmitool -H $i -U admin -P admin $cmd > /dev/null 2>&1 &
	else
		echo -n "$i => "
		ipmitool -H $i -U admin -P admin $cmd
	fi
	# echo "$i"
	# ipmitool -H $i -U admin -P admin $cmd | gawk '/192/{print $0}/Entries/{if ($3!=1){print $3}}'
	# ipmitool -H $i -U admin -P admin $cmd > $i.dumpsel.log &
	# ipmitool -H $i -U admin -P admin sel info > $i.dumpsel.log &
	# ipmitool -H $i -U admin -P admin sel list >> $i.dumpsel.log &
	# echo
done
