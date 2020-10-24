#Fajl koji pokazuje elif kako radi
echo "Upisi broj izmedju 10 i 20:\c"
read num
if [ $num -lt 10 ]
then
	echo "Broj je manji od 10."
elif [ $num -gt 20 ]
then
	echo "Broj je veci od 20."
else
	echo "Dobar broj"
fi
#pored -lt i -gt(lesser than, greater than) postoje i 
#-eq(equal), -ne(not equal), -le(lesser or equal), -ge(greater or equal)
#ista linija
#svi operatori za if izraz mogu se pogledati sa 'man [' komandom, ili 'man test'
#Svaka od ovih komandi pravi svoj exit status (0 ako je sve u redu, 1 ako nije prosla kako treba), koji se proverava sa komandom $?
