#!/bin/sh
# Program:
#	This program detect new app's process on android, and 
#	use strace to monitor its status of system call.
#	Strace will be ended when the app is killed.
#
#	This is for the strace experiment:
#	1).run this script on the device in root
#	2).manually run the apps one by one, kill the running one before start the nest
#	3).for each app, do some normal operation for a same time
#	4).system call log files will be generated
# History:
# 2016/01/08	madgd	1 dev
#
#path for android
PATH=/system/bin:/system/xbin/
#PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#wait 5 sec
sleep 5
#number of straced apps
count=0
#pid sum before start experiment
pidNum=$(ps | grep u0 | wc | awk '{print $1}')
#num=$(ps -ef | egrep -v 'ps|egrep|wc|awk' | wc | awk '{print $1}')
#echo $pidNum

#original pids
ori=$(ps | grep u0 | awk '{print $2}' ORS='|')
ori=${ori%\|}
echo $ori

#start monitor
while true; do
	#new sum of pids
	newPidNum=$(ps | grep u0 | wc | awk '{print $1}')
	echo $newPidNum
	
	#if there is more pids
	if [ "$newPidNum" -gt "$pidNum" ];then
		echo 'appear'
		#count user process num
		#num=$(ps | grep u0 | wc | awk '{print $1}')
		#echo $num
		
		#get the user name of the new app
		#echo user=$(ps | grep u0 | awk "NR==$num{print}" | awk '{print $1}')
		#user=$(ps | grep u0 | awk "NR==$num{print}" | awk '{print $1}')
		
		#wait the app to finish the launch
		sleep 5
		
		#get its pid(s)
		#echo "ids=$(ps | grep $user | awk '{print $2}' ORS=',')"
		ids=$(ps | grep u0 | egrep -v "$ori" | awk '{print $2}')
		echo $ids
		
		#total number of the son pids
		all=$(echo $ids | wc | awk '{print $2}')
		
		
		#strace them and save
		#order of the son pids of the running app
		order=1
		
		#loop to strace on every son pids
		for var in $ids
		do
			#if not the last one, do it in background
			if [ $order == $all ];then
				strace -o /sdcard/straceResults/${count}-${order}.txt -p $var
			else
				strace -o /sdcard/straceResults/${count}-${order}.txt -p $var &
			fi
			order=$(($order+1))
		done
		#echo "strace -f -o /sdcard/straceResults/${count}-${user}.txt -p $ids"
		#echo "strace -o /sdcard/straceResults/${count}${user}.txt -p $ids"
		#strace -o /sdcard/straceResults/${count}-${user}.txt -p $ids
		#strace -o /sdcard/straceResults/1111.txt -p 10805
		
		count=$(($count+1))	
	fi
	
	echo $count
	#sleep
	sleep 2
done
