-- Instanciranje tipske konstruktora IO kao instance tipske klase funktor
{-
instance Functor IO where
    fmap f action = do
              result <- action
              return (f result)
-}
{-
main = do line <- getLine   
          let line' = reverse line  
          putStrLn $ "You said " ++ line' ++ " backwards!"  
          putStrLn $ "Yes, you really said" ++ line' ++ " backwards!"  

main = do line <- fmap reverse getLine  
          putStrLn $ "You said " ++ line ++ " backwards!"  
          putStrLn $ "Yes, you really said" ++ line ++ " backwards!"  

Ova dva koda su ekvivalentna. Drugi pokazuje kako upotrebom fmap moze da se redukuje broj koraka.
-}

import Data.Char
import Data.List

main = do line <- fmap (intersperse '-' . reverse . map toUpper) getLine
          putStrLn line

{-
instance Functor ((->) r) where  
        fmap f g = (\x -> f (g x))  

jako interesantno instanciranje operatora ((->) r (primenjuje se kao r -> a, ali da bi se predao funktoru kind mora da mu bude 
* -> * sto je slucaj kada napisemo (->) r ). U sustini fmap na ovom tipskom konstruktoru radi kao kompozicija funkcija
pa je instanciranje moglo da izgleda i na sledeci nacin

instance Functor ((->) r) where
       fmap = (.)

analiziranjem gornjeg instanciranja znajuci da je tip fmap :: (a -> b) -> f a -> f b dokazujemo da je ov kompozicija
dakle ovo za instancu f=(-> r) je fmap :: (a -> b) -> (-> r) a -> (-> r) b <=> fmap :: (a -> b) -> (r -> a) -> (r -> b). Dakle kompozicija!!
-}

--fmap moze lagano da dobija i funkcije bez primenjena dva parametra tipa *, ++  itd. u tom slucaju, Functor koji dobije iz svog drugog
--parametra ce obuhvatiti celokupnu parcijalnu primenu te funkcije na ono u njemu i vratiti Funktor koji obuhvata primenu parcijalne 
-- funkcije u sebi. Dakle npr ako imamo fmap (*) [1,2,3,4] vratice [(* 1),(* 2),(* 3),(*4)]. TIP OVOGA je [Integer -> Integer] !!

-- Da bi se ova funkcionalnost napucala tako da i funkcije koje se predaju fmap budu same unutar nekih funktora (npr fmap (Just (*3)) ..)
-- uvode se aplikativni funktori koji su deo Control.Applicative modula

{-
class (Functor f) => Applicative f where
     pure :: a -> f a
     (<*>) :: f (a -> b) -> f a -> f b

instance Applicative Maybe where
     pure = Just
     Nothing <*> _ = Nothing
     (Just f) <*> something = fmap f something


primena je npr

Just (+3) <*> Just 5                   sto vraca Just 8
Just (+) <*> Just 5 <*> Just 6         vraca Just 11

jako zanimljiva kompozitna svojstva ove funkcije. pure se koristi da na osnovu konteksta u kom je upotrebljen izvuce funktor iz vrednosti.
COntrol.Applicative exksportuje i znak <$> kao zamenu za fmap tj fmap f x = f <$> x
pa moze da sljaka i
(+) <$> Just 5 <*> Just 6
-}

-- jos neki primeri instanci aplikativnih FUNKTORA
{-
instance Functor [] where
     pure x = [x]
     fs <*> xs = [f x | f <- fs, x <- xs]
-} 

{-
instance Applicative IO where
     pure = return
     a <*> b = do
         f <- a
         x <- b
         return (f x)
-}

{-
instance Applicative ZipList where  
         pure x = ZipList (repeat x)  
         ZipList fs <*> ZipList xs = ZipList (zipWith (\f x -> f x) fs xs)  

liftA2 :: (Applicative f) => (a -> b -> c) -> f a -> f b -> f c  
liftA2 f a b = f <$> a <*> b  





sequenceA :: (Applicative f) => [f a] -> f [a]  
sequenceA [] = pure []  
sequenceA (x:xs) = (:) <$> x <*> sequenceA xs  
Ovo pretvara aplikativnu listu u listu aplikativa ([Just 1, Just 2] u Just [1,2])
-}


data CoolBool = CoolBool { getCoolBool :: Bool } deriving (Show) 

-- Monoidi su tipovi koji su asocijativni u odnosu na neku operaciju i imaju neutralni element koji je komutativan u odnosu na tu operaciju
{-
class Monoid m where
  mempty :: m
  mappend :: m -> m -> m
  mconcat :: [m] -> m
  mconcat = foldr mappend mempty

instance Monoid [a] where
    mempty = []
    mappennd = (++)

-}
-- Data.Monad modul definise posebne tipove za operacije * i + (Product i Sum) koji omogucavaju da se za ove operacije konstruisu monoidi
-- nad tipom brojeva
{-
newtype Product a =  Product { getProduct :: a }  
        deriving (Eq, Ord, Read, Show, Bounded)  


instance Num a => Monoid (Product a) where
      mempty = Product 1
      Product x `mappend` Product y = Product (x * y)

-}
-- postoji brdo jos monoida tipa za bool operacije and i or, ali mrzi me da ih copy pasteujem ovde

{-
instance Monoid Ordering where
mempty = EQ
LT `mappend` _ = LT
EQ `mappend` y = y
GT `mappend` _ = GT
The instance is set up like this: when we mappend two Ordering values, the one on the left is kept, unless the value on the left is EQ, in which case the right one is the result. The identity is EQ. At first, this may seem kind of arbitrary, but it actually resembles the way we alphabetically compare words. We compare the first two letters and if they differ, we can already decide which word would go first in a dictionary. However, if the first two letters are equal, then we move on to comparing the next pair of letters and repeat the process. 
-}
-- ordering monoid ima zanimljivu primenu u uporedjivanju stringova na primer. Sledece dve funkcije su ekvivalentne
{-
lengthCompare :: String -> String -> Ordering
lengthCompare x y = let a = length x `compare` length y
                        b = x `compare` y
                    in if a == EQ then b else a

import Data.Monoid

lengthCompare :: String -> String -> Ordering 
lengthCompare x y = (length x `compare` length y) `mappend` (x `compare` y)

--ova funkcija uporedjuje stringove i vraca Ordering informaciju na osnovu duzine, a zatim sadrzaja ako je duzina ista
-- mozemo da je prosirimo da gleda na osnovu samoglasnika

import Data.Monoid  
      
lengthCompare :: String -> String -> Ordering  
lengthCompare x y = (length x `compare` length y) `mappend`  
                    (vowels x `compare` vowels y) `mappend`  
                    (x `compare` y)  
        where vowels = length . filter (`elem` "aeiou")  


-}


-- Maybe the monoid :

{-
instance Monoid a => Monoid (Maybe a) where
      mempty = Nothing
      Nothing `mappend` m = m
      m `mappend` Nothing = m
      Just m1 `mappend Just m2 = Just (m1 `mappend` m2)

--ovo instanciranje u sebi sadrzi klasni constraint da tip a mora biti instanca monoida da bi Maybe a mogao da bude!
-- Ukoliko ne zelimo da imamo klasni constraint na tipu koji abe konstruise uvode se forice sa tipovima First i Last
-- koji uopste ne rade mappend na unutrasnjim vrednostima m1 i m2 nego samo uzmu prvu ili drugu respektivno.
-- ovo dakle omogucava da unutrasnji tip instance ne bude monoid, a korisno je ukoliko nas u grupi vrednosti npr zanima
-- da li ima neka koja nije Nothing



newtype First a = First { getFirst :: Maybe a }  
        deriving (Eq, Ord, Read, Show)  

instance Monoid (First a) where  
        mempty = First Nothing  
        First (Just x) `mappend` _ = First (Just x)  
        First Nothing `mappend` x = x  

-}

--Nova bitna tipska klasa koja se uvodi je Foldable. Kao sto ime kaze, sadrzi sve tipove koji mogu da se folduju
-- i definise operacije foldl, foldr, ...  i na kraju foldMap operaciju koja je dovoljna da se definise za zadati tip
-- da bi sve ostale fold operacije tipske klase foldable radile na zadatoj instanci.

{-
import qualified Foldable as F  

data Tree a = Empty | Node a (Tree a) (Tree a) deriving (Show, Read, Eq)  

foldMap :: (Monoid m, Foldable t) => (a -> m) -> t a -> m

instance F.Foldable Tree where
    foldMap f Empty = mempty
    foldMap f (Node x l r) = F.foldmap f l `mappend`
                             f x           `mappend`
                             F.foldMap f r

-}










