{-# LANGUAGE ScopedTypeVariables #-}

import qualified Data.HashTable.ST.Basic as B
import qualified Data.HashTable.Class as H
import Control.Monad.ST
import Data.Char 
import Data.List
import Data.Array.ST
import Data.Array

type HashTable s k v = B.HashTable s k v

main = do file <- fmap (digitToInt) . takeWhile (\x -> not $ x `elem` " \n") <$> readFile "input_day23.txt"
          let list = (fst . head . crtPairs $ file) : ( fmap snd . sortOn fst $ (init $ crtPairs file) ++ [(last file, (maximum file) + 1)])
              list2 = list ++ (drop 1 . fmap snd . crtPairs $ (head list):[(maximum list)..1000000])
          print $ fmap (intToDigit) $ (drop 1 . dropWhile (/= 1) $ game 100 file) ++ (takeWhile (/= 1) $ game 100 file)
          print $ runST $ crabGame 10000000 list2

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

crabGame ::  forall s. Int -> [Int] -> ST s Int
crabGame nrMove list = do
    arr <- newListArray (0,length list - 1) $ list :: ST s (STUArray s Int Int)
    let beg = head list
        max1 = length list - 1
        game :: Int -> Int -> ST s Int
        game n key1 = if (n == 0) then readArray arr 1                                      
                      else do  x1 <- readArray arr key1
                               x2 <- readArray arr x1
                               x3 <- readArray arr x2
                               x4 <- readArray arr x3 
                               let sm = findSmaller [key1,x1,x2,x3] (maximum ([(max1-4)..max1] \\ [x1,x2,x3]))
                               y1 <- readArray arr sm
                               writeArray arr key1 x4
                               writeArray arr x3 y1
                               writeArray arr sm x1
                               game (n - 1) x4
    fstAft <- game nrMove beg
    sndAft <- readArray arr fstAft 
    return (fstAft * sndAft)










                   
