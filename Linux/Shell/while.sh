#while petlja u akciji
count=1
while [ $count -le 10 ]
do
	echo $count
	count=`expr $count + 1`
done

#BITNE NAPOMENE:
#SHELL JAVLJA GRESKU UKOLIKO IMA RAZMAK IZMEDJU COUNT I JEDNAKO ILI JEDNAKO
#I VREDNOSTI. Ista prica i kod expr, ne sme razmak nikako
