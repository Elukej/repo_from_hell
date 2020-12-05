ProgLang = ['c++','python','php','swift 4']
cpy_Prog_Lang = ProgLang[1:2]
#koriscenjem slice operatora mozemo da odredimo koji deo liste zelimo unutar nase kopije
print("Printing programming languages list here")
print(ProgLang)

print("Printing copy")
print(cpy_Prog_Lang)

cpy_Prog_Lang.append('Java')
print(cpy_Prog_Lang)
#append funkcija je dakle za dodavanje elemenata u listu
