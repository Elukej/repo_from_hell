----------------------------------------------------------------
-- APLIKACIJA ZA PRAVLJENJE I BRISANJE TODO LISTE ------
{-# LANGUAGE LambdaCase #-}       --Ovo je neko cudo koje se dodaje da bi ova sintaksa doesFileExist koja vraca IO Bool mogla da se stavi u kondicionalni izraz
import System.Environment
import System.Directory
import System.IO
import Data.List
import Control.Monad
import System.IO.Error

dispatch :: [(String, [String] -> IO ())]
dispatch = [ ("add", add)
           , ("view", view)
           , ("remove", remove)
           , ("bump", bump)
           ]

main = do 
     args <- getArgs
     if (args == []) then putStrLn ("You didnt input anything!\nInput must be of format: <command> <file> [additonal arguments]")
     else do
        (command:args) <- getArgs
        if ((command `elem` ["add","view","remove","bump"]) == False) then putStrLn ("You inputted non existent command!")
        else do
           let (Just action) = lookup command dispatch  -- lookup trazi prvu instancu kljuca koji mu je argument u listi tuplova ili mapi
           if ((command /= "view") && (length args < 2) || args == []) then putStrLn ("Not enough arguments!")
           else do
              if ((command == "view") && (length args /= 1) || length args > 2) then putStrLn ("Too many arguments!")
              else action args


add :: [String] -> IO ()
add [fileName, todoItem] = do
            doesFileExist fileName >>= \case 
                          True -> 
                              if (not $ null todoItem) then appendFile fileName (todoItem ++ "\n")
                              else putStrLn("You didnt input the string to be added to the file!")
                          False -> putStrLn ("You inputted a file that doesn't exist!")

view :: [String] -> IO ()
view [fileName] = do
       doesFileExist fileName >>= \case 
                    True -> do
                        contents <- readFile fileName
                        let todoTasks = lines contents
                            numberedTasks = zipWith (\n line -> show n ++ " - " ++ line) [0..] todoTasks
                        putStr $ unlines numberedTasks
                    False -> putStrLn ("You inputted a file that doesn't exist!")

remove :: [String] -> IO ()
remove [fileName, numberString] = do
      doesFileExist fileName >>= \case
        True -> do 
            handle <- openFile fileName ReadMode
            (tempName, tempHandle) <- openTempFile "." "temp"        -- "." je putanja do trenutnog direktorijuma, a temp je ime koje mu dajemo
            contents <- hGetContents handle
            let number = read numberString
                todoTasks = lines contents
                newTodoItems  
                           | number < length todoTasks && number > 0 = delete (todoTasks !! number) todoTasks
                           | otherwise                 = todoTasks
            if (newTodoItems == todoTasks) then putStrLn "You inputted bad index! Check valid indexes with view!"
            else return ()
            hPutStr tempHandle $ unlines newTodoItems
            hClose handle 
            hClose tempHandle
            removeFile fileName
            renameFile tempName fileName
        False -> putStrLn ("You inputted a file that doesn't exist!")

-- openTempFile je funkcija koja radi sa temporary fajlovima u cilju smanjenja rizika od ostecenja fajlova
-- removeFile i renameFile brisu i preimenuju fajl respektivno.

bump :: [String] -> IO ()
bump [fileName, lineNumber] = do
       doesFileExist fileName >>= \case
            True -> do
               handle <- openFile fileName ReadMode
               (tempName, tempHandle) <- openTempFile "." "temp"
               contents <- hGetContents handle
               let number = read lineNumber
                   todoTasks = lines contents
                   newTodoTasks 
                             | number < length todoTasks && number > 0 = (todoTasks !! number) : (delete (todoTasks !! number) todoTasks) 
                             | otherwise                               = todoTasks
               if (newTodoTasks == todoTasks) then putStrLn "You inputted bad index! Check valid indexes with view!"
               else return ()
               hPutStr tempHandle $ unlines newTodoTasks
               hClose handle
               hClose tempHandle
               removeFile fileName
               renameFile tempName fileName
            False -> putStrLn ("You inputted a file that doesn't exist!")






