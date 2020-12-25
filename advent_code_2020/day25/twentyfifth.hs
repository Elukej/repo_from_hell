import qualified Data.Text as T
import qualified Data.Text.IO as IOT
import Data.List

main = do [pub1,pub2] <- fmap (\x -> read . T.unpack $ x :: Int) . filter (/= T.pack "") . T.split (== '\n') <$> IOT.readFile "input_day25.txt"
          let f = (\sn x ->  x * sn `rem` 20201227)
              Just loop1 = findIndex (== pub1) $ iterate (f 7) 1 
              Just loop2 = findIndex (== pub2) $ iterate (f 7) 1
          if minimum [loop1, loop2] == loop1 then print $ (iterate (f pub2) 1) !! loop1
                                             else print $ (iterate (f pub1) 1) !! loop2
