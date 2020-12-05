


findInd _ [] = Nothing
findInd 0 (x:lista) = Just x
findInd n (x:lista) =  findInd (n-1) lista

foldlIter _ acc _ _ [] = acc
foldlIter f acc iter dir (x:lista) = foldlIter f (f acc x iter dir) (iter+1) dir lista

checkTree acc [] _ _ = 0
checkTree acc string iter dir
                            | iter `mod` (snd dir) /= 0  = acc
                            | otherwise                  = case () of _ 
                                                                       | letter == '#' -> acc + 1
                                                                       | otherwise     -> acc
                             where Just letter = findInd (iter `div` (snd dir) * (fst dir) `mod` length string) string 

main = do
      fs <- readFile "input_day3.txt"
      let fileAsString = lines fs
          finalList = [foldlIter (checkTree) 0 0 dir fileAsString | dir <- [(1,1),(3,1),(5,1),(7,1),(1,2)] ] 
      print finalList
      print $ foldl (*) 1 finalList
