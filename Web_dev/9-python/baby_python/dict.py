dic = {"Toyota":"Camry","Cylinder":"v6"}

print (dic["Toyota"])
print(dic["Cylinder"])
#ovo je pythonova verzija mape izgleda. Elementi se ispisuju izmedju dve {} zagrade u formatu <key> : <value>
#Novu vrednost dodajemo na sledeci nacin
dic["Color"] = "White"
print(dic["Color"])
print(dic)
dic["Number"] = 3
print(dic)
dic[7]=2
print(dic)
print(dic[7])
#Ovo cudo izgleda dopusta sve moguce i nemoguce formate kljuceva u jednom jedinom pakovanju recnika. Takodje ni vrednost ne mora da bude istog formata, i python nikakve probleme ne pravi. POprilicno fascinantno!

dic[7] = "bla"
print(dic)
#Sto je jos neverovatnije, podrzava dinamicku promenu tipa vrednosti iz npr int u string kao sto se vidi iznad. Potpuno neverovatno!!!(vrednost dic[7] je bila 2, tj integer, a psole promene je postala "bla" tj string!!!)

#brisanje iz recnika
del dic["Toyota"]
print("After deletion " + str(dic))




