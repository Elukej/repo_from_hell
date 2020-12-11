import qualified Data.Text as T
import qualified Data.Text.IO as IOT
      
countSeat3x3 :: T.Text -> Int -> Int -> [T.Text] -> Int
countSeat3x3 c row col list = T.count c $ take3FromInd (row - 1) (col - 1) `T.append` 
                                          take3FromInd row       (col - 1) `T.append`
                                          take3FromInd (row + 1) (col - 1)
                        where take3FromInd row1 col1 = T.take 3 . T.drop col1 $ list !! row1 
    
countSeatDir :: Int -> Int -> [T.Text] -> Int
countSeatDir row column text = T.count (T.pack "#") $ (findSeat "TL" (row - 1) (column - 1)) `T.append`
                                                      (findSeat "T" (row - 1) column) `T.append`
                                                      (findSeat "TR" (row - 1) (column + 1)) `T.append`
                                                      (findSeat "L" row (column - 1)) `T.append`
                                                      (findSeat "R" row (column + 1)) `T.append`
                                                      (findSeat "BL" (row + 1) (column - 1)) `T.append`
                                                      (findSeat "B" (row + 1) column) `T.append`
                                                      (findSeat "BR" (row + 1) (column + 1)) 
     where findSeat dir row1 col1 
                   | row1 == 0 || row1 == (length text - 1) ||  col1 == 0 || col1 == ((T.length $ head text) - 1) = T.singleton '.'
                   | dir == "TL"  = case letter of  '.' -> findSeat "TL" (row1 - 1) (col1 - 1)
                                                    'L' -> T.singleton 'L'
                                                    '#' -> T.singleton '#'
                   | dir == "T"   = case letter of  '.' -> findSeat "T" (row1 - 1) col1
                                                    'L' -> T.singleton 'L'
                                                    '#' -> T.singleton '#'
                   | dir == "TR"  = case letter of  '.' -> findSeat "TR" (row1 - 1) (col1 + 1)
                                                    'L' -> T.singleton 'L'
                                                    '#' -> T.singleton '#'
                   | dir == "L"   = case letter of  '.' -> findSeat "L" row1 (col1 - 1)
                                                    'L' -> T.singleton 'L'
                                                    '#' -> T.singleton '#'
                   | dir == "R"   = case letter of  '.' -> findSeat "R" row1 (col1 + 1)
                                                    'L' -> T.singleton 'L'
                                                    '#' -> T.singleton '#'
                   | dir == "BL"  = case letter of  '.' -> findSeat "BL" (row1 + 1) (col1 - 1)
                                                    'L' -> T.singleton 'L'
                                                    '#' -> T.singleton '#'
                   | dir == "B"   = case letter of  '.' -> findSeat "B" (row1 + 1) col1
                                                    'L' -> T.singleton 'L'
                                                    '#' -> T.singleton '#'
                   | dir == "BR"  = case letter of  '.' -> findSeat "BR" (row1 + 1) (col1 + 1)
                                                    'L' -> T.singleton 'L'
                                                    '#' -> T.singleton '#'
                         where letter = T.head . T.drop col1 $ text !! row1


traverseText :: Int -> Int -> Int -> [T.Text] -> [T.Text]
traverseText ind row column text = travTxt row column
     where travTxt row1 col1 =  case () of _
                                             | row1 == (length text)        -> []
                                             | col1 == (T.length $ head text) -> [T.pack ""] ++ travTxt (row1 + 1) 0     
                                             | letter == '.'                -> ['.' `T.cons` (head $ travTxt row1 (col1 + 1))] ++ (drop 1 $ travTxt row1 (col1 + 1))
                                             | letter == 'L'                -> if occSeat == 0 then ['#' `T.cons` (head $ travTxt row1 (col1 + 1))] ++ (drop 1 $ travTxt row1 (col1 + 1)) else  ['L' `T.cons` (head $ travTxt row1 (col1 + 1))] ++ (drop 1 $ travTxt row1 (col1 + 1))
                                             | letter == '#'                -> if occSeat >= 5 then ['L' `T.cons` (head $ travTxt row1 (col1 + 1))] ++ (drop 1 $ travTxt row1 (col1 + 1)) else  ['#' `T.cons` (head $ travTxt row1 (col1 + 1))] ++ (drop 1 $ travTxt row1 (col1 + 1))
                       where occSeat = if ind == 0 then countSeat3x3 (T.pack "#") row1 col1 text else countSeatDir row1 col1 text
                             letter  = T.head . T.drop col1 $ text !! row1


process :: Int -> [T.Text] -> [T.Text]
process ind text = let newText = traverseText ind 0 0 text 
                   in if newText == text then text else process ind newText 

main = do text <- fmap (\x -> T.center (T.length x + 2) '.' x) <$> T.lines . T.strip . T.replace (T.singleton 'L') (T.singleton '#') <$> IOT.readFile "input_day11.txt"
          let dots     = T.replicate (T.length $ head text) (T.singleton '.')
              paddText = (dots:text) ++ [dots] 
          print $ T.count (T.pack "#") . T.intercalate (T.pack "") $ process 0 paddText
          print $ T.count (T.pack "#") . T.intercalate (T.pack "") $ process 1 paddText
   

