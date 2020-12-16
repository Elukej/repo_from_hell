import qualified Data.Text as T
import qualified Data.Text.IO as IOT
import qualified Data.HashSet as HS
import Data.List
import Data.Array
import Control.Concurrent (threadDelay)

main = do [crit, ytic, otic] <- T.splitOn (T.pack "\n\n") <$> IOT.readFile "input_day16.txt"
          let nrOtic =  fmap ((\x -> read x :: Int) . T.unpack) . T.split (== ',') <$> (filter (/= T.pack "") . T.split (`elem` "\n") . T.drop 1 . T.dropWhile (/= '\n') $ otic)
              nrCrit = fmap ((\x -> (read . T.unpack . head $ x :: Int, read . T.unpack .last $ x :: Int) ) . T.split (== '-')) <$> (T.splitOn (T.pack " or ") . T.strip . T.drop 1 . T.dropWhile (/= ':') <$> (T.lines crit))
              nrYtic = ((\x -> read x :: Int) . T.unpack) <$> (T.split (== ',') . T.drop 1 . T.dropWhile (/= '\n') $ ytic)

              notAllow = foldl (\acc (x,y) -> HS.filter (\z -> z < x || z > y) acc) (HS.fromList [0..999]) $ concat nrCrit
              badTickNum = foldl (\acc x -> if HS.member x notAllow then x:acc else acc) [] $ concat nrOtic
              validTick = nrYtic : foldl (\acc x -> if HS.fromList x `HS.intersection` notAllow /= HS.fromList [] then acc else x:acc) [] nrOtic
              arrTick = listArray ((0,0),(length validTick - 1, length nrCrit - 1)) $ concat validTick --uporedni niz od karata
              posList = findOrder 0 0 arrTick nrCrit -- lista koja sadrzi moguca polja 
              posTupl = fmap (\x -> (findIndex (== x) posList, x)) posList --tupl koji sadrzi sve moguce kombinacije polja za svaku kolonu plus indeks kolone za koju to vazi         
              mayIndex =  fst <$> (filter (\x -> (head . snd $ x) `elem` [Just 0, Just 1, Just 2, Just 3, Just 4, Just 5]) $ finalFields posTupl) -- lista sa finalnim indeksima trazenih polja u Maybe formatu
          print $ sum badTickNum -- part 1
          print $ foldl (\acc (Just x) -> (nrYtic !! x) * acc) 1 mayIndex -- part 2

findOrder :: Int -> Int -> Array (Int, Int) Int -> [[(Int,Int)]] -> [[Maybe Int]]
findOrder row col arr list = findOrder' row col list
          where findOrder' row1 col1 [] = [] : (findOrder 0 (col + 1) arr list)
                findOrder' row1 col1 (x:wList1) 
                      | (snd . snd . bounds $ arr) + 1 == col1  = []
                      | (fst . snd . bounds $ arr) + 1 == row1  = (findIndex (== x) list : (head $ findOrder' 0 col1 wList1)) : (drop 1 $ findOrder' 0 col1 wList1)
                      | ((el >= (fst $ head x)) && (el <= (snd $ head x))) || ((el >= (fst $ last x)) && (el <= (snd $ last x))) = findOrder' (row1 + 1) col1 (x:wList1)
                      | otherwise = findOrder' 0 col1 wList1
                           where el = arr ! (row1,col1)

finalFields :: [(Maybe Int,[Maybe Int])] -> [(Maybe Int,[Maybe Int])]
finalFields list = finalFields' list 
           where finalFields' [] = []
                 finalFields' (x:list1) | (length . snd $ x) == 1  = x : finalFields newList
                                        | otherwise               = finalFields' list1
                   where newList = filter (\y -> snd y /= []) . fmap (\(z1,z2) -> (z1, filter ( /= (head . snd $ x)) z2) ) $ list 








