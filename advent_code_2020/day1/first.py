f = open("input.txt", "r")
lista = []
t1 = 0
for x in f:
	t = int(x)
	lista.append(t) 
	for y in lista:
		if (y + t == 2020):
			t1 = y
			break
	if (t1 != 0):
		print("x = " + str(t) + ", y = " + str(t1) + ", x*y =  " + str(t*t1))
		break
