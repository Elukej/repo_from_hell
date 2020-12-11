--ispisivanje permutacija
import Data.List

--perm :: [a] -> [[a]] 
perm [] = [[]]
perm list =  foldl (++) [] $ fmap (\xs -> fmap ((:) $ head xs) $ perm $ tail xs) $ chBeg list list
                           where --dropFirst :: (Eq a) => a -> [a] -> [a]
                             dropFirst _ [] = []
                             dropFirst x (y:ys) 
                                        | x /= y     = y : dropFirst x ys
                                        | otherwise  = ys
                        --chBeg :: a -> a -> [a] 
                             chBeg _ [] = []
                             chBeg xs (y:ys)  
                                        | not (y `elem` ys) = [(y : dropFirst y xs)] ++ chBeg xs ys 
                                        | otherwise         = chBeg xs ys

--main = do
      --print $ perm [1..8] 7,757s
      -- print $ permutations [1..8] 6,311s



{- perm [1,2] = foldl (++) [] (fmap (\xs -> fmap ((:) head xs) $ perm $ tail xs) $ chBeg [1,2] [1,2])
=>              
              = foldl (++) [] (fmap (\xs -> fmap ((:) head xs) $ perm $ tail xs) [[1,2],[2,1]])

              = foldl (++) [] [(\xs -> fmap ((:) head xs) $ perm $ tail xs) [1,2], (\xs -> fmap ((:) head xs) $ perm $ tail xs) [2,1]]

              = foldl (++) [] [fmap ((:) head [1,2]) $ perm $ tail [1,2], fmap ((:) head [2,1]) $ perm $ tail [2,1]]

              = foldl (++) [] [fmap ((:) 1) $ perm [2], fmap ((:) 2) $ perm [1]]

       (*)    = (fmap ((:) 1) $ perm [2]) ++ (fmap ((:) 2) $ perm [1])

              perm [2] = foldl (++) [] (fmap (\xs -> fmap ((:) head xs) $ perm $ tail xs) $ chBeg [2] [2])

                       = foldl (++) [] (fmap (\xs -> fmap ((:) head xs) $ perm $ tail xs) [[2]])           

                       = foldl (++) [] [(\xs -> fmap ((:) head xs) $ perm $ tail xs) [2]]

                       = foldl (++) [] [fmap ((:) 2) $ perm []]

                       = fmap ((:) 2) $ perm []


-}











