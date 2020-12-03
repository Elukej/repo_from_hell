-- Sintaksa za dodavanje modula je import <ime_modula>
--Bitno je da bude na pocetku skripte pre primene funkcija iz nje
import Data.List
import Data.Char
import qualified Data.Map as Map  

-- dodavanje modula u ghci je sa :m + <ime_modula> <ime_modula> ...
-- dodavanje funkcija modula se radi sa npr 
-- import Data.List (nub). u Hanojskoj sam importovao threadDelay tako iz Control.Concurrent modula
-- import   Data.List hiding (nub)   importuje ceo modul Data.List bez funkcije nub
-- rezervisana rec qualified u import deklaraciji sluzi da oznaci da se funkcija mora pozivati kao metod neke klase iz
-- c++-a ili bilo kog oop jezika. Dakle 
{-
import qualified Data.Map 
Ovo znaci da ako hocemo funkciju filter iz Data.Map moramo da je pozovemo sa Data.Map.filter !!!!!
da se skrati ovoliko pisanje, uvode se aliasi modulima na sledeci nacin
import qualified Data.Map as M
Sada funkciju filter mozemo pozvati kao M.filter
-}

intersperse' :: Eq a => a -> [a] -> [a]
intersperse' _ [] = []
intersperse' x (y:ys) 
               | ys == []     = y : intersperse' x ys
               | otherwise    = y : x : intersperse' x ys

-- UBACUJE X IZMEDJU SVAKO ELEMENTA LISTE (Y:YS)

intercalate' :: Eq a => [a] -> [[a]] -> [a]
intercalate' _ [] = []
intercalate' x (y:ys)
            | ys == []   = y ++ intercalate' x ys
            | otherwise    = y ++ x ++ intercalate' x ys
-- Prebacuje listu lista u spojenu listu sa ubacenom listom x izmedju svaka dva

transpose' :: Eq a => [[a]] -> [[a]]
transpose' x
           | filter (/= []) x == []    = []                                                                   
           | otherwise                 = takeHeads (x) : (transpose' $ map (tail') x)
                                              where takeHeads [] = []
                                                    takeHeads (x:xs) 
                                                          | x /= []      = head (x) : takeHeads(xs)
                                                          | otherwise    = takeHeads(xs)
                                                    tail' [] = []
                                                    tail' (x:xs) = xs 

-- FUNKCIJA ZA TRANSPONOVANJE MATRICE. FUNKCIJA takeHeads VRACA SVE POCETKE REDOVA, PA SE U REKURZIVNOM POZIVU ONI IZBACE
-- tail' JE DEFINISAN ZATO STO REGULARAN tail VRACA EXCEPTION ZA PRAZNU LISTU. U USLOVIMA FUNKCIJE NEOPHODNO JE BILO 
-- URADITI filter S OBZIROM DA FUNKCIJA map (tail') x vraca praznu matricu u formatu [[],[],[]..] STO NIJE JEDNAKO [].

concat' :: [[a]] -> [a]
concat' [] = []
concat' (x:xs) = x ++ concat' xs

--konkatencaija elemenata liste

and' :: [Bool] -> Bool
and' [] = True
and' (x:xs)
      | x == True  = and' xs
      | otherwise  = False

--uzima listu bool vrednosti i proverava da li su sve tacne

any' :: (a -> Bool) -> [a] -> Bool
any' _ [] = False
any' f (x:xs) 
           | f x       = True 
           | otherwise = any' f xs
--bilo koji element liste zadovoljaVA uslov

all' :: (a -> Bool) -> [a] -> Bool
all' _ [] = True
all' f (x:xs)
        | f x       = all' f xs
        | otherwise = False
-- da li svi elementi liste zadovaljavaju uslov postavljen sa filter

iterating :: (t -> t) -> t -> [t]
iterating f x = x : iterating f (f x)
--    pravi beskonacnu listu od zadate funkcije i neke pocetne vrednosti     

splittingAt' ::  (Ord a1, Num a1, Eq a2) => a1 -> [a2] -> ([a2], [a2])
splittingAt' n (x:xs)
             | n <= 0                = ([], x:xs)
             | n > 0 && xs == []     = ([x], [])  
             | otherwise             = (x : (fst (splittingAt' (n-1) xs)) , snd (splittingAt' (n-1) xs))

-- funkcija deli na dva dela lstu

takeWhile' :: (a -> Bool) -> [a] -> [a]
takeWhile' _ [] = []
takeWhile' f (x:xs)
        | f x        = x : takeWhile' f xs
        | otherwise  = []
-- uzima iz listre dok vazi uslov dat sa filter

dropWhile' :: (a -> Bool) -> [a] -> [a]
dropWhile' _ [] = []
dropWhile' f (x:xs)
        | f x       = dropWhile' f xs
        | otherwise = x:xs
--izbacuje iz liste do prvog elementa koji vrati True na upit da sa f


span' f x = (takeWhile' f x, dropWhile' f x)
-- deli listu na takewhile deo i ostatak

break' f x = span' (not . f) x
-- suprotno od spana, tj ide po listi dok uslov nije zadovoljen

group' :: (Eq a) => [a] -> [[a]]
group' [] = []
group' (x:xs) = let (fwd, rest) = span' (== x) (x:xs) 
                in [fwd] ++ group' rest

-- group' vraca podliste susednih jednakih elemenata
-- map (\l@(x:xs) -> (x,length l)) . group . sort $ [1,1,1,1,2,2,2,2,3,3,2,2,2,5,6,7] funkcija koja vraca listu tuplova
-- koji sadrze parove (element, broj pojavljivanja)

tails' [] = [[]]
tails' (x:xs) = [x:xs] ++ tails' xs 
-- vraca sve repove zadate liste

inits' [] = [[]]
inits' (x) = inits' (init x) ++ [x]

-- vraca sve inite liste
elemIndex' :: Eq a => a -> [a] -> Maybe Int
elemIndex' _ [] = Nothing
elemIndex' el xs  = let list = takeWhile (/= el) xs
                    in  if (length list == length xs) then Nothing 
                        else                           Just (length list) 

-- Funkcija vraca indeks elementa jednakog datom elementu. Primetimo novo zadati tip Maybe Int
-- on vraca ili Nothing ili Just 3 npr kao vrednosti. Zato je neophodno konvertovati povratnu vrednost u Maybe Int
-- sto se cini sa Just (length list)

-- Funkcija ord vraca broj karaktera iz unciode-a a chr vraca karakter vezan za broj. One su deo Data.Char modula

encode :: Int -> String -> String
encode shift msg =
                let ords = map ord msg
                    shifted = map (+ shift) ords
                in  map chr shifted
--Cezarovo sifrovanje	s obzirom da sva tri reda u let koriste map funkciju ovo je moglo i da se napise kao
-- encode shift msg = map (chr . (+shift) . ord) msg			

decode :: Int -> String -> String
decode shift msg = encode (negate shift) msg
-- dekodovanje cezara. negate vraca negativan broj od zadatog broja

negate' :: (Num a, Ord a) => a -> a
negate' x
      | x <= 0       = 0
      | otherwise    = (-x)


-- sledeci modul koji se uvodi je Data.Map koji je modul za asocijativne kontejnere organizovane kao liste tuplova od parova

findKey :: (Eq k) => k -> [(k,v)] -> Maybe v
find key [] = Nothing
findKey key ((k,v):xs) =  if key == k
                             then Just v
                             else findKey key xs
{- alternativa koristeci fold je sledeca
findKey :: (Eq k) => k -> [(k,v)] -> Maybe v  
findKey key = foldr (\(k,v) acc -> if key == k then Just v else acc) Nothing 
-}








