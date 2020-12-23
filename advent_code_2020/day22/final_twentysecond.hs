import Data.List
import qualified Data.Text as T
import qualified Data.Text.IO as IOT
import qualified Data.HashMap.Strict as HM
import qualified Data.HashSet as HS

main = do [pl1, pl2] <- fmap (fmap (\x -> read . T.unpack $ x :: Int) . filter (/= T.pack "") . T.split (== '\n') . T.drop 1 . T.dropWhile (/= '\n')) .  T.splitOn (T.pack "\n\n") <$> IOT.readFile "input_day22.txt"
          print $ foldl' (+) 0 $ zipWith (*) [(2*(length pl1)),(2*(length pl1) - 1)..1] $ game pl1 pl2
          print $ foldl' (+) 0 $ zipWith (*) [(2*(length pl1)),(2*(length pl1) - 1)..1] $ recGame pl1 pl2 

game [] pl2 = pl2
game pl1 [] = pl1
game (x:pl1) (y:pl2) | x > y     = game (pl1 ++ (x:y:[])) pl2
                     | otherwise = game pl1 (pl2 ++ (y:x:[]))

recGame pl1 pl2 = recGame' 1 0 pl1 pl2 (HM.empty :: HM.HashMap Int (([Int],[Int]),HS.HashSet [Int])) 
            where recGame' 1 _ [] pl2' _ = pl2'
                  recGame' 1 _ pl1' [] _ = pl1'
                  recGame' nrGame _ [] pl2' hmap = recGame' (nrGame - 1) 2 prevMe prevCrab (HM.delete nrGame hmap)
                             where Just ((prevMe,prevCrab),_) = HM.lookup (nrGame - 1) hmap                
                  recGame' nrGame _ pl1' [] hmap = recGame' (nrGame - 1) 1 prevMe prevCrab (HM.delete nrGame hmap)
                             where Just ((prevMe,prevCrab),_) = HM.lookup (nrGame - 1) hmap                 
                  recGame' nrGame win (x:pl1') (y:pl2') hmap | (HM.member nrGame hmap) == False = recGame' nrGame win (x:pl1') (y:pl2') (HM.insert nrGame (([],[]),HS.empty :: HS.HashSet [Int]) hmap)
                                                             | win /= 0  = case win of 1 -> recGame' nrGame 0 (pl1' ++ [x,y]) pl2' (HM.insert nrGame (([],[]), HS.insert ((pl1') ++ (pl2')) hset) hmap )
                                                                                       2 -> recGame' nrGame 0 pl1' (pl2' ++ [y,x]) (HM.insert nrGame (([],[]), HS.insert ((pl1') ++ (pl2')) hset) hmap )
                                                             | (max1 > max2) && (max1 > (length (x:pl1') + length (y:pl2'))) || (HS.member ((pl1') ++ (pl2')) hset ) = recGame' (nrGame - 1) 1 prevMe prevCrab (HM.delete nrGame hmap)
                                                             | (x <= length pl1') && (y <= length pl2') = recGame' (nrGame + 1) 0 (take x pl1') (take y pl2') (HM.insert nrGame (((x:pl1'),(y:pl2')), hset) hmap)
                                                             | x > y = recGame' nrGame 0 (pl1' ++ [x,y]) pl2' (HM.insert nrGame (([],[]), HS.insert ((pl1') ++ (pl2')) hset) hmap)
                                                             | y > x = recGame' nrGame 0 pl1' (pl2' ++ [y,x]) (HM.insert nrGame (([],[]), HS.insert ((pl1') ++ (pl2')) hset) hmap )
                          where Just (_,hset) = HM.lookup (nrGame) hmap 
                                Just ((prevMe,prevCrab),_) = HM.lookup (nrGame - 1) hmap
                                max1 = maximum (x:pl1')
                                max2 = maximum (y:pl2')


