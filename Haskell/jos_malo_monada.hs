--Bice price o writer monadi ovde kasnije, mrzi me sad

import Control.Monad.Writer
import Control.Monad
import Control.Monad.State 

{-
newtype Writer w a = Writer { runWriter :: (a, w) }  

instance (Monoid w) => Monad (Writer w) where
     return x = writer (x,empty)
     (Writer (x,v)) >>= f = let (Writer (y,v')) = f x in Writer (y, v `mappend v')

-}
{-
gcd' :: Int -> Int -> Int
gcd' a b
    | b == 0     = a
    | otherwise  = gcd' b (a `mod` b)
--greatest common divisor algoritam
-}

gcd' :: Int -> Int -> Writer [String] Int
gcd' a b
    | b == 0    = do
         tell ["Finished with" ++ show a]
         return a
    | otherwise = do
         tell [show a ++ " mod " ++ show b ++ " = "  ++ show (a `mod` b)]
         gcd' b (a `mod` b)

-- ova funkcija se moze realizovati i na znacajno manje efikasan nacin ukoliko se obrnu redosled rekurzije i popunjavanja
-- log lste ([String]). Ovo potice zbog operacije ++ koja je uzasno neefikasna kad treba dodati elemente na kraj dugih lista
-- zbog ove neefikasnosti se uvodi struktura DiffList koja u sustini predstavlja funkciju, tj ovaj tip konvertuje zadatu listu
-- u funkciju npr [1,2,3] konvertuje u (\xs -> [1,2,3] ++ xs). Nije bas najjasnije zasto, ali ovo je iz nekog razloga dosta brze
--komparativna analiza na sledec dve f-je


newtype DiffList a = DiffList { getDiffList :: [a] -> [a]}

toDiffList :: [a] -> DiffList a
toDiffList xs = DiffList (xs++)

fromDiffList :: DiffList a -> [a]
fromDiffList (DiffList f) = f []

instance Monoid (DiffList a) where
     mempty = DiffList (\xs -> [] ++ xs)
     (DiffList f) `mappend` (DiffList g) = DiffList (\xs -> f (g xs))

-- sad ide komparativna analiza

finalCountDown :: Int -> Writer (DiffList String) ()  
finalCountDown 0 = do  
        tell (toDiffList ["0"])  
finalCountDown x = do  
        finalCountDown (x-1)  
        tell (toDiffList [show x])  

--prva je sa diff listama, a dtuga obicno uzasno appendovanje
{-   
finalCountDown :: Int -> Writer [String] ()  
finalCountDown 0 = do  
        tell ["0"]  
finalCountDown x = do  
        finalCountDown (x-1)  
        tell [show x]  
-}


{-


>>= :: m a -> (a -> m b) -> m b

instance Monad ((->) r) where  
        return x = \_ -> x  
        h >>= f = \w -> f (h w) w  

ako je m = (-> r) =>   (-> r) a -> (a -> (-> r) b) -> (-> r) b
=> (r -> a) -> (a -> (r -> b)) -> (r -> b)


(*2) >>=(\x -> (+10) >>= (\y -> return (x+y)))

(*2) >>= (\x -> (\w -> (\y -> return (x+y)) ((+10) w) w))

(*2) >>= (\x -> (\w -> return (x + (w + 10)) w))
------------------------------------------------
\z -> (\x -> (\w -> return (x + (w + 10)) w)) ((*2) z) z

\z -> (\x -> (\w -> return (x + (w + 10)) w)) (z*2) z

\z - > return ((z*2) + (z + 10)) z   ovaj z na kraju se valjda pojede pri procenjivanju izraza, bem li ga

-- ovo je bilo pokazivanje kako funkcionise instanca monade nad funkcijama, tj operatorom (->) r
-- moze se primetiti da ce za funkcije u nizu >>=, sve biti primenjene na jedan zadati parametar i onda sprovedene u neki izraz
-- koji izvodi iz do notacije. Prethodno izvodjenje je za funkciju
    import Control.Monad.Instances  
      
addStuff :: Int -> Int  
addStuff = do  
        a <- (*2)  
        b <- (+10)  
        return (a+b)  


-}

-- malo o monadama stanja

--     s -> (a,s)  "s" je ovde stanje a "a" je rezultat operacije stanja. Zanimljiva interpretacija. POmocu ovoga se moze npr
-- implementirati stek u kojem je stanje na steku s, a vrednost  koju vrati rezultat je broj koji se skine sa steka, ili nista
-- ako se samo gura na stek.  s -> (a,s) definise dakkle funkciju stanja


type Stack = [Int]  

 {-      
    pop :: Stack -> (Int,Stack)  
    pop (x:xs) = (x,xs)  
      
    push :: Int -> Stack -> ((),Stack)  
    push a xs = ((),a:xs)  

sa ovako definisanim stekom operacije funkcionisu ovako

    stackManip :: Stack -> (Int, Stack)  
    stackManip stack = let  
        ((),newStack1) = push 3 stack  
        (a ,newStack2) = pop newStack1  
        in pop newStack2  

-- cilj je da se monadnim manipulacijama ovo prevede u mnogo jednostavnije pisanje po korisnika tj

    stackManip = do  
        push 3  
        a <- pop  
        pop  

-- jako lepo, ali jos uvek neprimenjivo bez dodatnih instanciranja

-- COntrol.MOnad.State nam eksportuje novi tip koji se bavi operisanjem sa stanjima

newtype State s a = State { runState :: s -> (a,s) }

instance Monad (State s) where
    return x = state $ \s -> (x,s)
    (state h) >>= f = state $ \s -> let (a, newState) = h s
                                        (state g) = f a
                                    in g newState

-- ovde su h,f i g funkcije koje slikaju s -> (a,s)

menjamo definicije push i pop da bi radili sa state MOnadom
-}
 
      
pop :: State Stack Int 
pop = state $ \(x:xs) -> (x,xs)  --VAZNA NAPOMENA: TUTORIJAL JE OUTDEJTOVAN, I SADA ONO STO SE PODRAZUMEVALO KAO TIPSKI KONSTRUKTOR State SE PRETVORILO U StateT gde je sinonim   type State s a = StateT s Identity a. SRECOM, FUKCIJA state RADI TO STO TREBA DA SE DESI U OVIM IZRAZIMA. ONA MU DODJE KAO SVOJEVRSNI RETURN ZA STATE MONADU. DAKLE State VISE NIJE ORIGINALNI TIPSKI KONSTRUKKTOR I NE RADI POSAO, ALI FUNKCIJA state GA MENJA!!
      
push :: Int -> State Stack ()  
push a = state $ \xs -> ((),a:xs)

--sad stack manip moze ovako da se definise

stackManip :: State Stack Int  
stackManip = do  
        push 3  
        pop  
        pop  

-- prelepo i koncizno
{-
 The Control.Monad.State module provides a type class that's called MonadState and it features two pretty useful functions, namely get and put. For State, the get function is implemented like this:

    get = state $ \s -> (s,s)  

So it just takes the current state and presents it as the result. The put function takes some state and makes a stateful function that replaces the current state with it:

    put newState = state $ \s -> ((),newState)  
-}

--sintaksa za prouciti
{-
fmap (* 2) <$> [Just 1, Nothing, Just 3]    --ovo vraca [Just 2, Nothing, Just 6]

((*2) <$>) <$> [Just 1, Nothing]   -- ovo mapira OBICNU funkciju na listu Maybe vrednosti ( isto kao i prva linija)

((Just (*2)) <*>) <$> [Just 1, Nothing]    -- ovo mapira funkciju zapakovanu u monadu na listu Maybe vrednosti

-}

