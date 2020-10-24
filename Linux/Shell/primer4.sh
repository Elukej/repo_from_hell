echo "Upisi broj izmedju 50 i 100:\c"
read num
if [ $num -le 100 -a $num -ge 50 ]
then
	echo "broj je u opsegu."
else
	echo "broj nije u opsegu."
fi
