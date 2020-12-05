import System.Environment
import Data.Char

{- prva varijanta resenja od koje sam odustao zarad bolje delim2 koja pravi listu od stringa prema celom stringu delimitera
--delimiter :: Char -> [Char] -> [[Char]]
delimiter _ [] = []
delimiter c string = [takeWhile (/= c) string] ++ delimiter c (tail' (dropWhile (/= c) string))
                      where tail' [] = []
                            tail' xs = tail xs
parse _ [] = []
parse c listStr = filter (/= "") $ concat $ fmap (delimiter c) listStr

--(parse '-' . parse ':' . words) "15-17 p : qwwewe" = ["15","17","p","qwwewe"]
-}


delim2 _ [] = []
delim2 charSet string = filter (/= "") $ [takeWhile (\x -> not (x `elem` charSet)) string] ++ 
                        delim2 charSet (tail' (dropWhile (\x -> not (x `elem` charSet)) string))
                        where tail' [] = []
                              tail' xs = tail xs 

findInd _ [] = Nothing
findInd 0 (x:lista) = Just x
findInd n (x:lista) =  findInd (n-1) lista

checkValid lista 
               | (length $ filter (== letter) string) >= (read lower)  &&
                 (length $ filter (== letter) string) <= (read upper) && 
                 length lista == 4                                          = 1 
               | otherwise                                                  = 0
                         where Just lower = findInd 0 lista
                               Just upper = findInd 1 lista
                               Just (letter:[]) = findInd 2 lista
                               Just string = findInd 3 lista

checkValidMod lista 
               | ((first == letter || second == letter) &&
                 not (first == letter && second == letter)) && 
                 length lista == 4                                          = 1 
               | otherwise                                                  = 0
                         where Just lower = findInd 0 lista
                               Just upper = findInd 1 lista
                               Just (letter:[]) = findInd 2 lista
                               Just string = findInd 3 lista
                               lb = (read lower :: Int) -1
                               ub = (read upper :: Int) -1 
                               Just first = findInd lb string
                               Just second = findInd ub string 
                            -- Ova dva koda iz nekog razloga katastrofalno failuju. Ne znam zasto, prijavljuje parse greske 
                            -- na else ili na | i nece da radi  a ova verzija koju sam ostavio radi za dati fajl ali je nepotpuna
                              {-Just first = if (lb > length string || lb < 0) then Just '' else (findInd lb string)
                               Just second = if (ub > length string || ub < 0) then Just '' else (findInd ub string)-}
                              {- Just first
                                                | (ub > length string) || ub < 0  = Just '' 
                                                | otherwise                       = findInd lb string 
                               Just second 
                                                | (ub > length string) || ub < 0  = Just '' 
                                                | otherwise                       = findInd ub string
                              -}
main = do
      fs <- readFile "input_day2.txt"
      let fileAsList = lines fs
      print $ foldl (\acc string -> acc + checkValid (delim2 " :-" string)) 0 fileAsList
      print $ foldl (\acc string -> acc + checkValidMod (delim2 " :-" string)) 0 fileAsList


