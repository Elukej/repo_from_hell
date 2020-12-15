dic = {0:1,20:2,7:3,16:4,1:5,18:6}
beg = 15
end2020 = 0
for i in range(7, 30000000):
	if (i == 2020):
		end2020 = beg
	if ( dic.get(beg) == None):
		dic[beg] = i
		beg = 0
	else:
		temp = i - dic[beg]
		dic[beg] = i
		beg = temp
print(end2020)
print(beg)

