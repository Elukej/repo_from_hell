class Person ():    #ime klase mora velikim slovom da pocne
	def __init__(self,name,age,IdNum):   #__init__ je ugradjeno ime za konstruktor u pythonu
		self.name = name
		self.age = age
		self.IdNum = IdNum
	def output(self):
		print("My name is",self.name,". My age is",self.age,"and my ID is",self.IdNum)
j = Person("John","33","1208942350")
j.output()
#funkcija insert u proslom fajlu je bila neki kurcev konstruktor a ovo je pravi pythonov izgleda.
#valja potraziti malo dublje ovu kljucnu rec self. izgleda da je ona neki ekvivalent kljucne reci this iz c++

print(j.name)
print(j.age)
print(j.IdNum)
#ovako se pristupa stampanju pojedinacnih promenljivih

x = Person("Rodrigo","22","12343409")
x.output()
