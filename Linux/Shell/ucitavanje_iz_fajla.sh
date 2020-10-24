echo "Unesi ime fajla:\c"
read fname
if [ -z  $fname ]
then
	exit
fi

terminal=`tty`

exec < $fname

count=1
while read line
do
	echo "${count}.${line}"
	count=`expr $count + 1`
done
exec < $terminal

#OVA SKRIPTA DEMONSTRIRA CITANJE IZ FAJLA POMOCU exec KOMANDE. DA BI SE 
#FAJL PROCITAO NEOPHODNO JE PREUSMERITI STANDARDNI ULAZ U FAJL
#UPRAVO OVO RADI exec KOMANDA. NA KRAJU JE NEOPHODNO VRATITI ULAZ TAMO GDE JE
#BIO. STANDARDNI ULAZ SE CUVA U tty PROMENLJIVOJ
