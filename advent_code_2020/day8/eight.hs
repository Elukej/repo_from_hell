import Data.List.Split
--import Language.Haskell.Interpreter

{- Jako lepa fora da Haskelov interpreter protumaci sam funkciju bez da ja parsiram, ali ne umem da raspakujem posle tu vrednost iz
monadnog konteksta u funkciji, a kako tacno funkcionisu "do" rekurzije takodje ne znam, tako da cu ostaviti kao kontemplativnu temu za dalje

getF :: String -> IO (Either InterpreterError (Int -> Int))
getF xs = runInterpreter $ do
   setImports ["Prelude"]
   interpret xs (as :: Int -> Int)

process operator br = do (Right f) <- getF operator
                         return (f br) 
-}
opParse "" = id
opParse string = case (take 1 string) of "+" -> (+ (read $ drop 1 string :: Int))
                                         "-" -> (+ (-(read $ drop 1 string :: Int)))
changeEl _ [[""]] = [[""]]
changeEl x fileString 
                       | (take 1 $ fileString !! x) == ["nop"]  = take x fileString ++ ["jmp":(drop 1 $ fileString !! x)] ++ drop (x + 1) fileString   
                       | (take 1 $ fileString !! x) == ["jmp"]  = take x fileString ++ ["nop":(drop 1 $ fileString !! x)] ++ drop (x + 1) fileString                          
                       | otherwise = fileString

breakLoop mode index acc listIndex fileString 
                         | (any (\x -> fst x == index) listIndex) && mode == 1      = breakManager listIndex fileString
                         | (fileString !! index == [""]) || (any (\x -> fst x == index) listIndex)   = (index, acc)
                         | (take 1 $ fileString !! index) == ["acc"]  = breakLoop mode (index + 1) newAcc ((index, acc):listIndex) fileString
                         | (take 1 $ fileString !! index) == ["jmp"]  = breakLoop mode newIndex acc ((index, acc):listIndex) fileString
                         | otherwise                                  = breakLoop mode (index + 1) acc ((index, acc):listIndex) fileString
                                           where newAcc = opParse (concat . drop 1  $ fileString !! index) $ acc
                                                 newIndex = opParse (concat . drop 1 $ fileString !! index) $ index
breakManager [] fileString = (0,0)
breakManager (x:listIndex) fileString 
                         | (fst $ breakLoop 0 (fst x) (snd x) [] newFileString) == (length fileString - 1) = (fst x, snd $ breakLoop 0 (fst x) (snd x) [] newFileString)
                         | otherwise                                                         = breakManager listIndex fileString
                                           where newFileString = changeEl (fst x) fileString 

main = do list <- fmap (splitOn " ") . lines <$> readFile "input_day8.txt"
          print $ breakLoop 0 0 0 [] list
          print $ breakLoop 1 0 0 [] list


