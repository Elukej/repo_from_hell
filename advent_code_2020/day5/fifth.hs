import Text.Regex
import qualified Text.Regex.Posix as TRP

checkString "" = Nothing
checkString string
           | (TRP.matchAll (mkRegex "^([FB]{7})+([LR]{3})$") string) /= []  = Just True 
           | otherwise                                                      = Just False

getSeat acc string = foldl (processSeat) acc string  
                       where  processSeat acc c  
                                   | c `elem` "BR"  = (fst acc + (snd acc - fst acc) `div` 2 + 1, snd acc)
                                   | c `elem` "FL"  = (fst acc, fst acc + (snd acc - fst acc) `div` 2)

getSeatID string = fst (getSeat (0,127) $ take 7 string) * 8 + fst (getSeat (0,7) $ drop 7 string) 


main = do
     fs <- readFile "input_day5.txt"
     let fileAsString = lines fs
         seatIDList = [getSeatID string | string <- fileAsString, checkString string == Just True]
         maxSeatID = maximum seatIDList
         allSeats = [1..maxSeatID]
         missingSeats = filter (\x -> not $ x `elem` seatIDList) allSeats
         wantedSeatID = foldl (\acc x-> if ((x-1) `elem` seatIDList && (x+1) `elem` seatIDList) then Just (x) else acc) Nothing missingSeats
     print maxSeatID
     print wantedSeatID

