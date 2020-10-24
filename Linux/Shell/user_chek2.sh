echo "Uneti ime korisnika:\c"
read logname

terminal=`tty`
ind=1

grep "$logname" /etc/passwd > lista
if [ $? -eq 0 ]
then
	IFS=:
	exec < lista

	while read line
	do
		set $line
		if [ $1 = $logname ]
		then
			echo "Korisnik postoji!"
			ind=0
			break
		fi
	done
	
	exec < $terminal
	IFS=''
	
	if [ $ind -eq 0 ]
	then
		echo "Cekaj..."
	else
		echo "Korisnik ne postoji!"
		exit
	fi

else
	echo "Korisnik ne postoji!"
	exit
fi

time=0

while true
do
	who | grep "$logname" > /dev/null
	if [ $? -eq 0 ]
	then
		if [ $time -ne 0 ]
		then
			if [ $time -gt 60 ]
			then
				min=`expr $min / 60`
				time=`expr $time % 60`
				echo "$logname se ulogovao nakon ${min}m${time}s."
			else
				sec=$time
				echo "$logname se ulogovao nakon ${time}s."
			fi
		else
			echo "$logname je vec ulogovan."
		fi
		exit
	else 
		time=`expr $time + 1`
		sleep 1
	fi
done
