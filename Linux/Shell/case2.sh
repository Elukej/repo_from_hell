echo "Uneti rec:\c"
read word
case $word in
[aeiou]* | [AEIOU]*)
			echo "Rec pocinje samoglasnikom."
			;;
[0-9]*)
			echo "Rec pocinje cifrom." 
			;;
*[0-9])
			echo "Rec se zavrsava cifrom."
			;;
???)
			echo "Uneli ste 3-slovnu rec."
			;;
*)
			echo "Ne znamo sta ste uneli"
			;;
esac
