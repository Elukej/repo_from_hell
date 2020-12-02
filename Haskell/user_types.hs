-- sopstvene tipove definisemo sa kljucnom reci data <ime tipa> = <vrednost> | <vrednost> | ...
-- npr data Bool = True | False
-- Deo desno od znaka = se naziva deo vrednosnih konstruktora

--data Shape = Circle Float Float Float | Rectangle Float Float Float Float 
import qualified Data.Map as Map

--do davanjem kljucne reci deriving u definiciju tipa, dobijamo tip koji je kompatibilan sa tipskom klasom Show
-- sto ce reci da ga je moguce slati na izlaz i ispisivati
data Shape = Circle Float Float Float | Rectangle Float Float Float Float deriving (Show)

surface :: Shape -> Float  
surface (Circle _ _ r) = pi * r ^ 2  
surface (Rectangle x1 y1 x2 y2) = (abs $ x2 - x1) * (abs $ y2 - y1) 

--value konstruktori su funkcije ko i sve drugo, gle cuda, pa se na njih moze primenjivati currying
-- tj parcijalno predavanje parametara, npr
--map (Circle 10 20) [4,5,6,6]  

-- exportovanje tipova podataka se radi u okviru modula koje eksportujemo na sledeci nacin
{-
module Shapes   
( Point(..)  
, Shape(..)  
, surface  
, nudge  
, baseCircle  
, baseRect  
) where  
-}
-- gde su tipovi Point i Shape, a to naznacavamo sa stavljanjem (..) ispred njih

--data Person = Person String String Int Float String String deriving (Show)
-- first name, last name, age, height, phone number, and favorite ice-cream flavor
--guy = Person "Buddy" "Finklestein" 43 184.2 "526-2928" "Chocolate"

{- da bismo izvlacili pojedinacna polja informacija od guy, pripadnika tipa Person, morali bi da u radimo nesto ovako
firstName :: Person -> String  
firstName (Person firstname _ _ _ _ _) = firstname  
  
lastName :: Person -> String  
lastName (Person _ lastname _ _ _ _) = lastname  
  
age :: Person -> Int  
age (Person _ _ age _ _ _) = age  
  
height :: Person -> Float  
height (Person _ _ _ height _ _) = height  
  
phoneNumber :: Person -> String  
phoneNumber (Person _ _ _ _ number _) = number  
  
flavor :: Person -> String  
flavor (Person _ _ _ _ _ flavor) = flavor  
-}
--ovo je poprilicno uzasno, tako da se uvodi tzv rekord sintaksa definisanja korisnickih tipova

data Person = Person { firstName :: String  
                     , lastName :: String  
                     , age :: Int  
                     , height :: Float  
                     , phoneNumber :: String  
                     , flavor :: String  
                     } deriving (Show)   

guy = Person "Buddy" "Finklestein" 43 184.2 "526-2928" "Chocolate"

--rekord sintaksa ne samo da omogucava da koncizno definisemo funkcije pozivaoce polja instance tipa, nego
-- omogucava da pri dodeljivanju instance proizvoljnim redom definisemo polja iz nje

data Car = Car {company :: String, model :: String, year :: Int} deriving (Show)
-- Car {company="Ford", model="Mustang", year=1967}


data Person' = Person' { firstName' :: String  
                       , lastName' :: String  
                       , age' :: Int  
                       } deriving (Eq, Show, Read)  
--ovakva deklaracija dodeljuje tipsku Eq tipu Person', tj instancira Person' kao tip koji pripada
-- tipskoj klasi Eq


{-
data Bool = False | True deriving (Ord)  
Because the False value constructor is specified first and the True value constructor is specified after it,
we can consider True as greater than False.
-}

data Day = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday   
           deriving (Eq, Ord, Show, Read, Bounded, Enum)  
-----------------------------------------------------------------------------

-- aliasi tipova se u haskelu definisu sledecom sintaksom
--type String = [Char]
--primeri
phoneBook :: [(String,String)]  
phoneBook =      
    [("betty","555-2938")     
    ,("bonnie","452-2928")     
    ,("patsy","493-2928")     
    ,("lucille","205-2928")     
    ,("wendy","939-8282")     
    ,("penny","853-2492")     
    ]  

type PhoneNumber = String
type Name = String
type PhoneBook = [(Name,PhoneNumber)]

-- sada bi funkciju phonebook mogli da deklarisemo sa phoneBook :: PhoneBook
-- kao sto se funkcije mogu definisati parcijalno, tako se i tipovi mogu konstruisati parcijalno
-- npr type IntMap v = Map Int v ili type IntMap = Map Int gde ni u prvom ni u drugom slucaju nije dat drugi tip mape
-- tj u prvom je naveden nepoznati parametar u kpji generise tip, a u drugom je to podrazumevano
--NAPOMENA: posto je Map konstruktor tipova deo modula Data.Map i ne eksportuje se napolje 
-- pozivanje ovog konstruktora vrsimo sa Data.Map.Map Int, ili sa nekim aliasom koji smo dali Data.Map
-- u import Data.Map qualified as Map npr, pa je onda konstrukcija tip Map.Map Int

data Either' a b = Left' a | Right' b deriving (Eq, Ord, Read, Show) 
-- tacno netacno tip u smislu da se leve vrednosti vracaju ako nije zadovoljen neki kompleksniji
--uslov funkcije, a desne ako jeste.


--data List a = Empty | Cons { listHead :: a, listTail :: List a} deriving (Show, Read, Eq, Ord)  
-- korisnicki konstruktor liste. To je struktura ciji element sadrzi sebe i pokazivac na sledeci element
-- Cons je ovde druga rec za : pa se na isti nacin i upotrebljava u konstrukciji lista
--upotreba je sledeca 
{-
ghci> Empty  
Empty  
ghci> 5 `Cons` Empty  
Cons 5 Empty  
ghci> 4 `Cons` (5 `Cons` Empty)  
Cons 4 (Cons 5 Empty)  
ghci> 3 `Cons` (4 `Cons` (5 `Cons` Empty))  
Cons 3 (Cons 4 (Cons 5 Empty))
-}

infixr 5 :-:  
data List a = Empty | a :-: (List a) deriving (Show, Read, Eq, Ord) 

--infixr je kljucna rec koja nekom specijalnom karakteru dodeljuje da se po defaultu pise kao infiksni opetartor
-- a i da se tako tretira, a ne kao ovi drugi sto su svi prefiksni ali mogu da se stave sa infiksnom notacijom
-- kada se napisu sa znakovima ``. broj 5 je ovde nesto kao nivo prioriteta koji se dodeljuje operaciji.
-- Ako sam dobro razumeo, samo specijalni karakteri mogu da imaju infixr dodeljen sebi

{- ovo sad primenjujemo ovako
ghci> 3 :-: 4 :-: 5 :-: Empty  
(:-:) 3 ((:-:) 4 ((:-:) 5 Empty))  
-}
infixr 5 .++ 
(.++) :: List a -> List a -> List a
Empty .++ ys = ys
(x :-: xs) .++ ys = x :-: (xs .++ ys)

--Sabiranje listi, tj dodavanje liste sa desne strane
-- NAPOMENA: OVDE JE PATTERN MATCH URADJEN SA NASIM KONSTRUKTOROM VREDNOSTI :-:  (X :-: XS)
-- PATTERN match generalno samo i moze da se radi sa konstruktorima
-- Because pattern matching works (only) on constructors, we can match for stuff like that,
-- normal prefix constructors or stuff like 8 or 'a', 
-- which are basically constructors for the numeric and character types, respectively.

--Finalna klarifikacija: Konstruktori tipa su deo levo od znaka jednakosti u data deklaracijia
-- a konstruktori vrednosti su sa desne strane znaka jednakosti!!!

data Tree a = EmptyTree | Node a (Tree a) (Tree a) deriving (Show, Read, Eq)
-- ovde su Node i EmptyTree konstruktori vrednosti, a Tree je konstruktor tipa, posto Tree a vraca tip,
-- a Node i EmptyTree vracaju vrednosti.

singleton :: a -> Tree a
singleton x = Node x EmptyTree EmptyTree
--drvo koje se ovde pravi je sortirano tako da su levo uvek manji elementi od zadatog, a desno veci
-- ovako se valjda mape i skupovi prave od drveca

treeInsert :: (Ord a) => a -> Tree a -> Tree a
treeInsert x EmptyTree = singleton x
treeInsert x (Node y left right)
         | x == y  = Node x left right
         | x < y   = Node y (treeInsert x left) right
         | x > y   = Node y left (treeInsert x right)


treeElem :: (Ord a) => a -> Tree a -> Bool
treeElem x EmptyTree = False
treeElem x (Node y left right) 
                   | x == y     = True
                   | x < y      = treeElem x left
                   | x > y      = treeElem x right

--NEKE OD funkcija za rad sa binarnim stablima
-- dosta uprosceni primeri su u pitanju

----------------------------------------------

--Konstrukcija tipskih klasa!!!!
-- sintaksa je sledeca
{-
class Eq a where  
    (==) :: a -> a -> Bool  
    (/=) :: a -> a -> Bool  
    x == y = not (x /= y)  
    x /= y = not (x == y)  
-}
-- kljucne reci su class i where. a definise bilo koji tip sa kojim operacije ove tipske klase rade
-- operacije su definisane mutualnom rekurzijom. Jeste je ono sto nije nije, dok nije je ono sto nije jeste

data TrafficLight = Red | Yellow | Green
-- sada cemo umesto automatski sa kljucnom reci derive, rucno instancirati tip TrafficLight u tipsku klasu Eq

instance Eq TrafficLight where
     Red == Red = True
     Green == Green = True
     Yellow == Yellow = True
     _ == _ = False

--nova kljucna rec je instance koja uvodi tip TrafficLight kao jednu od instanci tipske klae Eq
-- mutualna rekurzija iz definicije tipske klase ovde pokazuje lepotu
-- posto je neophodno bilo definisati ponasanje samo jedne od operacija == ili /= da bi ova druga bila
-- potpuno definisana

instance Show TrafficLight where
     show Red = "Red Light"
     show Yellow = "Yellow Light"
     show Green = "Green Light" 
{-
instance (Eq m) => Eq (Maybe m) where  
    Just x == Just y = x == y  
    Nothing == Nothing = True  
    _ == _ = False  
Napomene: Instanciranje tipova u tipske klase mora uvek da se radi sa konkretnim tipovima. Dakle u ovom konstruktu
ne moze da stoji samo Eq Maybe pre where zato sto je Maybe tipski konstruktor a ne konkretan tip. S druge strane
(Maybe m) je konkretan tip i zato on moze da se instancira posto ce m biti zamenjeno nekim konkretnim tipom, od kog 
ce Maybe konstruisati novi konkretni tip
Druga stvar: Kao sto se moze primetiti, klasni constraint moze da se ubaci maltene bilo gde pa tako i u deklarisanje instanci
Ovde je to bilo neophodno uciniti da bi se znalo da samo tipovi m koji su instance Eq mogu postati i instance Eq kao novi
(Maybe m) tipovi.
-}
-- U ghci-u mozemo informacije o tipskoj klasi dobitti pomocu komande :info <tipska_klasa>, na primer :info Eq
class YesNo a where
    yesno :: a -> Bool

instance YesNo Int where
    yesno 0 = False
    yesno _ = True

instance YesNo [a] where
    yesno [] = False
    yesno _ = True

instance YesNo Bool where
    yesno = id
-- id je funkcija koja vraca samu sebe, tako da ako je zadato True, vratice True, a ako je False vratice False

instance YesNo (Maybe a) where
    yesno (Just _) = True
    yesno Nothing = False

instance YesNo (Tree a) where
    yesno EmptyTree = False
    yesno _ = True

instance YesNo TrafficLight where
    yesno Red = False
    yesno _ = True

yesnoIf :: (YesNo y) => y -> a -> a -> a
yesnoIf yesnoVal yesResult noResult = if yesno yesnoVal then yesResult else noResult

-- gore su definisane tipska klasa YesNo i njena funkcija yesno koje omogucavaju ponasanje logickih izraza slicno kao u javascriptu
-- funkcija yesnoIf demonstrira kako izgleda if javascripta

-- sledeci deo je tipska klasa Functor koja ne uzima konkretne tipove za svoje instance, vec tipske konstruktore!!!
-- jako zbunjujuca stvar, ali sintaksno je sledeca
{- 
class Functor f where
      fmap :: (a -> b) -> f a -> f b

ova tipska klasa definise jednu funkciju fmap, tj daje njenu tipsku deklaraciju. Ovde su a i b konkretni tipovi
dok je f tipski konstruktor (na primer Maybe ili Tree ili [])
instancirajmo tipski konstuktor lista [] kao clan tipske klase Functor

instance Functor [] where
   fmap = map

naime, ovo funkcionise zato sto je tip funkcije map :: (a -> b) -> [a] -> [b] sto je poprilicno analogno sa 
gorenavedenim (a -> b) -> f a -> f b  

drugi primer

instance Functor Maybe where
   fmap f Just a = Just (f a)
   fmap f Nothing = Nothing

jako lepo. Funkcija fmap ce kad god naidje na tipski konstruktor Maybe za vrednost Just a primeniti funkciju na a 
i onda promeniti povratnu vrednost te funkcije u Just (f a) koja pripada (Maybe b) tipu
-}s
instance Functor Tree where
    fmap f EmptyTree = EmptyTree
    fmap f (Node x leftSubTree rightSubTree) = Node (f x) (fmap f leftSubTree) (fmap f rightSubTree)

-- setimo se tipskog konstruktora  Either   data Either a b = Left a | Right b
-- da bi napravili tipski konstruktor od ovoga. neophodno je da uradimo pozivanje Either a
{-
instance Functor (Either a) where
    fmap f (Right x) = Right (f x)
    fmap f (Left x) = Left x 
-}


-- u haskellu postoji nesto sto mozemo nazvati tipom od tipa!
-- Ovo cudo se drugacije naziva i kind i u ghci se poziva sa :k ili :kind
-- kind nam daje informaciju o tome sa kakvim tipom baratamo, slicno kao sto type daje informaciju 
-- sa kakvim vrednostima funkcija baratamo
-- kind od konkretnih tipova je *. kind od tipskih konstruktora je formata (* -> * -> ... *)
-- :k Maybe vraca rezultat (* -> *) posto je Maybe tipski konstruktor koji dobija kao parametar 
-- konkretan tip i od njega pravi drugi konkretan tip.
-- :k Either vraca (* -> * -> *) posto Either uzima dva parametra konkretna tipa i od njih pravi treci 
-- konkretan tip u povratku. :k od (Either a) je (* -> *) posto on ima vec jedan parametar pa uzima samo 
-- jos jedan konkretan tip i vraca konkretan tip.
-- Tipske klase mogu da instanciraju samo onaj tip ili tipski konstruktor koji ima isti kind format
-- kao onaj koji tipska klasa trazi od svojih instanci. Tipa Eq,Num,Ord traze kind * da im se preda kao instanca
-- dok na primer Functor zahteva (* -> *) kind da bi sa tim mogao da instancira clanove svoje klase





