import Data.List

suma2 :: Int -> [Int] -> Bool
suma2 br [x] = False 
suma2 br (x:lista) 
              | br `elem` ((+x) <$> lista) = True
              | otherwise                  = suma2 br lista

check25 :: [Int] -> Int
check25 lista
              | take 26 lista == []                                    = 0  
              | not . suma2 (head . drop 25 $ lista) $ take 25 lista   = head . drop 25 $ lista
              | otherwise                                              = check25 $ drop 1 lista

caterpillar :: Int -> Int -> Int -> [Int] -> [Int]
caterpillar _ _ _ [] = []
caterpillar br index acc (x:lista)
               | acc == br                         = take index (x:lista)
               | index == length lista && acc < br = []
               | acc < br                          = caterpillar br (index + 1) (((x:lista) !! index) + acc) (x:lista) 
               | acc > br                          = caterpillar br (index - 1) (acc - x) lista

main = do lista <- filter (/="") . lines <$> readFile "input_day9.txt"
          let listaInt = fmap (\x -> read x :: Int) lista 
              result = caterpillar (check25 listaInt) 0 0 listaInt
          print $ check25 listaInt
          print (maximum result + minimum result)
              


