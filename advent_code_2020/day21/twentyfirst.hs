import Data.List
import qualified Data.Text as T
import qualified Data.Text.IO as IOT
import qualified Data.HashMap.Strict as HM

main = do file <- fmap ( (\x -> (T.splitOn (T.pack ", ") . last $ x, T.split (== ' ') . head $ x)) .  T.splitOn (T.pack " (contains ") . T.dropEnd 1 ) . filter (/= T.pack "") . T.split (== '\n') <$> IOT.readFile "input_day21.txt"
          let newMap = HM.empty :: HM.HashMap T.Text (HM.HashMap T.Text Int)
              hmap = foldl' (\acc (keys,list) -> foldl' (\acc2 k -> hsUpdate acc2 list k) acc keys) newMap file
              allergens = findAllergens [] (HM.toList hmap)
              newFile = concat . fmap snd $ file 
          print $ length . filter (\x -> not $ x `elem` (fmap snd allergens)) $ newFile 
          print $ T.intercalate (T.pack ",") . fmap snd . sortOn fst $ allergens
                 
hsUpdate hmap list key = hsUpdate' hmap list
            where hsUpdate' hmap1 [] = hmap1
                  hsUpdate' hmap1 (x:list) | (HM.member key hmap1) == False = hsUpdate' (HM.insert key (HM.fromList []) hmap1) (x:list) 
                                           | (HM.member x hmapEl) == False = hsUpdate' (HM.insert key (HM.insert x 1 hmapEl) hmap1) list
                                           | otherwise   =  hsUpdate' (HM.insert key (HM.insert x (value + 1) hmapEl) hmap1) list
                                  where Just hmapEl = HM.lookup key hmap1 
                                        Just value  = HM.lookup x hmapEl
                                         
maxList :: [(T.Text, Int)] -> [(T.Text, Int)]          
maxList (el:list) = foldl' (\acc (x,y) -> if y > (snd . head $ acc) then [(x,y)] else if y == (snd . head $ acc) then (x,y):acc else acc) [el] list

findAllergens :: [(T.Text,T.Text)] -> [(T.Text,HM.HashMap T.Text Int)] -> [(T.Text,T.Text)]
findAllergens res list = findAllergens' list
          where findAllergens' [] = res
                findAllergens' ((x, hmap):list1) | length filtList == 1  = findAllergens ((x, fst . head $ filtList ):res) (filter (\(al,nr) -> al /= x) list)
                                                 | otherwise = findAllergens' list1
                           where y = HM.toList hmap 
                                 filtList = filter (\(el1,el2) -> not $ el1 `elem` resVals) . maxList $ y  
                                 resVals = fmap snd res




