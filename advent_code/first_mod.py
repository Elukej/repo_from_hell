f = open("input.txt", "r")
lista = []
t = 0
for x in f:
	t1 = int(x)
	lista.append(t1) 
	for y in range(len(lista)-1):
		t2 = lista[y]
		if (t2 + t1 > 2020):
			continue
		for z in  range(y+1, len(lista)-1):
			if (t2 + t1 + lista[z] == 2020):
				t = lista[z]
				print("x = " + str(t) + ", y = " + str(t1) + ", z = " + str(t2) + ", x*y*z =  " + str(t*t1*t2))
		if (t != 0):
			break
	if (t != 0):
		break

