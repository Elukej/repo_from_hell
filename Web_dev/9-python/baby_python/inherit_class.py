class Person ():    #ime klase mora velikim slovom da pocne
	def __init__(self,name,age,IdNum):   #__init__ je ugradjeno ime za konstruktor u pythonu
		self.name = name
		self.age = age
		self.IdNum = IdNum
	def output(self):
		print("My name is",self.name,". My age is",self.age,"and my ID is",self.IdNum)

class Man():
	def strong(self):		#self izgleda mora da se stavi uvek kao argument f-ja u klasi
		print("Men are strong,kids are weak")

class Child(Person,Man):
	pass	#ovo je kljucna rec za nasledjivanje, a klasa koja se nasledjuje ide gore u zagrade

kid = Child("Johnny","5","2900123")
kid.output()
kid.strong()
