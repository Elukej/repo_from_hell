--Funkcije viseg reda ili ti curried functions u kontekstu Haskela.
-- Haskel zapravo stvara samo privid da njegove funkcije primaju vise parametara.
-- to u stvari uopste nije slucaj. Svaka funkcija uzima samo jedan parametar, i kao 
-- povratnu vrednost vrati funkciju koja potencijalno dalje moze da uzima parametre.
-- Ova cinjenica dovodi do toga da svaka viseparametarska funkcija moze da se parcijalno
--rasclani na manje funkcije koje u sukcesiji daju funkciju koju smo hteli

multThree :: (Num a) => a -> a -> a -> a
multThree x y z = x * y * z

-- desno aocijativni operator -> prima sa leve strane funkciju tipa a i sa desne strane vraca tip a.
-- parcijalne funkcije ne mogu da imaju izlaz, zbog nedefinisanosti svih argumenata koji su neophodni,
-- tj svih funkcija koje one interno koriste, ali opet mogu postojati bez ikakvih problema u haskelu cekajuci
-- da se na njih primene neophodni parametri da bi se dobio izklazni rezultat.

multTwoWithNine = multThree 9

-- parcijalna funkcija. da bi vratila rezultat moraju da se primene jos dva argumenta
-- multTwoWithNine 2 3 vraca 54 npr.
-- svojevrsno aliasovanje funkicja se postize na ovaj nacin

multWithEighteen = multTwoWithNine 2 

-- multWithEighteen 5 vraca 90.

divideByTen :: (Floating a) => a -> a
divideByTen = (/10) 
--zagrade su ovde neophodne jer je funkcija infiksna a prima desni parametar!

zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' _ [] _ = []
zipWith' _ _ [] = []
zipwith' f (x:xs) (y:ys) = f x y : zipWith' f xs ys



maping _ [] = []  
maping f (x:xs) = f x : maping f xs



filter' :: (a-> Bool) -> [a] -> [a]
filter' _ [] = []
filter' p (x:xs)
        | p x    = x : filter' p xs
        | otherwise  = filter' p xs


-- quicksort using filter
quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort(x:xs) = 
       let smallerSorted = quicksort (filter' (<=x) xs)
           biggerSorted = quicksort (filter' (>x) xs)
       in smallerSorted ++ [x] ++biggerSorted




--Kolacove sekvence. 
chain :: (Integral a) => a -> [a]
chain 1 = [1]
chain x 
     | odd x      = x : chain (3 * x + 1)
     | otherwise  = x : chain (x `div` 2) 

nmgLongChains :: Int
nmgLongChains = length (filter isLong (map chain [1..100]))
          where isLong xs = length xs > 15

--pozivanje funkcionise i po principu npr funny = map (*) [1..]
-- pa onda (funny !! 4) 5 . Ovo vraca 20 :D. (*) nije dobila nijedan parametar u svom pozivanju,
-- ali s obzirom na desnu asocijativnost funkcija, ona se posluzi listom kao svojim parametrom
-- pa poziv funny vraca [(*1), (*2), (*3), ...

--LAMBDA IZRAZI!!
-- fUNKCIJE koje pozivamo samo jednom pa nemaju potrebe da imaju ime
-- Fun Fact: koristio sam jednu takvu u Hanojskoj kuli a da nisam ni znao sta je
-- sintaksa je \x -> pa neka obrada

numLongChain = length (filter (\xs -> length xs > 15) (map chain [1..100]))

-- lamde rade i pattern matching ali ne mogu da definisu vise paterna za jedan parametar
-- tj kao sto u rekurziji definisemo uslov za [] kao i (x:xs) koji failuje na praznoj listi
-- pa se zajedno dopunjavaju. Lambda izrazi izazivaju runtime errors ako failuju u pattern matchu

-- zipWith (\a b -> (a * 30 + 3) / b) [5,4,3,2,1] [1,2,3,4,5] 
-- lambe lagano primaju vise parameara
{-
addThree :: (Num a) => a -> a -> a -> a  
addThree x y z = x + y + z  
addThree :: (Num a) => a -> a -> a -> a  
addThree = \x -> \y -> \z -> x + y + z  
ovako definisane funkcije su ekvivalentne samo je druga notacija sa lambda izrazima -}

{-
flip' :: (a -> b -> c) -> b -> a -> c  
flip' f = \x y -> f y x  
alternativna definicja flip funkcije sa lambda izrazom.
BITNO ZA RAZUMETI I PROUCITI
-}

sum' :: (Num a) => [a] -> a  
sum' xs = foldl (\acc x -> acc + x) 0 xs  

--foldl funkcija uzima pocetne elemente preostalih lista (kao rekurzija) i na njima primenjuje lambda izraz
-- kao sto se vidi, funkcija prima i neku akumulacionu vrednost u koju se pakuju svi rezultati operacija nad
-- pojedinacnim listama

-- njoj parna funkcija foldr koja razvija listu sa desna na levoi, tj od kraja ka pocetku
--sledi implementacija mape koja ide s desna na levo:
map' :: (a -> b) -> [a] -> [b]
map' f xs = foldr (\x acc -> f x : acc) [] xs

-- foldr Radi na beskonacnim listama posto se one uvek mogu negde prekinuti i biti konacne s desna na levo
-- foldl s druge strane to ne moze jer su te liste beskonacne s leva na desno
-- Dopunske funkcije su foldl1 i foldr1 koje za akumulator uzimaju vrednost elementa liste od kog krecu respektivno
-- ali ne rade sa praznim listama i pozivanje sa praznom listom pravi runtime gresku

{-
scanl and scanr are like foldl and foldr, only they report all
 the intermediate accumulator states in the form of a list.
 There are also scanl1 and scanr1, which are analogous to foldl1 and foldr1.

ghci> scanl (+) 0 [3,5,2,1]  
[0,3,8,10,11]  
ghci> scanr (+) 0 [3,5,2,1]  
[11,8,3,1,0]  
ghci> scanl1 (\acc x -> if x > acc then x else acc) [3,4,5,3,7,9,2,1]  
[3,4,5,5,7,9,9,9]  
ghci> scanl (flip (:)) [] [3,2,1]  
[[],[3],[2,3],[1,2,3]]  
 -}
 
 
 -- upotreba $ u Haskelu:
 -- ovaj operator definisemo kao ($) :: (a -> b) -> a -> b
 --                               f $ x = f x
 -- BITNA NAPOMENA: PRAZNINA U HASKELU (SPACE) JE LEVO AOCIJATIVNI OPERATOR PRIMENE FUNKCIJA NAJVISEG PRIORITETA
 -- $ U HASKELU JE DESNO ASOCIJATIVNI OPERATOR PRIMENE FUNKCIJA NAJNIZEG PRIORITETA
 -- dolar dakle dodje kao zamena za zagrade
 {-
 sum (filter (> 10) (map (*2) [2..10])) <=> sum $ filter (> 10) $ map (*2) [2..10]
 
 s druge strane dolar mozemo da upotrebimon da naznacimo da se funkcijska aplikacija moze tretirati kao funkcij!!!
 U kontekstu haskelovog nemanja promenljivih, funkcijska aplikacija mu dodje kao promenljiva tj
 kada u haskelu napisemo 3 npr to je funkcijska aplikacija. Dakle, DOLAR OMUGACAVA DA FUNKCIJSKU APLIKACIJU
 TRETIRAMO KAO FUNKCIJU I STOGA JE MOGUC SLEDECI IZRAZI
 map ($ 3) [(4+), (10*), (^2), sqrt]
 gde funkcijsku aplikaciju 3 tretiramo kao funkciju koju primenjujemo na listu funkcija!!!
TREBA KONTEMPLIRATI O OVOME!!!
-} 
 
 {-
 OPERATOR KOMPOZICIJE FUNKCIJA U HASKELU JE .
 dakle kada zelimo da uradimo matematicku operaciju f(g(x)), tj kompoziciju f i g u Haskelu pisemo
 f . g 
 definicija:
(.) :: (b -> c) -> (a -> b) -> a -> c  
f . g = \x -> f (g x)  
 
 kompozicija moze biti odlicna alternatica lambdama jer u pojedinim situacijama postize dosta bolju citljivost npr
 map (\xs -> negate (sum (tail xs))) [[1..5],[3..6],[1..7]] <=> map (negate . sum . tail) [[1..5],[3..6],[1..7]]
 Znacajno bolja citljivost po mom misljenju
 ukoliko hocemo kompozicije viseparametarskih funkcija, moramo da ih parcijalno primenimo dok in me ostane samo jedan parametar koji nemaju
 
 sum (replicate 5 (max 6.7 8.9)) <=> sum . replicate 5 . max 6.7 $ 8.9
 replicate 100 (product (map (*3) (zipWith max [1,2,3,4,5] [4,5,6,7,8]))) <=> replicate 100 . product . map (*3) . zipWith max [1,2,3,4,5] $ [4,5,6,7,8]
 sum' xs = foldl (+) 0 xs <=> sum' = fold (+) 0     PARCIJALNE FUNKCIJE, TJ CURRYING na engleskom, ovo omogucavaju
 
 fn x = ceiling (negate (tan (cos (max 50 x)))) <=> fn = ceiling . tan . cos . max 50
 davanje funkcijske aplikacije ovoj funkciji se cini sa dolarom posto je kompozicija progutala sve one 
 zagrade, ali je nizege prioriteta od space-a pa mora da se stavi $ da bi kompenzovao te zagrade
 dakle
 ceiling . tan . cos . max 50 $ 100  je pravilna primena ovakve funkcije kompozicije funkcija
 
 
 funkcija oddSqureSum od ranije se moze napisati na tri sledeca nacina od kojih je treci vrv najjcitljiviji
oddSquareSum :: Integer  
oddSquareSum = sum (takeWhile (<10000) (filter odd (map (^2) [1..]))) 

oddSquareSum :: Integer  
oddSquareSum = sum . takeWhile (<10000) . filter odd . map (^2) $ [1..]

oddSquareSum :: Integer  
oddSquareSum =   
    let oddSquares = filter odd $ map (^2) [1..]  
        belowLimit = takeWhile (<10000) oddSquares  
    in  sum belowLimit  
 
 -}
 
nub' :: Eq a => [a] -> [a]
nub' [] = []
nub' (x:xs)
         | x `elem` (nub' xs)  = filter (/= x) $ nub' xs
         | otherwise           = x : nub' xs
 
 
 

 