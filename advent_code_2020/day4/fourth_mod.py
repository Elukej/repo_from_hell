#Brojac ispravnih pasosa
def elem(string,a,b):
	if (string.isnumeric()):
		return(int(string) >= a and int(string) <= b)
	return False

def iscolor(number):
	if (number[0] != "#"):
		return False
	if (len(dictionary[key]) != 7):
		return False
	try:
		int (str(number[1:]),16)
	except:
		return False
	return True

def isValid(key, dictionary):
		if (dictionary[key] == "" and key != "cid"):
			return False
		if (key == "byr" and not(elem(dictionary[key],1920,2002))):
			return False
		if (key == "iyr" and not(elem(dictionary[key],2010,2020))):
			return False
		if (key == "eyr" and not(elem(dictionary[key],2020,2030))):
			return False
		if (key == "hgt" and not(dictionary[key].isalnum())):
			return False
		elif (key == "hgt" and dictionary[key].isalnum()):
				if (dictionary[key][-2:] == "cm"):
					if (not elem(dictionary[key][:-2],150,193)):
						return False
				elif (dictionary[key][-2:] == "in"):
					if (not elem(dictionary[key][:-2],59,76)):
						return False
				else:
						return False
		if (key == "pid" and not((dictionary[key].isnumeric() and len(dictionary[key]) == 9))):
				return False
		if (key == "hcl" and not(iscolor(dictionary[key]))):
				return False
		if (key == "ecl" and (dictionary[key] not in ["amb","blu","brn","gry","grn","hzl","oth"])):
				return False
		return True


f = open("input_day4.txt","r")
string = f.read()
string = string.split("\n\n")
count = 0
for x in string:
	dictionary = {"byr": "", "eyr": "","hgt": "", "pid": "" , "hcl": "","iyr": "", "ecl": "", "cid": ""}
	level = []
	ind = True
	x = x.split("\n") 
	for i in range(len(x)):
		level += x[i].split(" ")
	for pair in level:
		pair = pair.split(":")
		if (len(pair) == 2):
			dictionary[pair[0]] = pair[1]
	for key in dictionary:
		if (not(isValid(key,dictionary))):
			ind = False
			break
	if (ind):
		count += 1
print(count)