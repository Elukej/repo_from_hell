import Data.List
import qualified Data.Text as T
import qualified Data.Text.IO as IOT
import qualified Data.HashMap.Strict as HM
import qualified Data.HashSet as HS
import Data.Char

main = do [rules, strings] <- fmap ( filter (/= T.pack "") . T.split (== '\n') ) <$> T.splitOn (T.pack "\n\n") <$> IOT.readFile "input_day19.txt"
          let tuplRules = HM.fromList $ fmap (\x -> (read . T.unpack . head . spl $ x :: Int, fmap (T.split (== ' ')) . T.splitOn (T.pack " | ") . T.filter (/= '\"') . last . spl $ x)) rules
              spl = T.splitOn (T.pack ": ")
              cmp42 = HS.fromList $ findStr 42 tuplRules
              cmp31 = HS.fromList $ findStr 31 tuplRules
          print $ length . filter (== True) . fmap (checkMatch cmp42 cmp31 0) $ filter (\x -> T.length x == 24) strings --part1
          print $ length . filter (== True) . fmap (checkMatch cmp42 cmp31 0) $ strings --part2
          
isLett :: [[T.Text]] -> Bool
isLett text = all (isAlpha) $ T.unpack . T.concat . concat $ text

findStr ::  Int -> HM.HashMap Int [[T.Text]] -> [T.Text]
findStr index hmap = findStr' index
            where findStr' index1 | (isLett list) = foldl1 (\acc x -> [i `T.append` j | i <- acc, j <- x]) list
                                  | otherwise     =  concat . fmap (foldl1 (\acc x -> [i `T.append` j | i <- acc, j <- x]) . fmap (findStr' . number) ) $ list 
                      where (Just list) = HM.lookup index1 hmap
                            number x = read . T.unpack $ x :: Int

checkMatch :: HS.HashSet T.Text -> HS.HashSet T.Text -> Int -> T.Text -> Bool
checkMatch cmp42 cmp31 index str = checkMatch' index
           where checkMatch' i1  | (T.length str) - param*8 > i1*8 = if (HS.member eight cmp42) then checkMatch' (i1+1) else False
                                 | (T.length str) - 8 > i1*8 = if ((HS.member eight cmp42) || (HS.member eight cmp31)) then checkMatch' (i1+1) else False
                                 | otherwise = if (HS.member eight cmp31) then True else False
                      where lenx8 = (T.length str) `div` 8  
                            param =  lenx8 `div` 2 + lenx8 `rem` 2 - 1
                            eight = T.take 8 . T.drop (i1*8) $ str



