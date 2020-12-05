print("Check if eligible for a bank loan")
salary = int (input("How much is ur salary?\n"))

if (salary > 1000):
	amount = 200
	print("You are eligible to ge a bank loan by paying $" + str(amount) + " monthly")
elif(salary == 1000):
	amount = 500
	print("You are eligible to ge a bank loan by paying $" + str(amount) + " monthly")
else:
	print("Sorry jackass!")
