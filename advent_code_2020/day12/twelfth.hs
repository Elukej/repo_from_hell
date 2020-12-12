import Data.List

move :: (Char,Int) -> (Char,(Int,Int)) -> (Char,(Int,Int))
move (x,y) (dir,(ns,ew)) | x == 'N'        = (dir,(ns + y, ew))
                         | x == 'S'        = (dir,(ns - y, ew))
                         | x == 'E'        = (dir,(ns, ew + y))
                         | x == 'W'        = (dir,(ns, ew - y))
                         | x == 'F'        = move (dir, y) (dir,(ns,ew))
                         | otherwise       = (dirChange,(ns,ew))
                             where  dirChange  | x == 'R'  = listDir !! ((index + y `div` 90) `mod` 4)  
                                               | x == 'L'  = listDir !! ((index - y `div` 90) `mod` 4) 
                                    Just index = elemIndex dir listDir 
                                    listDir = ['N','E','S','W']

move2 :: (Char,Int) -> ((Int,Int),(Int,Int)) -> ((Int,Int),(Int,Int))
move2 (x,y) ((wptNE, wptEW),(ns,ew)) | x == 'N'        = ((wptNE + y, wptEW),(ns,ew))
                                     | x == 'S'        = ((wptNE - y, wptEW),(ns,ew))
                                     | x == 'E'        = ((wptNE, wptEW + y),(ns,ew))
                                     | x == 'W'        = ((wptNE, wptEW - y),(ns,ew))
                                     | x == 'F'        = ((wptNE, wptEW),(ns + y * wptNE, ew + y * wptEW))
                                     | otherwise       = (dirChange,(ns,ew))
                             where  dirChange  | y == 180                                       = (-wptNE, -wptEW) 
                                               | (x == 'R' && y == 90) || (x =='L' && y == 270) = (-wptEW, wptNE)
                                               | (x == 'L' && y == 90) || (x =='R' && y == 270) = (wptEW, -wptNE)
                                                                  
main = do lista <-  fmap (\x -> (head x, read $ drop 1 x :: Int)) . lines <$> readFile "input_day12.txt"
          print $ foldl (flip move) ('E',(0,0)) lista
          print $ foldl (flip move2) ((1,10),(0,0)) lista

