import Control.Monad  
import Data.Char  
  
{-
main = forever $ do  
    putStr "Give me some input: "  
    l <- getLine  
    putStrLn $ map toUpper l  
-}
-- sledeca alternativa koristi getContents funkciju koja uzima ceo standardni ulaz sa terminala, umesto liniju ili karakter
{-
main = do  
    contents <- getContents  
    putStr (map toUpper contents)  
-}
-- uvodi se funkcija interact koja uzima parametar funkcije koju treba da primeni na ono sto ucita sa standardnog
-- ulaza. to je kao da primenjuje getContents pa onda primenjuje funkciju! Nakon toga sve to printuje na izlaz. kul 

--main = interact $ map toUpper 

-- ovo dva gornja izvodjenja su dakle potpuno ekvivalentna
{-
main = interact respondPalindromes

respondPalindromes = unlines . map (\xs -> if isPalindrome xs then "palindrome" else "not a palindrome") . lines
                                             where isPalindrome xs = xs == reverse xs
Ovo je funkcija koja proverava da li su ulazne linije palindromi
-}
--NAPOMENA: zbog haskellove lenjosti, on kada mu unosimo liniju po liniju u program, nece cekati da zavrsimo
-- sa unosom nego ce ispisivati odmah rezultate. Isto to ce raditi i kad cita iz fajla, ali tada nece ispisivati
-- uneseni tekst pa ce delovati kao da je sacekao ceo unos sa ulaza da bi poceo da radi

--import System.IO   --modul za rad sa fajlovima
{-
main = do
     handle <- openFile "girlfriend.txt" ReadMode
     contents <- hGetContents handle
     putStr contents
     hClose handle

dosta novih stvari. openFile je funkcija definisana kao openFile :: FilePath -> IOMode -> Handle
gde je FilePath samo sinonim za String (type FilePath = String) koji saddrzi putanju do naseg fajla i njegovo ime
dok je IOMode tip definisan na sledeci nacin: data IOMode = ReadMode | WriteMode | AppendMode | ReadWriteMode
IOMode je nabrojivi tip koji govori dakle sta zelimo da radimo sa fajlom.
Handle je povratna vrednost funkcije openFile koja sluzi kao neka svojevrsna adresa fajla koja se mora vezati
za neko ime kako bi funkcije u nastavku mogle da pristupe tom fajlu i da izvrse neophodne akcije.
hGetContents je ekvivalentan obicnom getContents-u s tim sto otvara fajl, dok obican tretira terminal kao fajl
hGetContents je kul zato sto u skladu sa haskellovom lenjosti uopste ne ucitava fajl u memoriju dok nije potrebno
nesto sa njim uraditi, a mislim da i u tim okolnostima ucitava samo neophodne delove valjda. Automagija ghc-a
hClose zatvara fajl nakon sto su zeljene radnje na njemu izvrsene i vraca kontrolu terminalu!!! Ovo mora rucno da se radi
-}

--alternativa ovom kodu je sledeca sa funkcijom withFile sledece deklaracije
--withFile :: FilePath -> IOMode -> (Handle -> IO a) -> IO a
{-
import System.IO

main = do 
     withFile "girlfriend.txt" ReadMode (\handle -> do
                      contents <- hGetContents handle
                      putStr contents)
-}
-- withFile dakle radi otvaranje i zatvaranje fajla umesto nas, a u svom lambda izrazu odradi neophodno
-- izmedju otvaranj i zatvaranja
{-
withFile' :: FilePath -> IOMode -> (Handle -> IO a) -> IO a
withFile' path mode f = do
      handle <- openFile path mode
      result <- f handle
      hClose handle
      return result
-}
-- ovo je custom realizacija withFile koja radi istu stvar

--treca alternativa je koristeci funkciju readFile koja nas resava posla baratanja sa handle-ovima i
-- otvara i zatvara fajl umesto nas
--readFile :: FilePath -> IO String
{-
import System.IO

main = do
   contents <- readFile "girlfriend.txt"
   putStr contents
-}
-- sledeca je funkcija writeFile koja kreira novi fajl ili prepisuje kompletno preko vec postojeceg
-- writeFile :: FilePath -> String -> IO ()
-- funkcije koje pisu uobicajeno vracaju IO () na povratku
{-
import System.IO
import Data.Char

main = do
    contents <- readFile "girlfriend.txt" 
    writeFile "girlfriendCaps.txt" (map toUpper contents)
-}
--ova funkcija ispisuje sadrzaj girlfriend.txt u girlfriendCaps.txt sa velikim slovima

--sledeca funkcija je appendFile koja dodaje na kraj fajla bez brisanja prethodnog sadrzaja
{-
import System.IO

main = do 
     todoItem <- getLine
     appendFile "todo.txt" (todoItem ++ "\n")
-}
--bez dodavanja \n u append ne bismo dobijali nove redove

{-
You can control how exactly buffering is done by using the hSetBuffering function. It takes a handle and a
BufferMode and returns an I/O action that sets the buffering. BufferMode is a simple enumeration data type 
and the possible values it can hold are: NoBuffering, LineBuffering or BlockBuffering (Maybe Int). 
The Maybe Int is for how big the chunk should be, in bytes. If it's Nothing, then the operating system 
determines the chunk size. NoBuffering means that it will be read one character at a time. NoBuffering 
usually sucks as a buffering mode because it has to access the disk so much.
-}
{-
import System.IO
main = do   
    withFile "something.txt" ReadMode (\handle -> do  
        hSetBuffering handle $ BlockBuffering (Just 2048)  
        contents <- hGetContents handle  
        putStr contents)  
-}


-- RAD SA KOMANDNOM LINIJOM
-- ukljucuje se System.Environment modul koji u sebi sadrzi funkcije getArgs :: IO [String] i getProgName :: IO String
-- sledeci program demonstrira kako rade
{-
import System.Environment

main = do
    args <- getArgs
    progName <- getProgName
    putStrLn "The arguments are:"
    mapM putStrLn args 
    putStrLn "The Program name is:"
    putStrLn progName
-}


-- IZUZECI
{-
import System.Environment  
import System.IO  
import System.Directory  
  
main = do (fileName:_) <- getArgs  
          fileExists <- doesFileExist fileName  
          if fileExists  
              then do contents <- readFile fileName  
                      putStrLn $ "The file has " ++ show (length (lines contents)) ++ " lines!"  
              else do putStrLn "The file doesn't exist!"  
-}
-- ovo je prvi nacin da se proveri p[ostojanje fajla pomocu doesFileExist funkcije.
-- sledece su izuzeci koji imaju slicnu sintaksu kao c++-u
-- za njih se koristi funkcija catch formata catch :: IO a -> (IOError -> IO a) -> IO a.

import System.Environment  
import System.IO  
import System.IO.Error     --eksportuje IOError tip
import Control.Exception   -- eksportuje catch

  
main = toTry `catch` handler  

toTry :: IO ()
toTry = do (fileName:_) <- getArgs 
           contents <- readFile fileName  
           putStrLn $ "The file has " ++ show (length (lines contents)) ++ " lines!"  

handler :: IOError -> IO ()  
handler e  
    | isDoesNotExistError e = putStrLn "The file doesn't exist!"  
    | isUserError e         = putStrLn "Dude, u didn't put any arguments!"   --ako nisu uneti argumenti
    | otherwise = ioError e  -- funkcija koja handluje izuzetke dalje, haskelova unutrasnja

{-
isAlreadyExistsError
isDoesNotExistError
isAlreadyInUseError
isFullError
isEOFError
isIllegalOperation
isPermissionError
isUserError

Ovo su neki od mogucih izuzetaka koje haskell baca.
-}



