MyList = ["John","Nancy","Mia"]

if ("John" and "Nancy" in MyList):
	print("Condition is True")
else:
	print("Condition is False")
#Dosta mocna fora sa in izrazom. Izgleda da on moze da zameni celokupnu for petlju i da proveri u if-u da li je neki element unutar liste na primer. jako mocno! Sto je jos mocnije, distributivan je prema logickim operatorima sto ce reci da je ispis gore sasvim legitiman iako bi se ocekivalo da mora da pise if (("John" in MyList) and ("Nancy" in MyList)) 

#za proveru da li nije u listi koristimo not in konstrukt

if ("Igor" not in MyList):
	print("Condition is True, no Igor in list")
else:
	print("Condition is False")
