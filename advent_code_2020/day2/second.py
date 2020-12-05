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
	count = 0
	while (x[i].isalpha() and i < len(x)):
		if (x[i] == letter):
			count += 1
		i += 1
	if (count >= lower and count <= upper):
		lista.append(x)

print(len(lista))



