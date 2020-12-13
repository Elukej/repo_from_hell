import qualified Data.Text as T
import qualified Data.Text.IO as IOT
import Text.Read
import Data.List

main = do nr:bus <- fmap (T.unpack) <$> T.split (\x -> x `elem` "\n,") <$> IOT.readFile "input_day13.txt"
          let busList = (\x -> readMaybe x :: Maybe Int) <$> bus
              timeStamp = read nr :: Int 
              fun x = (timeStamp `div ` x + 1) * x `rem` timeStamp
              targetBus =  foldl (\acc (Just x) -> if (fun x) < (fun acc) || ((fun x) == (fun acc) && x < acc) then x else acc) (timeStamp-1) $ filter (/= Nothing) busList          
              busTuples = fmap (\(x,y) -> if y /= 0 then (x,x-y) else (x,y)) . fmap (foldl (\(accX,accY) (x,y) -> (accX*x, y)) (1,0)) . groupBy (\x y -> snd x == snd y) . quicksort . mkBusIdDep 0 $ busList
              (maxTupl, newBusTuples) = (maximum busTuples, filter (/= maximum busTuples) busTuples) 
              part2Timestamp :: Int -> Int
              part2Timestamp number =  if all (id) . fmap (\(x,y) -> number `rem` x == y) $ newBusTuples then number else part2Timestamp (number + fst maxTupl)
          print $ fun targetBus * targetBus
          print (maxTupl,newBusTuples)
          print $ part2Timestamp (snd maxTupl)

mkBusIdDep _ [] = []
mkBusIdDep index (x:buses) | x == Nothing = mkBusIdDep (index + 1) buses
                           | otherwise    = (val,index `rem` val) : mkBusIdDep (index + 1) buses
                             where Just val = x

quicksort :: [(Int,Int)] -> [(Int,Int)]
quicksort [] = []
quicksort (x:lista) = (quicksort xl) ++ [x] ++ (quicksort xr)
                          where xl = filter (\(x1,y1) -> y1 < snd x) lista
                                xr = filter (\(x1,y1) -> y1 >= snd x) lista
