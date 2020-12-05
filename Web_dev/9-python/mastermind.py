import random

print("Welcome to the mastermind game!\nThe rules are following:\nU have 6 guesses to get a combination of numbers from 1 to 4!\nNumber 2 means u got one number exactly where it i.\nNumber 1 means it's in the sequence but not on the right place\nNumber 0 is a miss.'Tis a noob game so no time involved.\nGood luck!")

numbers = range(1,5)
result = [str(random.choice(numbers)), str(random.choice(numbers)), str(random.choice(numbers)), str(random.choice(numbers))]

k = 1
while (k < 7):
   guess = input(str(k) + ".    ")
   guessList = []
   guessList.extend(str(guess))
   if (len(guessList) != 4 or not(guess.isnumeric())):
        print("Input must be 4 numeric characters!")
        continue
   badInput = False
   for i in guessList:
        if (int(i) > 4 or int(i) < 1):
            badInput = True
   if (badInput):
        print("Your numeric values are not between 1 and 4!")
        continue
   
   if (guessList == result):
     print("You got it dude/tte! Congratulations!")
     break
   else:
     temp = []
     temp += result
     hint = []
     for i in range(len(temp)):
        if (guessList[i] == temp[i]):
            hint += "2"
            temp[i] = "0"
            guessList[i] = "0"
     i = 0
     while (i < len(temp)):
        if (temp[i] == "0"):
            i+=1
            continue
        j = 0
        while(j < len(temp)):           
            if (guessList[j] == temp[i]):
                hint += "1"
                temp[i] = "0"
                guessList[j] = "0"
                break
            j+=1
        i+=1    
     hint.sort(reverse = True)
     if (len(hint) < 4):
            hint.extend("0"*(4 - len(hint)))
     print("-"*20 + "".join(hint))
   k+=1
if (k == 7):
    print("You lost. The number was " + "".join(result) + ".\nBetter luck next time homie!")
     