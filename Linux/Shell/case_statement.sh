echo "Uneti karakter:\c"
read var
case $var in
[a-z])
	echo "Uneseno je malo slovo."
	;;
[A-Z])
	echo "Uneseno je veliko slovo."
	;;
[0-9])
	echo "Unesena je cifra."
	;;
?)
	echo "Unesen je simbol."
	;;
*)
	echo "Uneseno je vise karaktera."
	;;
esac

