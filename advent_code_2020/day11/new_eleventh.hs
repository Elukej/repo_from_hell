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
                   | dir == "TL"  = case letter of  '.' -> findSeat "TL" (row1 - 1) (col1 - 1)
                                                    'L' -> 'L'
                                                    '#' -> '#'
                   | dir == "T"   = case letter of  '.' -> findSeat "T" (row1 - 1) col1
                                                    'L' -> 'L'
                                                    '#' -> '#'
                   | dir == "TR"  = case letter of  '.' -> findSeat "TR" (row1 - 1) (col1 + 1)
                                                    'L' -> 'L'
                                                    '#' -> '#'
                   | dir == "L"   = case letter of  '.' -> findSeat "L" row1 (col1 - 1)
                                                    'L' -> 'L'
                                                    '#' -> '#'
                   | dir == "R"   = case letter of  '.' -> findSeat "R" row1 (col1 + 1)
                                                    'L' -> 'L'
                                                    '#' -> '#'
                   | dir == "BL"  = case letter of  '.' -> findSeat "BL" (row1 + 1) (col1 - 1)
                                                    'L' -> 'L'
                                                    '#' -> '#'
                   | dir == "B"   = case letter of  '.' -> findSeat "B" (row1 + 1) col1
                                                    'L' -> 'L'
                                                    '#' -> '#'
                   | dir == "BR"  = case letter of  '.' -> findSeat "BR" (row1 + 1) (col1 + 1)
                                                    'L' -> 'L'
                                                    '#' -> '#'
                         where letter = arrayText ! (row1,col1)





traverseText :: Int -> Int -> Int -> Array (Int,Int) Char -> [String]
traverseText ind row column arrayText = travTxt row column
     where travTxt row1 col1 =  case () of _
                                             | row1 == ((fst . snd $ bounds arrayText) + 1)        -> []
                                             | col1 == ((snd . snd $ bounds arrayText) + 1) -> "" : travTxt (row1 + 1) 0     
                                             | letter == '.'                -> ('.' : (head $ travTxt row1 (col1 + 1))) : (drop 1 $ travTxt row1 (col1 + 1))
                                             | letter == 'L'                -> if occSeat == 0 then ('#' : (head $ travTxt row1 (col1 + 1))) : (drop 1 $ travTxt row1 (col1 + 1)) else  ('L' : (head $ travTxt row1 (col1 + 1))) : (drop 1 $ travTxt row1 (col1 + 1))
                                             | letter == '#'                -> if occSeat >= 5 then ('L' : (head $ travTxt row1 (col1 + 1))) : (drop 1 $ travTxt row1 (col1 + 1)) else  ('#' : (head $ travTxt row1 (col1 + 1))) : (drop 1 $ travTxt row1 (col1 + 1))
                       where occSeat = if ind == 0 then countSeat3x3 row1 col1 arrayText else countSeatDir row1 col1 arrayText 
                             letter  = arrayText ! (row1,col1)


process :: Int -> Array (Int,Int) Char -> [String]
process ind arrayText = let newText = traverseText ind 0 0 arrayText 
                            newArrayText = listArray (bounds arrayText) $ intercalate "" newText
                        in if newArrayText == arrayText then newText else process ind newArrayText 



main = do text <- fmap (\x -> T.center (T.length x + 2) '.' x) <$> T.lines . T.strip . T.replace (T.singleton 'L') (T.singleton '#') <$> IOT.readFile "input_day11.txt"
          let dots     = T.replicate (T.length $ head text) (T.singleton '.')
              paddText = (dots:text) ++ [dots] 
              arrayText = listArray ((0,0),(length paddText - 1, T.length (head paddText) - 1)) $ T.unpack $ T.intercalate (T.pack "") paddText
          print $ length . filter (== '#') . intercalate "" $ process 0 arrayText
          print $ length . filter (== '#') . intercalate "" $ process 1 arrayText






