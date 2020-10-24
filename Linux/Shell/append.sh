echo "Unesi ime fajla:\c"
read fname
if [ -f $fname ]
then
	if [ -w $fname ]
	then
		echo "Upisi tekst za dodavanje. Izadji sa ctrl+d"
		cat >> $fname
	else
		echo "Nemate odgovarajucu dozvolu za pisanje"
fi
fi
