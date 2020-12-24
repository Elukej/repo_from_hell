import qualified Data.HashTable.ST.Basic as B
import qualified Data.HashTable.Class as H
import Control.Monad.ST
import Data.Char 
import Data.List

type HashTable s k v = B.HashTable s k v

main = do file <- fmap (digitToInt) . takeWhile (\x -> not $ x `elem` " \n") <$> readFile "input_day23.txt"
          print $ fmap (intToDigit) $ (drop 1 . dropWhile (/= 1) $ game 100 file) ++ (takeWhile (/= 1) $ game 100 file)
          print $ crabGame 10000000 . crtPairs $ file ++ [(maximum file +1)..1000000] 

crtPairs :: [Int] -> [(Int,Int)]
crtPairs list = crtPairs' list
      where crtPairs' [x] = [(x,head list)]
            crtPairs' (x1:x2:list1) = (x1,x2):(crtPairs' (x2:list1)) 

findSmaller :: [Int] -> Int -> Int
findSmaller (x:list) max1 | x < 5     = if ([1..(x-1)] \\ list == []) then max1 else maximum ([1..(x-1)] \\ list) 
                          | otherwise = maximum ([(x-4)..(x-1)] \\ list)

move (x:list) = let list2  = drop 4 (x:list)
                    Just mrg  = findIndex (== (findSmaller (take 4 (x:list)) (maximum list2)) ) list2
                in  (take (mrg+1) list2) ++ ((take 3 list) ++ ((drop (mrg+1) list2) ++ [x]))

game 0 list = list
game n list = game (n-1) $ move list

crabGame :: Int -> [(Int,Int)] -> Int
crabGame nrMove list = runST $ do
    ht <- H.fromList list :: ST s (HashTable s Int Int)
    let (key,beg) = head list
        max1 = fst . last $ list 
        game n key1  = if n == 0 then H.lookup ht 1
                       else do Just x1 <- H.lookup ht key1
                               Just x2 <- H.lookup ht x1
                               Just x3 <- H.lookup ht x2
                               Just x4 <- H.lookup ht x3 
                               let sm = findSmaller [key1,x1,x2,x3] (maximum ([(max1-4)..max1] \\ [x1,x2,x3]))
                               Just y1 <- H.lookup ht sm
                               H.insert ht key1 x4
                               H.insert ht x3 y1
                               H.insert ht sm x1
                               game (n-1) x4
    Just fstAft <- game nrMove (fst . head $ list) 
    Just sndAft <- H.lookup ht fstAft 
    return (fstAft * sndAft)









                   
