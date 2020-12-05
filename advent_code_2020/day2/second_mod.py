f = open("input_day2.txt", "r")
lista = []
for x in f:
	i = 0
	lower = 0
	upper = 0
	letter = ""
	while (x[i] != "-"):
		lower = 10 * lower + int(x[i]) 
		i += 1 
	i += 1 
	while (x[i] != " "):
		upper = 10 * upper + int(x[i]) 
		i += 1
	i += 1
	letter = x[i]
	i += 1
	while ( not(x[i].isalpha())):
		i += 1
	ind = 0
	if (i+lower-1 < len(x) and x[i+lower-1] == letter):
		ind += 1
	if (i+upper-1 < len(x) and x[i+upper-1] == letter):
		ind += 1	
	if (ind % 2 == 1):
		lista.append(x)
print(len(lista))



