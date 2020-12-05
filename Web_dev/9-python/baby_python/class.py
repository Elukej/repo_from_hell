class Person ():    #ime klase mora velikim slovom da pocne
	def insert(self,name,age,IdNum):
		self.name = name
		self.age = age
		self.IdNum = IdNum
	def output(self):
		print("My name is",self.name,". My age is",self.age,"and my ID is",self.IdNum)
j = Person()
j.insert("John","33","1208942350")
j.output()
