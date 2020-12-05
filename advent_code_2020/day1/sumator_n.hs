-- Program proverava da li se zadati broj
-- moze dobiti pomocu n sabiraka iz liste
-- i vraca sve moguce kombinacije
-- Poziv iz komandne linije je      runhaskell sumator_n.hs <filename> <br> <n>        gde je br broj koji treba dobiti u zbiru, a n je broj sabiraka, dok je fajl name ime fajla izmedju duplih navodnika npr "input.txt"

import System.Environment

-- tails' :: [a] -> [[a]] 
tails' [] = []
tails' x = [x] ++ tails' (tail x) 

--sumatorN :: (Num a, Ord a, Eq a) => a -> a -> [a] -> [a] -> [[a]]
sumator br 0 acc _ 
               | sum acc == br   = [acc]
               | otherwise       = []   
sumator _ _ _ [] = []
sumator br n acc lista 
                     | sum acc > br   = []
                     | otherwise      = foldl (++) [] $ fmap (\y -> sumator br (n-1) ((head y):acc) $ tail y) tailsLista
                                                        where  tailsLista = filter (\x -> length x >= n) $ tails' lista

main = do
      fileName:br:n <- getArgs
      inputted <- readFile fileName            
      let lista = lines inputted
          newLista = [ read x :: Int | x <- lista]
          newBr = read br :: Int
          newN = read $ head n :: Int 
      print $ sumator newBr newN [] newLista
      return ()





