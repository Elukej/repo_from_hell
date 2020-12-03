direction = [(1,1),(3,1),(5,1),(7,1),(1,2)]
index = 0
countTrees = 0
lista = []
for (right,down) in direction:
	f = open("input_day3.txt", "r")
	downCheck = 0
	for x in f:
		if (downCheck == 0 or (downCheck % down != 0)):
			downCheck += 1
			continue
		downCheck += 1
		index = (index + right) % (len(x)-1)
		if (x[index] == "#"):
			countTrees += 1

	lista.append(countTrees)
	countTrees = 0
	index = 0
acc = 1
for i in lista:
	acc *= i
print(lista)
print(acc)


