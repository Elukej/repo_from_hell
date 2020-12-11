import Data.Array
import qualified Data.Text as T
import qualified Data.Text.IO as IOT
import Data.List 

countSeat3x3 :: Int -> Int -> Array (Int,Int) Char -> Int
countSeat3x3 row col arrayText = length . filter (== '#') $ (arrayText ! (row-1,col-1)) : (arrayText ! (row-1,col)) : 
                                                            (arrayText ! (row-1,col+1)) : (arrayText ! (row,col-1)) :
                                                            (arrayText ! (row,col)) : (arrayText ! (row,col+1)) : 
                                                            (arrayText ! (row+1,col-1)) : (arrayText ! (row+1,col)) :
                                                            (arrayText ! (row+1,col+1)) : []

countSeatDir :: Int -> Int -> Array (Int,Int) Char -> Int
countSeatDir row column arrayText = length . filter (== '#') $ (findSeat "TL" (row - 1) (column - 1)) :
                                                      (findSeat "T" (row - 1) column) :
                                                      (findSeat "TR" (row - 1) (column + 1)) :
                                                      (findSeat "L" row (column - 1)) :
                                                      (findSeat "R" row (column + 1)) :
                                                      (findSeat "BL" (row + 1) (column - 1)) :
                                                      (findSeat "B" (row + 1) column) :
                                                      (findSeat "BR" (row + 1) (column + 1)) : []
     where findSeat dir row1 col1 
                   | row1 == 0 || row1 == (fst . snd $ bounds arrayText) ||  col1 == 0 || col1 == (snd . snd $ bounds arrayText) = '.'
                   | letter == 'L' || letter == '#'  = letter
                   | dir == "TL"  = findSeat "TL" (row1 - 1) (col1 - 1)                                                 
                   | dir == "T"   = findSeat "T" (row1 - 1) col1                                                  
                   | dir == "TR"  = findSeat "TR" (row1 - 1) (col1 + 1)
                   | dir == "L"   = findSeat "L" row1 (col1 - 1)
                   | dir == "R"   = findSeat "R" row1 (col1 + 1)
                   | dir == "BL"  = findSeat "BL" (row1 + 1) (col1 - 1)
                   | dir == "B"   = findSeat "B" (row1 + 1) col1
                   | dir == "BR"  = findSeat "BR" (row1 + 1) (col1 + 1)
                         where letter = arrayText ! (row1,col1)

traverseText :: Int -> Int -> Int -> Array (Int,Int) Char -> String
traverseText ind row column arrayText = travTxt row column
     where travTxt row1 col1 =  case () of _
                                             | row1 == ((fst . snd $ bounds arrayText) + 1)        -> []
                                             | col1 == ((snd . snd $ bounds arrayText) + 1) -> travTxt (row1 + 1) 0     
                                             | letter == '.'   -> '.' : (travTxt row1 (col1 + 1)) 
                                             | letter == 'L'   -> if occSeat == 0 then '#' : ( travTxt row1 (col1 + 1))  else  'L' : (travTxt row1 (col1 + 1))
                                             | letter == '#'   -> if occSeat >= 5 then 'L' : (travTxt row1 (col1 + 1)) else  '#' : (travTxt row1 (col1 + 1))
                       where occSeat = if ind == 0 then countSeat3x3 row1 col1 arrayText else countSeatDir row1 col1 arrayText 
                             letter  = arrayText ! (row1,col1)

process :: Int -> Array (Int,Int) Char -> String
process ind arrayText = let newText = traverseText ind 0 0 arrayText 
                            newArrayText = listArray (bounds arrayText) newText
                        in if newArrayText == arrayText then newText else process ind newArrayText 

main = do text <- fmap (\x -> T.center (T.length x + 2) '.' x) <$> T.lines . T.strip . T.replace (T.singleton 'L') (T.singleton '#') <$> IOT.readFile "input_day11.txt"
          let dots      = T.replicate (T.length $ head text) (T.singleton '.')
              paddText  = (dots:text) ++ [dots] 
              arrayText = listArray ((0,0),(length paddText - 1, T.length (head paddText) - 1)) $ T.unpack $ T.intercalate (T.pack "") paddText
          print $ length . filter (== '#') . process 0 $ arrayText
          print $ length . filter (== '#') . process 1 $ arrayText






