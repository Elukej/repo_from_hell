import re 

f = open("input_day5.txt", "r")
maximum = 0
for x in f:
	y = x[:-1]
	upperRow = 127
	lowerRow = 0
	upperColumn = 7
	lowerColumn = 0
	seatID = 0
	if (re.search("^([FB]{7})+([LR]{3})$", y)):
		for letter in y:
			if (letter == 'B'):
				lowerRow += (upperRow - lowerRow) // 2 + 1
			elif (letter == 'F'):
				upperRow = lowerRow + (upperRow - lowerRow) // 2
			elif (letter == 'L'):
				upperColumn = lowerColumn + (upperColumn - lowerColumn) // 2
			elif (letter == 'R'):
				lowerColumn += (upperColumn - lowerColumn) // 2 + 1
	else:
		continue
	#print(str(upperRow) + " " + str(lowerRow) + " " + str(lowerColumn) + " " + str(upperColumn))
	seatID = upperRow * 8 + upperColumn
	maximum =  seatID if (seatID > maximum) else maximum
print(maximum)