import Data.List

differences ::  (Int,Int) -> [Int] -> (Int, Int)
differences acc [x] = acc
differences (diff1, diff3) (x:y:lista) = (\(accX,accY) (d1, d3) -> (accX + d1, accY + d3)) (differences (diff1, diff3) (y:lista)) (fromEnum (y-x == 1), fromEnum (y-x == 3))

listForComb :: Int -> [Int] -> [[Int]]
listForComb _ [x] = [[]]
listForComb ind (x:y:lista)
                  | y-x == 3  = [[]] ++ listForComb 1 (y:lista)
                  | ind == 1  = listForComb 0 (y:lista)
                  | otherwise = [(x:(head $ listForComb 0 (y:lista)))] ++ (drop 1 $ listForComb 0 (y:lista))

caseCombination :: [[Int]] -> [Int]
caseCombination [] = []
caseCombination (x:list) = case (length x) of 1 -> 2:(caseCombination list)
                                              2 -> 4:(caseCombination list)
                                              3 -> 7:(caseCombination list)  

main = do lista <- filter (/= "") . lines <$> readFile "input_day10.txt"
          let listaInt = sort $ fmap (\x -> read x :: Int) lista
              (x, y) = differences (0,0) listaInt
              list2 = caseCombination . filter (/= []) . listForComb 1 $ (0:listaInt)
          print $ (x+1)*(y+1)
          print $ foldl (*) 1 list2
