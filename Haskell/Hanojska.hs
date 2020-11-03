import Control.Concurrent (threadDelay)
import Control.Monad



ispis n a b c = [[x | x <- a, x /= n]] ++ [[y | y <- b, y /= n]] ++ [[z | z <- c, z /= n]]


hanoj :: (Eq a, Num a, Num b, Ord b) => a -> a -> [b] -> [b] -> [b] -> [[b]]

hanoj n k [0] [0] list = []
hanoj n k (x:xs) (y:ys) (z:zs)
                   | k /= 1 && x /= 0 && (x < y || y == 0)     =  ispis (0) xs (x:y:ys) (z:zs) ++ hanoj n 2  xs (x:y:ys) (z:zs)

                   | k /= 1 && x /= 0 && (x < z || z == 0)     =  ispis (0) xs (y:ys) (x:z:zs) ++ hanoj n 3 xs (y:ys) (x:z:zs)
                  
                   | k /= 2 && y /= 0 && (y < z || z == 0)     =  ispis (0) (x:xs) ys (y:z:zs) ++ hanoj n 3 (x:xs) ys (y:z:zs)
                   
                   | k /= 2 && y /= 0 && (y < x || x == 0)     =  ispis (0) (y:x:xs) ys (z:zs) ++ hanoj n 1 (y:x:xs) ys (z:zs) 
                 
                   | k /= 3 && z /= 0 && (z < x || x == 0)     =  ispis (0) (z:x:xs) (y:ys) zs ++ hanoj n 1 (z:x:xs) (y:ys) zs
         
                   | k /= 3 && z /= 0 && (z < y || y == 0)     =  ispis (0) (x:xs) (z:y:ys) zs ++ hanoj n 2 (x:xs) (z:y:ys) zs

                   | otherwise                                 =  if (x == 0 && z == 0) then hanoj n 0 [0] (y:ys) [0] else []


main :: IO ()
main = do putStrLn ("Unesite Broj diskova na Hanojskoj kuli: ")
          input <- getLine
          let n = read input + 0
          lista <- return (hanoj n 0 ([1..n] ++ [0]) [0] [0])
          lista2 <- return ([ take 3 $ drop y lista | y <- [0,3..(length (lista) - 3)]])
          forM_ lista2 $
                \content -> do print content
                               threadDelay 2000000

