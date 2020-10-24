echo "Unesi karakter"
read var
if [ `echo $var | wc -c` -eq 2 ]
then
	echo "Ispravan karakter"
else
	echo "Neispravan unos"
fi
