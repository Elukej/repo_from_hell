import qualified Data.Text as T
import qualified Data.Text.IO as IOT
import Text.Read
import Data.List

main = do nr:bus <- fmap (T.unpack) <$> T.split (\x -> x `elem` "\n,") <$> IOT.readFile "input_day13.txt"
          let busList = (\x -> readMaybe x :: Maybe Int) <$> bus
              timeStamp = read nr :: Int 
              fun x = (timeStamp `div ` x + 1) * x `rem` timeStamp
              targetBus =  foldl (\acc (Just x) -> if (fun x) < (fun acc) || ((fun x) == (fun acc) && x < acc) then x else acc) (timeStamp-1) $ filter (/= Nothing) busList          
              busTuples =  mkBusIdDep 0 $ busList
          print $ fun targetBus * targetBus     --part 1
          print $ foldl (findMagicNr2) (head busTuples) $ drop 1 busTuples --part 2
                  
mkBusIdDep _ [] = []
mkBusIdDep index (x:buses) | x == Nothing = mkBusIdDep (index + 1) buses
                           | otherwise    = (val, val - (index `rem` val)) : mkBusIdDep (index + 1) buses
                             where Just val = x

findMagicNr2 :: (Int,Int) -> (Int,Int) -> (Int,Int)
findMagicNr2 (refX,refY) (x,y) = if refX `rem` x == y then (refX, refY * x) else findMagicNr2 (refX + refY, refY) (x,y)
