-- ULAZNO IZLAZNA SINTAKSA
-- kljucna rec main se uvodi poput funkcije sa kojom se izjednacavaju svi IO procesi
-- Posto bi main mogao da primi samo jednu ulazno-izlaznu operaciju, smisljen je lep nacin da se njegova
-- funkcionalnost prosiri. Ovo se radi sa tzv  "do"  sintaksom, koja funkcionise slicno where samo za 
-- IO operacije. Dakle bitna je indentacija da bude ista, i sa tim uslovom vezuje koliko treba IO operacija u niz]
-- Uvodi se i operator <- koji radi dodelu novog imena nekoj IO operaciji, i daje mogucnost da se ta IO operacija
-- pozove u nekom kasnijem kontekstu. Vrlo je bitno da ovo nije isto sto i =, te = nece raditi posao dok ovaj operator
-- hoce. Sto se ostalog tice, kad se izvrsi dodela <-, ta informacija je bezbedna da se upotrebi za neki deo
-- cistog dela koda, da se nesto izracuna, i onda se moze ponovo koristiti za IO operisanje

-- Pocetne operacije IO dela su getLine koji cita liniju sa ulaza i putStrLn (String) koji pise string na ulaz

{-
main = do
         putStrLn ("Unesite recenicu koju zelite da okrenete:")
         line <- getLine
         if null line
            then do 
                  putStrLn ("Dovidjenja!")
                  return ()
            else do
                   putStrLn $ reverseWords line
                   main
               
reverseWords :: String -> String
reverseWords = unwords . map reverse . words
-}
-- words i unwords su funkcije koje dele string u listu stringova i prave jedan string od liste stringova respektivno
-- Druga stvar, primetimo da je funkcija lagno mogla da ide i posle maina, kompajler to resava bez problema 
-- prilikom prolaska kroz program. Treca stvar, ovde se koristi funkcija "return" koja ima tu lepu osobinu
-- da rezultat nekih funkcijskih operacija zapakuje u IO tip sa kojim moze da se radi na ulazno izlaznim operacijama
-- Druga lepa osobina te funkcije je sto ukoliko joj se ne dodeli nikakva vrednost, ona vrati prazan IO tip, sa kojim ove
-- ulazno izlazni deo takodje lepo operise. Ova funkcija dakle uopste ne mora da bude deo maina !!!
-- Cetvrta stvar, main sam sebe moze rekurzivno da poziva!!! Ovo znaci da program moze infinitno mnogo puta da se izvrsava
-- dok se ne desi uslov koji ne uradi rekurzivni poziv main-a

-- Program u Haskellu se kompajlira sa ghc --make <ime programa>. Drugi nacin da se pokrene je sa komandom runhaskell

-- primena returna za enkapsulaciju rezultata u IO tip:
{-
main = do
         a <- return "hell"
         b <- return "yeah!"
         putStrLn $ a ++ " " ++ b

Medjutim ovaj nacin rada sa return je izgleda redundantan jer se umesto njega mogu koristiti "let" vezivanja funkcija za imena
Sto je izgleda i sintakticki dobra praksa jer omogucava da se tacno vidi koji deo koda je cist unutar main-a, tj funkcijski
a koji deo su prljave IO operacije. (Ove stvari nisam znao kad sam pisao Hanojsku kulu, pa sam koristio return umesto da vezujem sa let)

main = do  
    let a = "hell"  
        b = "yeah"  
    putStrLn $ a ++ " " ++ b 
-}
-- dakle return se koristi primarno kada zelimo da postavimo rezultat do blocka ili if izraza u onaj tip koji mi zelimo
-- do ima izgleda neku posebnu radnju koja se desava sa poslednjom akcijom unutar njega, ali o tome i dalje ne znam nista

-- sledi izuzetno lep primer rekurzije za definisanje IO akcija
-- pre toga, definisimo operacije putStr koja ispisuje stringove bez preskakanja u novi red, i putChar koja ispisuje jedan karakter
{-
putStr :: String -> IO ()
putStr [] = return ()
putStr (x:xs) = do
         putChar x
         putStr xs
-}
-- vidimo da je do block ovde jako lepo zamenio pipeovanje sa | koje se koristi u cistom kodu!!! NOICE!!	

-- print funkcija uzima instance Tipske klase Show i ispisuje ih na izlaz - koristio u Hanojskoj
-- getchar za citanje karaktera sa ulaza. rekurzivno kad se koristi moze i cele linije da cita
-- ali to radi sa baferisanjem pa dok ne puknemo enter, on cita do kraja

-- when funkcija iz Control.Monad modula (import Control.Monad) je zamenski izraz za if funkciju
-- lepota when-a je sto mozemo da ga upotrebimo ukoliko nas ne zanima else slucaj, posto kada pisemo
-- if else konstrukt, moramo da uvek imamo i povratnu  vrednost za if i  povratnu vrednost za else
-- dok ovde mozemo lagano samo if deo da uradimo i da ne ispisujemo else uopste!!
{-
import Control.Monad   
  
main = do  
    c <- getChar  
    when (c /= ' ') $ do  
        putChar c  
        main  
-}

-- sequence :: [IO a] -> IO [a] Ova funkcija uzima niz ulazno izlaznih akcija i pretvara ih u jednu veliku IO akciju
{-
main = do  
    rs <- sequence [getLine, getLine, getLine]  
    print rs  
-}
-- uvode se funkcije mapM i mapM_ koje su otprilike isto sto "sequence . map". Razlika je sto mapM_ ne ispisuje praznu listu
-- izvrsenih IO operacija na kraju 

{-
import Control.Monad  
import Data.Char  
  
main = forever $ do  
    putStr "Give me some input: "  
    l <- getLine  
    putStrLn $ map toUpper l  
	
Ovaj programn zauvek sekvencira IO akciju tj sve podrazumevano sa do-om koji je dat kao parametar forever
-}
-- forM i forM_ su jako kul funkcije koje rade u sustini isto sto i map i mapM_ uz razliku da su im obrnuti argumenti
-- ovo je kul jer omogucava lepo natrpavanje vise IO akcija nad svakim elementom liste!!! Vrlo lepo iskorisceno 
-- u Hanojskoj kuli!!!
{-
import Control.Monad

main = do
    colors <- forM [1,2,3,4] (\a -> do  
        putStrLn $ "Which color do you associate with the number " ++ show a ++ "?"  
        color <- getLine  
        return (color ++ " "))  
    putStrLn "The colors that you associate with 1, 2, 3 and 4 are: "  
    mapM putStr colors    

Lambda izraz je neophodno staviti u zagrade kako ne bi prekoracio svoj scope, da ga tako nazovemo
Vidimo da je brdo IO akcija napakovano za svaki element liste uz pomoc forM-a
-}


