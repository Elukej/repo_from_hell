#Ovo je fajl za demonstraciju if then ponasanja
echo "Upisati ime izvornog i ciljnog fajla"
read source target
if mv $source $target
then echo "Uspesno preimenovanje $source u $target"
else echo "Neuspesno. Fajl nije preimenovan"
fi
