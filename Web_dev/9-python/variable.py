### #! /usr/bin/python neko shabang sranje koje daje lokaciju pythonovog interpretera na serveru

print("Content-type: text/html") #napomena za interpreter da radi sa htmlom

age=35
print(age)
 
pi=3.14
print(pi)
 
name="Luka"
print(name)

print (age/pi)

number = "5"
print(number * age) #mnozenje stringa celim brojem radi repeticiju stringa

print (int(number) * pi)

str = "My name is Luka"

print (str[0])
print (str[0:5])
print (str[-6])
print(str[::-1])

myList = ["Luka", "Nada" , "Igor"]
print (myList)
print (myList[1])

myTuple = (1,2,3,4)
print (myTuple)

print (myTuple[2])

dict = {}
dict["father"] = "Igor"
dict["mother"] = "Danica"
dict[1] = "Nada"
dict[2] = "Luka"
print (dict)
print (dict["mother"])
print (dict.keys())
print (dict.values())
