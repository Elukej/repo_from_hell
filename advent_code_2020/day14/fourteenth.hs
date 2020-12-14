import Data.Char (digitToInt,intToDigit)
import Numeric (readInt,showIntAtBase)
import qualified Data.Text as T
import qualified Data.Text.IO as IOT
import Data.Bits ((.&.),(.|.),complement)
import Text.Regex.Posix
import Data.List 
import qualified Data.HashMap.Strict as HashMap

main = do file <- fmap (T.unpack) . filter (/= T.pack "") . T.split (== '\n') <$> IOT.readFile "input_day14.txt"       
          print $ foldl (\acc (x,y) -> acc + y) 0 . nubBy (\x y -> fst x == fst y) . reverse . parser (0,0) $ file
          print $ foldl (\acc (x,y) -> acc + y) 0 . HashMap.toList . parser2 ([], 0) $ file

------------------- helper functions ------------------------------------

readBin :: String -> Int
readBin x = fst . head . readInt 2 (`elem` "01") digitToInt $ x

afterWord :: String -> String -> String
afterWord _ [] = []
afterWord word (x:string)
                       | take (length word) (x:string) == word  = drop (length word) (x:string)
                       | otherwise                              = afterWord word string 

beforeWord :: String -> String -> String
beforeWord _ [] = []
beforeWord word (x:string)
                       | take (length word) (x:string) == word  = []
                       | otherwise                              = x:beforeWord word string 

replace :: Char -> Char -> String -> String 
replace _ _ [] = []
replace c1 c2 (x:word) | x == c1   = c2 : replace c1 c2 word
                       | otherwise = x : replace c1 c2 word

insteadX :: String -> String -> String
insteadX string [] = string
insteadX (x:string) (y:repl) | x == 'X'  = y : insteadX string repl
                             | otherwise = x : insteadX string (y:repl)

padd0 :: Int -> String -> String
padd0 nr string = (take (nr - length string) . repeat $ '0') ++ string

----------------- workload part ------------------------------------------ 

parser :: (Int,Int) -> [String] -> [(Int,Int)]
parser _ [] = []
parser acc (str:file) | str =~ "mask" = parser newAcc file
                      | otherwise     = maskedStore : (parser acc file)
                         where newAcc      = (mask0, mask1 - mask0)
                               mask0       = readBin . replace 'X' '0' . afterWord "= " $ str
                               mask1       = readBin . replace 'X' '1' . afterWord "= " $ str
                               store       = (read . afterWord "[" . beforeWord "]" $ str :: Int, read . afterWord "= " $ str :: Int)
                               maskedStore = (fst store, fst acc + ((snd store) .&. (snd acc)))


parser2 :: ([Int],Int) -> [String] -> (HashMap.HashMap Int Int)
parser2 _ [] =  HashMap.fromList []
parser2 acc (str:file) | str =~ "mask" = parser2 newAcc file
                       | otherwise     = (parser2 acc file) `HashMap.union` (HashMap.fromList maskedAddr) 
              where newAcc  = ((readBin . insteadX medAcc . padd0 countX . flip (showIntAtBase 2 (intToDigit)) "") <$> [0.. (2 ^countX) - 1], complement (mask1 - mask0))
                    medAcc      = afterWord "= " str
                    countX      = length . filter (== 'X') $ medAcc
                    mask0       = readBin . replace 'X' '0' $ medAcc
                    mask1       = readBin . replace 'X' '1' $ medAcc
                    maskedAddr  = (\x -> (mem .|. x, dat)) <$> (fst acc)
                    mem         = (read .  beforeWord "]" . afterWord "[" $ str :: Int) .&. (snd acc)
                    dat         = read . afterWord "= " $ str :: Int

               







