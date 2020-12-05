def nzd (n, m):
    mod = n % m;
    if (mod == 0):
        return m
    else: 
       return nzd(m, mod)
result = nzd(128,72)
print(result)

#Bitne napomene!!! ZA DODAVANJE DIREKTORIJUMA U PYTHONOV SISTEMSKI PATH
# KORISTI SE SLEDECE:
#import sys
#sys.path.append("/home/me/mypy")