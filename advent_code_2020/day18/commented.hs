import Data.List

main = do file <- fmap ((:) '+') . filter (/= "") . lines <$> readFile "input_day18.txt"   -- ucitava fajl, deli ga na linije (<$> je fmap sa
-- orbnutim arg) zatim izbacuje prazne pa stavlja + na pocetak svakog reda
          let filePrec = fmap ((:) '+' . (:) '(' . drop 1 . prepStr) file -- radi pripremu stringa za operisanje sa precedencom (stavlja "+("
-- na pocetak umesto + (zato drop 1))
          print $ sum . fmap (foldl (\acc f -> f acc) 0 . parsExp) $ file  -- folduje kroz tabelu funkcija sa poc vred 0 pa ih posle sumira.
-- Operator "." je kompozicija fja u haskelu a "\" oznacava lambda izraz
          print $ sum . fmap (foldl (\acc f -> f acc) 0 . parsExp) $ filePrec -- isto kao malopre 

strip :: String -> String
strip = takeWhile (/= ' ') . dropWhile (== ' ')  --vraca prvi deo od pocetka stringa izmedju dve praznine, ili pocetka i prve praznine

dropBl :: String -> String
dropBl = dropWhile (== ' ')       -- skida praznine sa pocetka stringa

lengthPar :: Int -> String -> Int   -- funkcija koja odredjuje duzinu izraza izmedju zagrada ukljucujuci i zagrade. Ova funkcija racuna duzinu
-- kompletnog ugnjezdenog izraza dok se ne vrati na nivo sa kog je pocela
lengthPar 0 _ = 1   --posto pocetna zagrada nije ukljucena, jer se funkcija poziva sa num = 1. 
lengthPar num (x:str) | x == '('  = 1 + (lengthPar (num + 1) str)     -- num je nivo ugnjezdenja koji raste sa svakom novom zagradom
                      | x == ')'  = 1 + (lengthPar (num - 1) str)     -- ')' obara nivo ugnjezdenja
                      | otherwise = 1 + (lengthPar num str)          -- samo nastavi dalje

op :: Char -> (Int -> Int -> Int)  --parser za operaciju. Menja karakter operacije sa njenom reprezentacijom u Haskelu
op c | c == '+' = (+)
     | c == '*' = (*)

parsExp :: String -> [Int -> Int] --parser izraza. Krece sa leva na desno i evaluira svaki set zagrada kao zaseban izraz.
parsExp [] = [] -- na kraju vraca listu funkcija koje treba primeniti na 0 s leva na desno
parsExp (x:str) |  x `elem` "+*" = case () of _
                                               | (take 1 . strip $ str) /= "(" -> ((op x) (read . takeWhile (/= ')') . strip $ str :: Int)) : (parsExp . drop (length . takeWhile (/= ')') . strip $ str) . dropBl $ str)  
--ukoliko prvi neprazni karakter posle znakova "+*" nije zagrada, onda je broj sa eventualnom zagradom ")" na kraju.
-- Procitaj broj do zagrade ")" i ubaci ga kao jedan argument operacije "op x". Ovo stavi u listu koja nastavlja 
--rekurziju na tom nivou ugnjezdenosti od eventualne ")" ili operacije ili praznog znaka posle toga.  
                                               | (take 1 . strip $ str) == "(" -> ((op x) (foldl (\acc f -> f acc) 0 $ parsExp ((:) '+' . drop 1 . dropBl $ str))) : (parsExp . drop (lengthPar 1 . drop 1 . dropBl $ str) . dropBl $ str)
--ako je prvi karakter posle operacije otvorena zagrada, stavi '+' na njen pocetak i evaluiraj izraz unutar tog seta zagrada levim foldom
-- pokrenuvsi rekurziju na novom ugnjezdenju koja ce vratiti listu jednoargumentnih operacija unutar tih zagrada. Naravno ako je 
-- unutar tog seta zagrada novi set, rekurzija ce na isti nacin postupiti i sa njim. Dobijenu vrednost povezi sa operacijom "op x"
-- i zatim je stavi u listu koja se dobija rekurzijom na istom nivou ugnjezdenja pocetne operacije posle celog seta evaluiranih zagrada.
-- Za ovo koristimo funkciju lengthPar koja nam daje informaciju koliko karaktera treba dropovati da se zagrade preskoce.  

                |  x == ')' = [] -- kada naidje na kraj zagrade zavrsava tu granu rekurzije i pocinje sa evaluacijom zagrade, ili punjenjem finalne liste
                |  otherwise = parsExp str -- ako je praznina, samo prodji dalje

prepStr :: String -> String   -- priprema funkciju za operisanje sa precedencom
prepStr [] = ")"  -- funkcija pravi ugnjezdenje oko "*" operatora tako sto ih ubacuje izmedju ")*(" tako osiguravajuci da se ove operacije
-- poslednje evaluiraju. String se mora pozvati sa pocetnom zagradom da bi se to matchovalo sa ")" koja se uvek stavlja na kraj
prepStr (x:str) | x `elem` "()" = x:x:(prepStr str) --svaka zagrada se duplira za svaki slucaj jer se u tom trenutku ne moze pradvideti koji
-- ce sledeci znak naici, i da li ce biti * znaka na tom nivou ugnjezdenja
                | x == '*'      = ')':x:'(':(prepStr str)
                | otherwise     = x:(prepStr str)



