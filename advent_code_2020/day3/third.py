f = open("input_day3.txt", "r")
right = 3
index = 0
countTrees = 0
for x in f:
	if (x[index] == "#"):
		countTrees += 1
	index = (index + right) % (len(x)-1)
print(countTrees)

