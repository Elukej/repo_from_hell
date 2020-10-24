#pokazna skripta za for petlju
dir=~/
for item in ${dir}* 
do
	if [ -d "$item" ]
	then
		echo "$item" | sed 's/.*\///'
	fi
done

#Napomena! Ne pretrazuje direktorije sa razmakom u imenu npr "local sites" 
#direktoriju prijavi kao gresku ukoliko se ne stave "" u [].
#Ukoliko se stave navodnici, sve bude u redu.
