#until petlaj u akciji
count=1
until [ $count -ge 10 ]; do
	echo $count
	count=`expr $count + 1`
done

#BITNE NAPOMENE:
#DO MOZE U ISTU LINIJU SA WHILE UKOLIKO SE POSLE
#UGLASTIH ZAGRADA STAVI ; A U SUPROTNOM PROGRAM
#JAVLJA GRESKU
