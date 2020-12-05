List = ["Book","Apple","Dog","Camel"]
List.sort(reverse = True)
print(List)
List1 = ["Book","Apple","Dog","Camel"]
List1.reverse()
print(List1)
#u pythonu izgleda kada napisemo List1.sort() je ekvivalentno kao da smo napisali List1 = sort(List1)
#Takodje, posto je ovo kao operacija dodele, ne moze direktno da se printuje rezultat List1.reverse(), nego mora tek nakon sto se operacija desi, pa onda lista da se printuje tek u sledcem redu
