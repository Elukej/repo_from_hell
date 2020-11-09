import Control.Concurrent (threadDelay)

-- U haskellu koristimo :t da proverimo tip nekog izraza
-- cesto se u kod pise dodeljivanje tipova radi jasnoce iako
--ghc ima takozvano type inference svojstvo, tj sposoban je sam da proceni tipove nekog izraza
-- na osnovu njegovih funkcija
-- tip zadajemo sa :: 

addThree :: Int -> Int -> Int -> Int
addThree x y z = x + y + z

-- Poslednji clan definicije tipa je uvek povratna vrednost funkcije
-- Primeri mogucih tipova:
-- 1. Int - tipican 4-bajtni celobrojni tip
-- 2. Integer - Neograniceni celobrojni tip

factorial :: Integer -> Integer
factorial n = product [1..n]

-- 3. Float
circumference :: Float -> Float
circumference r = 2 * pi *r;

-- 4. Double je duplo precizni Float
-- 5. Char je za karaktere, a String za liste karaktera
-- NAPOMENA: tipovi se uvek pisu velikim slovom!!

-- U haskellu postoji nesto sto se moze nazvati type variable. To jako lici na polimorfizam
-- svoje vrste s obzirom da znaci da funkcija koja ne koristi nijednu osobinu koja je specificna 
-- za neki tip, moze biti pozvana za bilo koji tip koji joj se zada!!!
-- npr fst funkcija koja vraca prvi element tupla od para ima tip fst :: (a,b) -> a, gde su a i b tipske varijable(bilo koji tip)

-- Haskell poseduje nesto sto se zovu tipske klase(typeclass).
-- ovo cudo lici na klase u oop-u ali nisu to. Tipska klasa implementira neka ponasanja
-- koja tipovi koji joj pripadaju mogu da produkuju. tipska klasa je recimo Num za brojeve
-- primeri typeclass:
-- 1. Num - brojevi
-- 2. Eq - svi tipovi na koje se mogu implementirati funkcije == ili /=
-- 3. Ord - svi tipovi na koje se mogu primeniti operatori >,<,>=,<= ili compare.
--    (definisan je poseban tip Ordering koji je povratan od fje compare i koji moze biti EQ,GT,LT
--	   naravno, svi clanovi Ord-a moraju biti clanovi Eq-a)
-- 4. Show - svi tipovi koji se mogu konvertovati u string (reprezentuje ga funkcija show :: Show a => a -> String
-- 5. Read - typeclass suprotan od show, tj konvertuje string u nesto ukoliko je moguce. O tom necem se zakljucuje na osnovu ostatka izraza koji je zadat
--     reprezent tipske klase je funkcija read :: Read a => String -> a. (read "2" + 2 ili read "[1,2,3,4]" ++ [5])
-- NAPOMENA: DEO IZMEDJU :: I => NAZIVA SE CLASS CONSTRAINT (npr "Read a" u liniji iznad)!!!
-- read-u se moze eksplicitno zadati tip sa kojim radi umesto da sam zakljucuje
-- npr   read "5" :: Int   ili   read "5" :: Float    ili   read "[1,2,3,4]" :: [Int]   ili   read "(3,'a')" :: (Int, Char)
-- 6. Enum - nabrojiva tipska klasa. Tipovi ove klase mogu biti clanovi listi!! Znacajne funkcije succ i pred za sledbenika i prethodnika.
-- tipovi ove klase su (), Bool, Char, Ordering, Int, Integer, Float, Double.
-- primeri: ['a'..'e'] ili  [LT .. GT] ili [3..5] ili succ 'B'
-- 7. Bounded - svi tipovi koji imaju gortnju i donju granicu. Funkcije su maxBound i minBound
-- 8. Integral - celi brojevi Int i Integer. Pod typeclass od Num.
-- 9. Floating - realni brojevi Float i Double
-- Funkcija za zapamtiti: 

-- fromIntegral :: (Num b, Integral a) => a -> b 
-- fromIntegral 3 npr 
-- ova funkcija transformise broj pripadnik tipske klas Integral u pripadnika tipske klas Num, tj genralniji broj

lucky :: (Integral a) => a -> String
lucky 7 = "LUCKY NUMBER 7!"
lucky x = "Sorry, you're out of luck sucker!"

-- Haskell, kada prolazi kroz skripte, funkcije posmatra iz perpektive pattern-matchinga.
-- Prolazi redom i ide od posebnih ka opstim slucajevima, te je stoga u primeru gore
-- neophodno da i de prvo lucky 7 pa lucky x posto je lucky x mnogo generalniji slucaj
-- ukoliko ide prvo lucky x, on lucky 7 nece ni gledati prilikom poziva f-je!!!
-- jos jedan primer;

sayMe :: (Integral a) => a -> String
sayMe 1 = "One!"
sayMe 2 = "Two!"
sayMe 3 = "Three!"
sayMe x = "Not between 1 and 3"

-- primer pattern matchinga kod rekurzije (rekurzija u detalju kasnije)

faktRek :: (Integral a) => a -> a 
faktRek 0 = 1
faktRek n = n * faktRek (n-1)

-- kod pravljenja funkcija, uvek je bitno imati generalni slucaj koji ce da uhvati sve obuhvaceno class constraintom
-- kako program ne bi vracao gresku. Taj najgeneralniji slucaj uvek mora na kraj definicije funkcije da ide.

--pattern matching radi i za tuplove. primer:

addVectors :: (Num a) => (a,a) -> (a,a) -> (a,a) -- a je ovde tipska promenljiva da ne bude zabune !!!
addVectors (x1,y1) (x2,y2) = (x1 + x2, y1 + y2)

firstInTriple :: (a,b,c) -> a
firstInTriple (x,_,_) = x


 -- let xs = [(1,3), (4,3), (2,4), (5,3), (5,6), (3,1)]  
 -- x = [a+b | (a,b) <- xs]  
-- pattern match liste tuplova koji vraca listu suma unutar pojedinacnih tuplova


head' :: [a] -> a
head' [] = error "Can't call head of an empty list jackass!"
head' (x:_) = x

--primer funkcije koja vraca neke info o listi


tell :: (Show a) => [a] -> String
tell [] = "The list is empty!"
tell (x:[]) = "First and only element of list is " ++ show (x);
tell (x:y:[]) = "First and only two elements of list are [" ++ show (x) ++ "," ++ show (x) ++ "]"
tell (x:y:_) = "The list is looooong! First two elements are [" ++ show (x) ++ "," ++ show (y) ++ "]"

lengthPM :: (Num b) => [a] -> b
lengthPM [] = 0
lengthPM (x:xs) = 1 + lengthPM xs
-- Napomena: ovo sljaka i kad se stavi _ umesto x!!!

sum' :: (Num a) => [a] -> a
sum' [] = 0
sum' (x:xs) = x + sum' (xs)

--as paterni: imaju format ime@(neka_lista). dodju nesto kao alijas za celu listu da bi skratili pisanje prilikom pozivanja cele liste
-- npr

capital :: String -> String
capital "" = "Empty string, give me something to work with!"
capital lista@(x:xs) = "The capital letter of " ++ lista ++ " is " ++ [x]  --napomena, ovde ne moze samo x da se stavi, nego mora [x] posto je x element liste tipa [Char]

--umesto lista da nema as paterna pisali bi ++ (x:xs) ++. u ovom slucaju dodje na isto ali neretko budu
-- mnogo glomazniji pattern searchevi pa as patern dodje kao odlican alias 

-- ++ NE MOZE DA SE KORISTI ZA PATTERN MATCH. Dakle (x:xs) je ok ali (x ++ xs) nije!!!

-- Guardovi su citljivija varijanta if izraza. obelezavaju se sa pajp simbolom |
-- kada funkcija definise sve guardove, poslednji izraz je | otherwise = nesto koji hvata sve prostale okolnosti
-- otherwise je kljucna rec koja se evaluira kao true

--bmiTell :: (RealFloat a) => a -> a -> String
--bmiTell weight height
--       | weight / height <= 18.5 = "You're underweight, you emo, you!"
--       | weight / height ^ 2 <= 18.5 = "You're underweight, you emo, you!"  
--       | weight / height ^ 2 <= 25.0 = "You're supposedly normal. Pffft, I bet you're ugly!"  
--       | weight / height ^ 2 <= 30.0 = "You're fat! Lose some weight, fatty!"  
--       | otherwise                   = "You're a whale, congratulations!"  

-- RealFloat se ovde koristi jer je uzi od Num klase a garantuje da je deljenje operacijom / i poredjenje dato tipskoom klasom Ord moguce
-- Navedene stvari Num ne zadovoljava iz nekog razloga. Valjda zbog kompleksnih brojeva
-- haskell bio ovoj funkciji dodelio tip 
-- bmiTell :: (Fractional a, Ord a) => a -> a -> String
-- BITNO!!! KADA SE PRIMENJUJU GUARD OPERATORI, NEMA JEDNAKOSTI U POCETNOM IZRAZU NEGO SE ZA SVAKI PAJP
-- PONAOSOB DEFINISE STA VRACA. DAKLE    bmiTell weight height NEMA JEDNAKO!!!

max' :: (Ord a) => a -> a -> a
max' a b
     | (a >= b) = a
     | otherwise = b


myCompare :: (Ord a) => a -> a -> Ordering
a `myCompare` b
        | a > b         = GT
        | a == b        = EQ
        | otherwise     = LT

-- sintaksa where!
--


bmiTell :: (RealFloat a) => a -> a -> String
bmiTell weight height
       | bmi <= skinny = "You're underweight, you emo, you!"  
       | bmi <= normal = "You're supposedly normal. Pffft, I bet you're ugly!"  
       | bmi <= fat = "You're fat! Lose some weight, fatty!"  
       | otherwise                   = "You're a whale, congratulations!"  
       where bmi = weight / height ^ 2
             skinny = 18.5
             normal = 25.0
             fat = 30.0

-- sa where smo uprostili ponavljanje izraza za bmi na samo pisanje na kraju guardova
-- BITNA NAPOMENA!!! WHERE SINTAKSA ZAHTEVA DA PROMENLJIVE KOJE SU DEO OVE Funkcije KOJA SE DEFINISE
-- IMAJU PRAVILNO PORAVNANJE PO VERTIKALI. NA OSNOVU PREKIDA PORAVNANJA HASKEL ZNA DA JE ZAVRSIO SA WHERE!!!!
-- PORAVNAVANJE NE SME SA TAB DA SE RADI NEGO SAMO SA SPACE!!!
-- PORAVNAVANJE NE SME SA TAB DA SE RADI NEGO SAMO SA SPACE!!!


initials :: String -> String -> String
initials firstname lastname = [f] ++ ". " ++ [l] ++ "."
                      where (f:_) = firstname
                            (l:_) = lastname

--WHERE PRIMA I DEFINICIJE FUNKCIJA U SVOM OPSEGU DELOVANJA!.

calcBmis :: (Fractional a, Ord a) => [(a,a)] -> [a]
calcBmis xs = [bmi w h | (w,h) <- xs]
        where bmi weight height = weight / height ^ 2

--WHERE KLAUZULA IMA SVOJE UGNJEZDENJE PO POTREBI SA NOVIM WHERE KLAUZULAMA!! VAZI PRICA ZA PORAVNANJE!!!

--let kljucna rec: 

cylinder :: (RealFloat a) => a -> a -> a
cylinder r h =
       let sideArea = 2 * pi * r * h
           topArea = pi * r ^ 2
       in sideArea + 2 * topArea

-- Kao i kod where neophodno je da izrazi izmedju let i in budu poravnati perfektno po vertikali inace vraca gresku ghc
-- Ono sto se nalazi posle kljucne reci in se vraca funkciji kao rezultat!

-- primeri koriscenja let:
-- [let square x = x * x in (square 5, square 3, square 2)] 
-- (let a = 100; b = 200; c = 300 in a*b*c, let foo="Hey "; bar = "there!" in foo ++ bar)
-- kada se direktno preko komandne linije zadaje let construct, posto ne moze poravnjanje da se uradi
-- stavlja se ; izmedju svih izraza posle let sve do in. na poslednjem izrazu pre in moze i ne mora ; da se stavi

--jako korisno da zameni nepotrebno definisanje funkcije za izracunavanje nekog rezultata

calcBmisLet :: (RealFloat a) => [(a,a)] -> [a]
calcBmisLet xs = [bmi | (w,h) <- xs, let bmi = w / h ^ 2]

-- kada se stavi na mesto predikata (uslova) u list comprehension-u, ne upotrebljava se kao
-- filter, vec samo kao dodela vrednosti. Zanimljivo svojstvo dosta, sto ga za gornju funkciju
-- cini ocigledno dosta kompaktnijim nego where kljucnu rec

--Nakon let mogu slobodno neki predikati da idu tipa bmi > 25
--calcBmisLet xs = [bmi | (w,h) <- xs, let bmi = w / h ^ 2, bmi > 25]
--koji filtriraju kako je do sad objasnjeno

--u ghci-u kad se stavi let bez in dovodi da to bude zapamceno do kraja te sesije ghci-a
-- ako se stavi in to postaje lokalno i zaboravljeno odmah po evaluaciji izraza


--case expression - u sutini isto sto i pattern matching u definiciji funkcija
--head' :: [a] -> a
--head' [] = error "Can't call head of an empty list jackass!"
--head' (x:_) = x
-- ovako definisana funkcija, i sledeca funkcija su potpuno zamenjive jedna drugom

headCase :: [a] -> a
headCase xs = case xs of [] -> error "Can't call head of an empty list jackass!"
                         (x:_) -> x

--opsti oblik case je sledeci
-- case expression of pattern -> result
--                    pattern -> result
--                    pattern -> result
--                    ...

--PORAVNANJE NARAVNO MORA BITI SAVRSENO!!!


-- Recursion is important to Haskell because unlike imperative languages, you do computations in Haskell
-- by declaring what something is instead of declaring how you get it. That's why there are no while loops 
-- or for loops in Haskell and instead we many times have to use recursion to declare what something is.

maximum' :: (Ord a) => [a] -> a
maximum' [] = error ("EMPTY LISTS HAVE NO MAXIMUM!")
maximum' [x] = x
maximum' (x:xs)
           | x > max        = x
           | otherwise      = max
           where max = maximum' xs

-- rekurzivno trazenje maksimuma

replicate' :: (Integral a) => a -> b -> [b]
replicate' 0 _ = []
replicate' x s
            | x < 0        = []
            | otherwise    = s : replicate' (x - 1) s

--Niz istih elemenata

take' :: (Num a, Ord a) => a -> [b] -> [b]
take' 0 _ = []
take' _ [] = []
take' x (y:ys) 
      | x < 0          = []
      | otherwise = y : take' (x-1) ys

-- prvih x elemenata liste
--NAPOMENA pattern match y:ys ne sme da se primeni na praznu listu, jer se tako baca exception.
-- zato je bitno definisati zasebno sta se desava ako je lista prazna, pre rekurzivnog dela funkcije

reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x:xs) = reverse' (xs) ++ [x]

-- obrni listu

repeat' :: a -> [a]
repeat' x = [x] ++ repeat' x

-- beskonacna lista ponavljanja x

zip' :: [a] -> [b] -> [(a,b)]
zip' [] _ = []
zip' _ [] = []
zip' (x:xs) (y:ys) = (x,y) : zip' xs ys

-- spaja tuplove iz dve liste

elem' :: (Eq a) => a -> [a] -> Bool
elem' _ [] = False
elem' x (y:ys) = (x == y) || elem' x ys

-- proverava da li je element u listi

quickSort :: (Ord a) => [a] -> [a]
quickSort [] = []
quickSort (x:xs) = quickSort (xl) ++ [x] ++ quickSort (xr)
                   where xl = [ y | y <- xs, y <= x]
                         xr = [ y | y <- xs, y > x]


--brzi sort


--ispis ::  Eq a => a -> [a] -> [a] -> [a] ->  [[a]]
p = (threadDelay (1000000)) 
ispis n a b c  p = [[x | x <- a, x /= n]] ++ [[y | y <- b, y /= n]] ++ [[z | z <- c, z /= n]]
                        

hanoj :: (Eq a, Num a, Num b, Ord b) => a -> a -> [b] -> [b] -> [b] -> [[b]]

hanoj n k [0] [0] list = []


hanoj n k (x:xs) (y:ys) (z:zs)
                   | k /= 1 && x /= 0 && (x < y || y == 0)     =  ispis (0) xs (x:y:ys) (z:zs) p ++ hanoj n 2  xs (x:y:ys) (z:zs)

                   | k /= 1 && x /= 0 && (x < z || z == 0)     =  ispis (0) xs (y:ys) (x:z:zs) p ++ hanoj n 3 xs (y:ys) (x:z:zs)
                  
                   | k /= 2 && y /= 0 && (y < z || z == 0)     =  ispis (0) (x:xs) ys (y:z:zs) p ++ hanoj n 3 (x:xs) ys (y:z:zs)
                   
                   | k /= 2 && y /= 0 && (y < x || x == 0)     =  ispis (0) (y:x:xs) ys (z:zs) p ++ hanoj n 1 (y:x:xs) ys (z:zs) 
                 
                   | k /= 3 && z /= 0 && (z < x || x == 0)     =  ispis (0) (z:x:xs) (y:ys) zs p  ++ hanoj n 1 (z:x:xs) (y:ys) zs
         
                   | k /= 3 && z /= 0 && (z < y || y == 0)     =  ispis (0) (x:xs) (z:y:ys) zs p  ++ hanoj n 2 (x:xs) (z:y:ys) zs

                   | otherwise                                 =  if (x == 0 && z == 0) then hanoj n 0 [0] (y:ys) [0] else []





