import Control.Monad
import Data.List

filterBlank :: String -> String
filterBlank "" = []
filterBlank string = dropWhile (== ' ') string

delim2 :: String -> String -> [String]
delim2 _ [] = []
delim2 charSet string = filter (/= "") $ [takeWhile (\x -> not (x `elem` charSet)) string] ++ 
                        delim2 charSet ((filterBlank . drop 1) $ (dropWhile (\x -> not (x `elem` charSet)) string))

afterWord :: String -> String -> String
afterWord _ [] = []
afterWord word (x:string)
                       | take (length word) (x:string) == word  = drop (length word) string
                       | otherwise                              = afterWord word string 

beforeWord :: String -> String -> String
beforeWord _ [] = []
beforeWord word (x:string)
                       | take (length word) (x:string) == word  = []
                       | otherwise                              = x:beforeWord word string 

foundMatch :: String -> String -> Bool
foundMatch _ "" = False
foundMatch word (x:string)
                       | take (length word) (x:string) == word   = True
                       | length string < length word             = False
                       | otherwise                               = foundMatch word string

outerBags :: String -> [String] -> [String]
outerBags _ [] = [""]
outerBags bag fileString = fmap (beforeWord " bags") $ filter (foundMatch bag . afterWord "contain") fileString

stackList ::  [String] -> [String] -> [String] -> [String]
stackList acc [] _  = []
stackList acc (color:list) fileString = bagsOut ++ (stackList (bagsOut ++ acc) ((bagsOut \\ acc) ++ list) fileString) 
                                          where bagsOut = outerBags color fileString

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
       print $ length . nub $ stackList [""] ["shiny gold"] fileAsList
       print $ stackListMod "shiny gold" fileAsList


