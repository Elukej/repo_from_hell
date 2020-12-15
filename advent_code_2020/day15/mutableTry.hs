import qualified Data.HashTable.ST.Basic as B
import qualified Data.HashTable.Class as H
import qualified Data.HashTable.IO as IOH
import Control.Monad.ST

type HashTable s k v = B.HashTable s k v

crtTable :: Int -> Int -> Int
crtTable n cmp = runST $ do
    ht <- H.newSized n :: ST s (HashTable s Int Int)
    H.insert ht 0 1 
    H.insert ht 20 2
    H.insert ht 7 3 
    H.insert ht 16 4
    H.insert ht 1 5 
    H.insert ht 18 6 
    let elfGame n1 cmp1 = do 
                         if n1 == 0  then return cmp1
                         else do x <- H.lookup ht cmp1
                                 if x == Nothing then do H.insert ht cmp1 (n-n1)
                                                         elfGame (n1-1) 0
                                 else do Just val <- H.lookup ht cmp1   
                                         H.insert ht cmp1 (n-n1)
                                         elfGame (n1-1) (n-n1-val)
    elfGame (n-7) cmp

main = do print $ crtTable 2020 15 
          print $ crtTable 30000000 15





