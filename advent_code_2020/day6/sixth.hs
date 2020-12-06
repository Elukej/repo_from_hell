import Data.List

delim2 _ [] = []
delim2 charSet string = filter (/= "") $ [takeWhile (\x -> not (x `elem` charSet)) string] ++ 
                        delim2 charSet (drop 1 (dropWhile (\x -> not (x `elem` charSet)) string))

blankLineDelim  "" = [""]
blankLineDelim string 
                    | (take 1 . filterBlank . drop 1 . rest $ string) == "\n"  = 
                               linija string : (blankLineDelim . drop 1 . filterBlank . drop 1 . rest $ string)
                    | take 1 string == "\n"                                  = 
                              ("\n" ++ (head . blankLineDelim . drop 1 $ string)) : (drop 1 . blankLineDelim . drop 1 $ string)
                    | otherwise                                              = 
                               (linija string ++ (head . blankLineDelim . rest $ string)) : (drop 1 . blankLineDelim . rest $ string)
                          where filterBlank str = dropWhile (== ' ') str 
                                linija str = takeWhile (/= '\n') str
                                rest str = dropWhile (/= '\n') str
minLengthString [""] = ""
minLengthString lista = foldl (\acc x -> if (length x < length acc || acc == "") then x else acc) "" lista 

answerAll "" _ = 0
answerAll (x:xs) lsStr = fromEnum (all (\y -> x `elem` y ) lsStr) + (answerAll xs lsStr)

main = do
     fs <- readFile "input_day6.txt"
     let fileAsList = fmap (delim2 " \n") $ blankLineDelim fs
         summary = foldl (\acc x -> acc + (length . nub . concat $ x)) 0 fileAsList      
         summaryMod = foldl (\acc x -> acc + (answerAll (minLengthString x) x)) 0 fileAsList
     print summary
     print summaryMod


