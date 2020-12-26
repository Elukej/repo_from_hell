import qualified Data.Text as T
import qualified Data.Text.IO as IOT
import qualified Data.Map.Strict as Map
import Data.List
import Data.Bits ((.&.))

main = do file <- fmap (T.unpack) . filter (/= T.pack "") . T.split (== '\n') <$> IOT.readFile "input_day24.txt"
          let tileMap = Map.fromListWith (+) . fmap (parse) $ file
          print $ foldl' (\acc x -> acc + (x `rem` 2)) 0 . Map.elems $ tileMap
          print $ length . Map.keys . dayChange 100 $ Map.filter (\x -> toEnum $ x .&. 1) tileMap

parse string = parse' ((0,0),1) string 
      where parse' res1 [] = res1 
            parse' ((x,y),_) string   | (take 1 string) == "e"  = parse' ((x+1,y),1) $ drop 1 string
                                      | (take 1 string) == "w"  = parse' ((x-1,y),1) $ drop 1 string
                                      | (take 2 string) == "ne" = parse' ((x+0.5,y+1),1) $ drop 2 string
                                      | (take 2 string) == "sw" = parse' ((x-0.5,y-1),1) $ drop 2 string
                                      | (take 2 string) == "se" = parse' ((x+0.5,y-1),1) $ drop 2 string
                                      | (take 2 string) == "nw" = parse' ((x-0.5,y+1),1) $ drop 2 string

prepTiles tMap = prepTiles' (Map.keys tMap) tMap
           where prepTiles' [] tMap1 = tMap1
                 prepTiles' ((x,y):list) tMap1 = prepTiles' list $ tMap1 `Map.union` (Map.fromList forMap) 
                  where forMap =[((x+1,y),0),((x-1,y),0),((x+0.5,y+1),0),((x-0.5,y-1),0),((x+0.5,y-1),0),((x-0.5,y+1),0)]

travTiles tMap = travTiles' (Map.keys tMap) tMap 
      where travTiles' [] tMap1 = tMap1
            travTiles' ((x,y):list1) tMap1 | (vref .&. 1 == 0) && nrBlack /= 2 || (vref .&. 1 == 1) && (not $ nrBlack `elem` [1,2]) = travTiles' list1 $ Map.delete (x,y) tMap1
                                           | otherwise = travTiles' list1 $ Map.insertWith (+) (x,y) (fromEnum (vref .&. 1 == 0)) tMap1
                                                  where forMap = [(x+1,y),(x-1,y),(x+0.5,y+1),(x-0.5,y-1),(x+0.5,y-1),(x-0.5,y+1)]
                                                        vList = fmap (\x -> if Map.member x tMap then Map.lookup x tMap else Just 0) forMap 
                                                        Just vref = Map.lookup (x,y) tMap1
                                                        nrBlack = foldl' (\acc (Just x) -> acc + (x .&. 1)) 0 vList

dayChange :: Int -> Map.Map (Float,Int) Int -> Map.Map (Float,Int) Int
dayChange 0 tMap = tMap
dayChange n tMap = dayChange (n-1) $ travTiles tMap1
      where tMap1 = prepTiles tMap





