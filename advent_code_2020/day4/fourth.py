#Brojac ispravnih pasosa
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
		if (dictionary[key] == "" and key != "cid"):
			ind = False
			break
	if (ind):
		count += 1
print(count)