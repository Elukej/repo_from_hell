def function():
	print("Hello, this is code from the function\n")

print("This is code from our main program\n")
function()



def name(fname = "Dzigi",lname = "Bau"):
	print("Your first name is " + fname)
	print("Your last name is " + lname)
	print("")

name("Luka","Jovanovic")
name("Nada","Jovanovic")
name("Igor","Jovanovic")
name()

#funkcije izgleda mogu da se uvale gde god je neophodno usred toka programa, samo je neophodno da definicija bude pre prvog koriscenja funkcije. Tako pokazuje moja provera, moguce da postoji neka druga kljucna rec izuzev def kojom moze da se deklarise prototip funkcije
#default vrednosti zadajemo isto ko u c++-u i pozivamo praznu fju da bi se one koristile

name(fname = "Deki", lname = "Zvizdo")
name("Djoko")
name(lname = "Zombi")

#vrednosti fje se dodeljuju i direktno preko imena argumenata u pozivu. Kao sto se vidi, na ovaj nacin moze da se uzme default vrednost prvih argumenata a da se zadaju kasniji preskakanjem prvih argumenata u pozivu kompletno! 

def stepen(number, degree):
	result = number ** degree
	return result     #demonstracija povratne vrednosti fje
print (stepen(10,2.1))




