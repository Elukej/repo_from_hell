{-# LANGUAGE ScopedTypeVariables #-}

import Control.Monad.ST
import Data.Array.ST
import qualified Data.Text as T
import qualified Data.Text.IO as IOT

crtTable :: forall s. Int -> Int -> [Int] -> ST s Int
crtTable n cmp list = do
    arr <- newArray (0,n) (-1) :: ST s (STUArray s Int Int)
    let  fill :: Int -> [Int] -> ST s ()
         fill ind [] = return ()
         fill ind (x:list1) = do writeArray arr x ind
                                 fill (ind+1) list1
         elfGame :: Int -> Int -> ST s Int
         elfGame n1 cmp1 = do 
                         if n1 == 0  then return cmp1
                         else do x <- readArray arr cmp1
                                 if x == (-1) then do writeArray arr cmp1 (n-n1)
                                                      elfGame (n1-1) 0
                                 else do val <- readArray arr cmp1   
                                         writeArray arr cmp1 (n-n1)
                                         elfGame (n1-1) (n-n1-val)
    fill 1 list
    elfGame (n-7) cmp

main = do file <- fmap ((\x -> read x ::Int) . T.unpack) . T.split (== ',') . T.takeWhile (/= '\n') <$> IOT.readFile "input_day15.txt"
          print $ runST $ crtTable 2020 (last file) (init file) 
          print $ runST $ crtTable 30000000 (last file) (init file)
         




