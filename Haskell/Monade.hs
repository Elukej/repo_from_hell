--Monade su navodno napucani aplikativni funktori
--definisu se na sledeci nacin
import Control.Monad
{-
Class Monad m where
   return :: a -> m a
   (>>=) :: m a -> (a -> m b) -> m b

   (>>) :: m a -> m b -> m b
   x >> y = x >>= \_ -> y
 
   fail :: String -> m a
   fail msg = error msg

instance Monad Maybe where
     return x = Just x
     Nothing >>= f = Nothing
     Just x >>= f = f x
     fail _ = Nothing


-}

type Birds = Int
type Pole = (Birds,Birds)

{-
landLeft :: Birds -> Pole -> Pole
landLeft n (left,right) = (left + n,right)

landRight :: Birds -> Pole -> Pole
landRight n (left,right) = (left,right + n)
-}
-- zadatak je sledeci. Cikica balansira na konopcu sa stapom na koji slecu ptice. Ako se desi da na stapu
-- sa jedne strane ima 4 ptice vise nego sa druge, cikica pada

--infix 0 -:
x -: f = f x

landLeft :: Birds -> Pole -> Maybe Pole
landLeft n (left,right) 
         | abs ((left+n) - right) < 4 = Just (left + n, right)
         | otherwise                  = Nothing

landRight :: Birds -> Pole -> Maybe Pole
landRight n (left, right)
        | abs(left - (right + n)) < 4 = Just (left, right +n)
        | otherwise                   = Nothing

--primena:    landRight 1 (0,0) >>= landLeft 2 >>= landRight 2 

banana :: Pole -> Maybe Pole  
banana _ = Nothing  
--funkcija da srusi cikicu bez obzira na broj ptica

{- da nema ovako lepe monadne implementacije, cikicina rutina bi morala ovako da se implementira
    routine :: Maybe Pole  
    routine = case landLeft 1 (0,0) of  
        Nothing -> Nothing  
        Just pole1 -> case landRight 4 pole1 of   
            Nothing -> Nothing  
            Just pole2 -> case landLeft 2 pole2 of  
                Nothing -> Nothing  
                Just pole3 -> landLeft 1 pole3  
 -- poprilicno gadno
-}
--drugi primer return (0,0) >>= landLeft 1 >> Nothing >>= landRight
-- Ovo vraca Nothing. Lepota monada je u tome sto kad se desi neuspeh, u stanju su da ga propagiraju kroz
-- citav lanac dogadjaja do kraja bez komplikovane implementacije.

-- monadno prosledjivanje adhoc se radi sa lambda izrazima po sledecem obrascu
-- Just 3 >>= (\x -> Just (show x ++ "!"))  vraca Just "3!"
-- Just 3 >>= (\x -> Just "!" >>= (\y -> Just (show x ++ y)))  vraca Just "3!"
-- ovo jako lici na    let x = 3; y = "!" in show x ++ y    uz razliku sto monade mogu i da failuju bez pucanja programa!!!

-- Posto je ovakvo prosledjivanje sa lambdama dosta nabudzeno i necitko, uvodi se do sada vec vidjena do notacija!!!
-- kljucna rec do menja >>= u izrazima tako sto primenjuje taj operator na sve pravilno indentirane izraze posle sebe
-- Dodelu koja se desava u lambdama, do menja sa <- operatorom vezivanja izraza koji raspakuju monadne vrednosti!
-- do koji radi isto sto i prethodni primer sa Just "3!" je sledeci (komparativni prikaz prema lambdama):
{-
foo :: Maybe String
foo = Just 3   >>= (\x ->
      Just "!" >>= (\y ->
      Just (show x ++ y)))

foo :: Maybe String
foo = do
    x <- Just 3
    y <- Just "!"
    Just (show x ++ y)
-}
-- do notacija omogucava znacajno vecu citljivost!!! Primetimo da se sve lambda dodele pretvaraju u <- vezivanja!!
-- poslednji izraz do notacije ne moze da bude vezivanje sa <- posto on predstavlja celokupnu vrednost do izraza koja 
-- se vraca po njegovom zavrsetku. Kao sto je receno, do kumulativno vezuje monadnu progresiju od prvog ka poslednjem 
-- izrazu, i rezultat te akumulacije mora da se vrati kroz poslednji izraz, te stoga on i ne moze biti <- dodela!
-- Doduse, povratna vrednost moze biti tipa return (), ukoliko se set akcija zavrsava bez ikakve posebne akcije na izlazu.  

-- do notacija moze i da pattern matchuje u sebi, sto je obilato korisceno u dosadasnjem radu (Todo aplikacija npr)
-- primer:
{-
justH :: Maybe Char  
justH = do  
      (x:xs) <- Just "hello"  
      return x  
-}
--Ovo vraca Just 'h' na primer
--Sa druge strane, monadna implementacija Maybe omogucava ovakvim pattern matchevima i da failuju
-- a da ne pukne programa zbog njih zbog fail funkcije definisane u tipskoj klasi Monad
-- fail :: (Monad m) => String -> m a  
-- fail msg = error msg  
-- koja je za Maybe:
-- fail _ = Nothing
-- pa sledeci pattern match nece sjebati ceo program zbog neuspeha
{-
wopwop :: Maybe Char  
wopwop = do  
      (x:xs) <- Just ""  
      return x  
-}
{- MOnade za liste
  
  instance Monad [] where  
        return x = [x]  
        xs >>= f = concat (map f xs)  
        fail _ = []  

    ghci> [3,4,5] >>= \x -> [x,-x]  
    [3,-3,4,-4,5,-5]  

    ghci> [1,2] >>= \n -> ['a','b'] >>= \ch -> return (n,ch)  
    [(1,'a'),(1,'b'),(2,'a'),(2,'b')]  

--sledeci kod je ekvivalentan

    listOfTuples :: [(Int,Char)]  
    listOfTuples = do  
        n <- [1,2]  
        ch <- ['a','b']  
        return (n,ch)  

--kao i ovaj
 
   ghci> [ (n,ch) | n <- [1,2], ch <- ['a','b'] ]  
    [(1,'a'),(1,'b'),(2,'a'),(2,'b')]  

--Haskell uvodi klasu MonadPlus kako bi se izrazile Monade koje imaju svojstva Monoida!!
   
class Monad m => MonadPlus m where  
        mzero :: m a  
        mplus :: m a -> m a -> m a  

--instanciranje liste u MonadPLus
instance MonadPlus [] where  
        mzero = []     --funkcija za neutralni element
        mplus = (++)   -- ekvivalent mappend funkciji iz monoida u MonadPlus-u


-}

guard' :: (MonadPlus m) => Bool -> m ()  
guard' True = return ()  
guard' False = mzero 

--    ghci> [1..50] >>= (\x -> guard ('7' `elem` show x) >> return x)  
--    [7,17,27,37,47]  

-- ovo iznad i funkcija sevensOnly rade isto. Bitna stavka je da je u donjoj do notaciji guard nema dodelu nicemu sa <-, posto se
-- progresivna priroda monada manifestuje tako da se njegov rezultat prosledjuje zadnjem return x izrazu.
-- Treba kontemplirati ovo jer je cudno, s obzirom da se u x ucitava niz [1..50] a u guard izrazu se ne vidi eksplicitna promena
-- x, a zatim se x vraca sa return x.

sevensOnly :: [Int]  
sevensOnly = do  
       x <- [1..50]  
       guard' ('7' `elem` show x)  
       return x  


--Zakoni Monada 

--1. levi identitet : return x >>= f is the same damn thing as f x
--2. desni identitet :   m >>= return is no different than just m
--3. asocijativnost :  (m >>= f) >>= g is just like doing m >>= (\x -> f x >>= g)
{-
--Asocijativnost monada mozemo definisati i uvodjenjem operatora kompozicije monada
(<=<) :: (Monad m) => (b -> m c) -> (a -> m b) -> (a -> m c)  
f <=< g = (\x -> g x >>= f)  

i mora da vazi f <=< (g <=< h) je jednako (f <=< g) <=< h (asocijativnost)
zatim i f <=< return je jednako f (levi identitet)
a zatim i return <=< f je jednako f (desni identitet)

-}

