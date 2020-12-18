import Data.List

main = do file <- fmap ((:) '+') . filter (/= "") . lines <$> readFile "input_day18.txt"
          let filePrec = fmap ((:) '+' . (:) '(' . drop 1 . prepStr) file 
          print $ sum . fmap (foldl (\acc f -> f acc) 0 . parsExp) $ file
          print $ sum . fmap (foldl (\acc f -> f acc) 0 . parsExp) $ filePrec

strip :: String -> String
strip = takeWhile (/= ' ') . dropWhile (== ' ')

dropBl :: String -> String
dropBl = dropWhile (== ' ')

lengthPar :: Int -> String -> Int 
lengthPar 0 _ = 1 
lengthPar num (x:str) | x == '('  = 1 + (lengthPar (num + 1) str) 
                      | x == ')'  = 1 + (lengthPar (num - 1) str)
                      | otherwise = 1 + (lengthPar num str)

op :: Char -> (Int -> Int -> Int)
op c | c == '+' = (+)
     | c == '*' = (*)

parsExp :: String -> [Int -> Int]
parsExp [] = []
parsExp (x:str) |  x `elem` "+*" = case () of _
                                               | (take 1 . strip $ str) /= "(" -> ((op x) (read . takeWhile (/= ')') . strip $ str :: Int)) : (parsExp . drop (length . takeWhile (/= ')') . strip $ str) . dropBl $ str)  
                                               | (take 1 . strip $ str) == "(" -> ((op x) (foldl (\acc f -> f acc) 0 $ parsExp ((:) '+' . drop 1 . dropBl $ str))) : (parsExp . drop (lengthPar 1 . drop 1 . dropBl $ str) . dropBl $ str)
                |  x == ')' = [] 
                |  otherwise = parsExp str 

prepStr :: String -> String
prepStr [] = ")"
prepStr (x:str) | x `elem` "()" = x:x:(prepStr str)
                | x == '*'      = ')':x:'(':(prepStr str)
                | otherwise     = x:(prepStr str)



