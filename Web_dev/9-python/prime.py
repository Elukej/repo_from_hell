import math
def prime (n):
    i=2
    end = math.floor(math.sqrt(n)) + 1
    while (i < end):
        if (n % i == 0): 
            break
        i += 1
    if (end == i):
        return True
    else:
        return False

count = 0
iterator = 2
while (count < 50):
    if (prime(iterator) == True):
        print(iterator)
        count += 1
    iterator += 1
