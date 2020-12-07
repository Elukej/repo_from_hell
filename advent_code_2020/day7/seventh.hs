import Control.Monad
import Data.List

filterBlank "" = []
filterBlank string = dropWhile (== ' ') string

delim2 _ [] = []
delim2 charSet string = filter (/= "") $ [takeWhile (\x -> not (x `elem` charSet)) string] ++ 
                        delim2 charSet ((filterBlank . drop 1) $ (dropWhile (\x -> not (x `elem` charSet)) string))

{- mislio sam da ce mi trebati ali ne. Ostavljam je radi eventualnog kopiranja kasnijih dana
replace _ _ "" = ""
replace c1 word (x:string) 
                       | x == c1    = word ++ replace c1 c2 string
                       | otherwise  = x:replace c1 c2 string
-}
--uzima ostatak stringa posle zadatog stringa
afterWord _ [] = []
afterWord word (x:string)
                       | take (length word) (x:string) == word  = drop (length word) string
                       | otherwise                              = afterWord word string 

beforeWord _ [] = []
beforeWord word (x:string)
                       | take (length word) (x:string) == word  = []
                       | otherwise                              = x:beforeWord word string 

foundMatch _ "" = False
foundMatch word (x:string)
                       | take (length word) (x:string) == word   = True
                       | length string < length word             = False
                       | otherwise                               = foundMatch word string

outerBags _ [] = [""]
outerBags bag fileString = fmap (beforeWord " bags") $ filter (foundMatch bag . afterWord "contain") fileString

stackList acc [] _  = acc
stackList acc (color:list) fileString = stackList (acc ++ (outerBags color fileString)) 
                                                  (list ++ (filter (\x -> not $ x `elem` acc) $ outerBags color fileString))
                                                  fileString 



findBag _ [] = []
findBag [] _ = []
findBag bag (x:fileString)
                         | beforeWord " bags" x == bag  = x
                         | otherwise                    = findBag bag fileString

stackListMod "no other bags" _ = 0
stackListMod color fileString  
                              | colorList == ["no other bags"]   = 0
                              | otherwise                        = foldl (+) 0 $ (\x -> (nrBags x) + (nrBags x) * (stackListMod (newColor x) fileString)) <$> colorList 
                                    where colorList = delim2 ",." . afterWord "contain" . findBag color $ fileString 
                                          newColor str = filterBlank . drop 1 . beforeWord " bag" $ str
                                          nrBags str = read $ take 1 str :: Int


main = do
       fs <- readFile "input_day7.txt"
       let fileAsList = delim2 "\n" fs
       return ()
       print $ length . nub $ stackList [] ["shiny gold"] fileAsList 
       print $ stackListMod "shiny gold" fileAsList


