import re 

f = open("input_day5.txt", "r")
maximum = 0
dictionary = {}
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
	dictionary[seatID] = True
	maximum =  seatID if (seatID > maximum) else maximum
print(maximum)
for seat in range(maximum):
	if (dictionary.get(seat, False) == False):
		if (dictionary.get(seat-1, False) and dictionary.get(seat+1, False)):
			print(seat)