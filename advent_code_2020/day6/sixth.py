def nrUniqueEl(string):
	newStr = []
	for c in string:
		if (not c in newStr):
			newStr.append(c)
	return len(newStr)

def minLengthStr(lista):
	newStr = ""
	for string in lista:
		if (len(string) < len(newStr) or newStr == ""):
			newStr = string
	return newStr

def nrCommonEl(lista):
	count = 0
	string = minLengthStr(lista)
	for letter in string:
		ind = True
		for word in lista:
			if (not letter in word):
				ind = False
		count = count +1 if (ind) else count
	return count

f = open("input_day6.txt","r")
fileAsString = f.read()
fileAsList = fileAsString.split("\n\n")
countUnique = 0
countCommon = 0
for x in fileAsList:
	x = x.split("\n")
	y = "".join(x)
	countUnique += nrUniqueEl(y)
	countCommon += nrCommonEl(x)
print(countUnique)
print(countCommon)




