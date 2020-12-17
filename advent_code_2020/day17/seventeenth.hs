import qualified Data.Text as T
import qualified Data.Text.IO as IOT
import Data.Array
import Data.List

main = do file <- fmap (\x -> T.center (T.length x + 4) '.' x) . T.lines <$> IOT.readFile "input_day17.txt"
          let dots   = T.pack . take ( (length file + 6) * (T.length $ head file) ) . repeat $ '.'
              string = T.unpack . T.intercalate (T.pack "") $ (dots:file) ++ (dots:[T.dropEnd (2*(T.length $ head file)) dots])
              mat3d  = listArray ((0,0,0),(3, (T.length $ head file) - 1, (T.length $ head file) - 1)) string
              part1 = process 1 mat3d
              sum3d  = (\(x,y) -> (T.count (T.pack "#") x) + 2 * (T.count (T.pack "#") y)) 
              string4d = (T.unpack $ padDots $ length string) ++ string ++ ( (T.unpack $ padDots $ length string) ++ (T.unpack $ padDots $ length string) )
              mat4d = listArray ((0,0,0,0),(3,3,(T.length $ head file) - 1, (T.length $ head file) - 1)) string4d
              part2 = process4d 1 mat4d
          print $ sum3d part1
          print $ (sum3d . fst $ part2) + 2 * (foldl (+) 0 . fmap (sum3d) . snd $ part2)   

fst3 (x,_,_) = x
snd3 (_,y,_) = y
trd3 (_,_,z) = z

padDots n = T.pack . take n . repeat $ '.'

countCube3x3x3 :: Int -> Int -> Int -> Array (Int,Int,Int) Char -> Int
countCube3x3x3 row col dim3 arrayText = length . filter (== '#') $ [arrayText ! (i,j,k) | i <- xs , j <- ys, k <- zs]
                               where xs = [row-1,row,row+1]
                                     ys = [col-1,col,col+1]
                                     zs = [dim3-1,dim3,dim3+1]

traverseText :: Int -> Int -> Int -> Array (Int,Int,Int) Char -> String
traverseText height row column arrayText = travTxt height row column
     where travTxt height1 row1 col1  =  case () of _
                                                     | height1 == (fst3 . snd $ bounds arrayText) -> []
                                                     | row1 == (snd3 . snd $ bounds arrayText) -> travTxt (height1 + 1) 1 1
                                                     | col1 == (trd3 . snd $ bounds arrayText) -> travTxt height1 (row1 + 1) 1     
                                                     | letter == '.'   -> if actCube == 3 then '#' : (travTxt height1 row1 (col1 + 1)) else  '.' : (travTxt height1 row1 (col1 + 1)) 
                                                     | letter == '#'   -> if actCube `elem` [3,4] then '#' : (travTxt height1 row1 (col1 + 1)) else  '.' : (travTxt height1 row1 (col1 + 1))
                       where actCube = countCube3x3x3 height1 row1 col1  arrayText  
                             letter  = arrayText ! (height1,row1,col1)

process :: Int -> Array (Int,Int,Int) Char -> (T.Text, T.Text)
process index arrayText = let newText = T.pack $ traverseText 1 1 1 arrayText 
                              (x,y,z) = ((trd3 . snd $ bounds arrayText) - 1, (snd3 . snd $ bounds arrayText) - 1, (fst3 . snd $ bounds arrayText) - 1)
                              addZ = (\list -> (list !! 1) : ( list ++ [padDots (x*y) , padDots (x*y)] )) 
                              addY = (\list -> (padDots (2*x)) : (intersperse (padDots (4*x)) list) ++ [padDots (2*x)])
                              addX = (\list -> fmap (\txt -> T.center (x + 4) '.' txt) . concat . fmap (T.chunksOf x) $ list) 
                              string =  T.unpack . T.intercalate (T.pack "") . addX . addY . addZ . T.chunksOf (x*y) $ newText
                              newArray = listArray ((0,0,0),(z+2,y+3,x+3)) string
                          in if index == 6 then T.splitAt (x*y) newText else process (index + 1) newArray

----------------------------------------------------------------------------------------------------------------------------------------

fst4 (x,_,_,_) = x
snd4 (_,y,_,_) = y
trd4 (_,_,z,_) = z
frt4 (_,_,_,w) = w

countCube4d :: Int -> Int -> Int -> Int -> Array (Int,Int,Int,Int) Char -> Int
countCube4d time dim3 row col  arrayText = length . filter (== '#') $ [arrayText ! (i,j,k,l) | i <- ws , j <- zs, k <- ys, l <- xs]
                               where xs = [col-1,col,col+1]
                                     ys = [row-1,row,row+1] 
                                     zs = [dim3-1,dim3,dim3+1]
                                     ws = [time-1,time,time+1]

traverseText4d :: Int -> Int -> Int -> Int -> Array (Int,Int,Int,Int) Char -> String
traverseText4d time height row column arrayText = travTxt4d time height row column
     where travTxt4d time1 height1 row1 col1  =  case () of _       
                                                             | time1 == (fst4 . snd $ bounds arrayText)  -> []                        
                                                             | height1 == (snd4 . snd $ bounds arrayText) -> travTxt4d (time1 + 1) 1 1 1
                                                             | row1 == (trd4 . snd $ bounds arrayText) -> travTxt4d time1 (height1 + 1) 1 1
                                                             | col1 == (frt4 . snd $ bounds arrayText) -> travTxt4d time1 height1 (row1 + 1) 1
                                                             | letter == '.'   -> if actCube == 3 then '#' : (travTxt4d time1 height1 row1 (col1 + 1)) else  '.' : (travTxt4d time1 height1 row1 (col1 + 1)) 
                                                             | letter == '#'   -> if actCube `elem` [3,4] then '#' : (travTxt4d time1 height1 row1 (col1 + 1)) else  '.' : (travTxt4d time1 height1 row1 (col1 + 1))
                       where actCube = countCube4d time1 height1 row1 col1 arrayText  
                             letter  = arrayText ! (time1,height1,row1,col1)

process4d :: Int -> Array (Int,Int,Int,Int) Char -> ((T.Text,T.Text), [(T.Text,T.Text)])
process4d index arrayText = let newText = T.pack $ traverseText4d 1 1 1 1 arrayText 
                                (x,y,z,w) = ( (frt4 . snd $ bounds arrayText) - 1, (trd4 . snd $ bounds arrayText) - 1, (snd4 . snd $ bounds arrayText) - 1, (fst4 . snd $ bounds arrayText) - 1)
                                addW = (\list -> (list !! 1) : ( list ++ [padDots (x*y*z) , padDots (x*y*z)] ))
                                addZ = (\list -> (list !! 1) : ( list ++ [padDots (x*y) , padDots (x*y)] )) 
                                addY = (\list -> (padDots (2*x)) : (intersperse (padDots (4*x)) list) ++ [padDots (2*x)])
                                addX = (\list -> fmap (\txt -> T.center (x + 4) '.' txt) . concat . fmap (T.chunksOf x) $ list) 
                                pad3d = T.intercalate (T.pack "") . addX . addY . addZ . T.chunksOf (x*y)
                                string = T.unpack . T.intercalate (T.pack "") . fmap (pad3d) . addW . T.chunksOf (x*y*z) $ newText
                                newArray = listArray ((0,0,0,0),(w+2,z+2,y+3,x+3)) string
                            in if index == 6 then let tupl = T.splitAt (x*y*z) newText 
                                                  in (T.splitAt (x*y) . fst $ tupl, fmap (T.splitAt (x*y)) . T.chunksOf (x*y*z) . snd $ tupl)
                                             else process4d (index + 1) newArray






