import Text.Regex
import qualified Text.Regex.Posix as TRP

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


quickSort :: (Ord a) => [a] -> [a]
quickSort [] = []
quickSort (x:xs) = quickSort (xl) ++ [x] ++ quickSort (xr)
                   where xl = [ y | y <- xs, y <= x]
                         xr = [ y | y <- xs, y > x]

byr x 
      | (TRP.matchAll (mkRegex "^byr:([0-9]{4})$") x) /= []  =  (last $ delim2 ":" x) `elem` (fmap show [1920..2002])
      | otherwise                                            = False

iyr x 
      | (TRP.matchAll (mkRegex "^iyr:([0-9]{4})$") x) /= []  =  (last $ delim2 ":" x) `elem` (fmap show [2010..2020])
      | otherwise                                            = False

eyr x 
      | (TRP.matchAll (mkRegex "^eyr:([0-9]{4})$") x) /= []  =  (last $ delim2 ":" x) `elem` (fmap show [2020..2030])
      | otherwise                                            = False

hgt x 
     | (TRP.matchAll (mkRegex "^hgt:([0-9]{3})cm$") x) /= []   = (take 3 . drop 4 $ x) `elem` (fmap show [150..193])
     | (TRP.matchAll (mkRegex "^hgt:([0-9]{2})in$") x) /= []   = (take 2 . drop 4 $ x) `elem` (fmap show [59..76])
     | otherwise                                               = False

hcl :: [Char] -> Bool
hcl x
     | (TRP.matchAll (mkRegex "^hcl:#([0-9A-Fa-f]{6})$") x) /= []   =  True
     | otherwise                                                    =  False

ecl x 
     | (TRP.matchAll (mkRegex "^ecl:([a-z]{3})$") x)  /= [] = (drop 4 x) `elem` ["amb","blu","brn","gry","grn","hzl","oth"]
     | otherwise                                             = False

pid :: [Char] -> Bool
pid x 
     | (TRP.matchAll (mkRegex "^pid:([0-9]{9})$") x) /= []   = True
     | otherwise                                             = False

cid :: [Char] -> Bool
cid x 
     | (TRP.matchAll (mkRegex "^cid") x) /= []   = False
     | otherwise                                 = True

main = do
      fs <- readFile "input_day4.txt"
      let fileAsList = fmap (filter (cid) . quickSort . delim2 " \n") $ blankLineDelim fs
          fList = [byr, ecl, eyr, hcl, hgt, iyr, pid] 
          checkPassport p = if length p == 7 then (all (id) $ zipWith (id) fList p) else False
          countValid lista = foldl (\acc x -> if checkPassport x then (acc + 1) else acc) 0 fileAsList          
      print $ countValid fileAsList 
          






