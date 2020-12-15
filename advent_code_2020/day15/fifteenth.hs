import qualified Data.HashMap.Strict as HashMap

main = do print $ fst . elfGame 2019 $ (15, HashMap.fromList [(0,1),(20,2),(7,3),(16,4),(1,5),(18,6)])
          print $ fst . elfGame 29999999 $ (15, HashMap.fromList [(0,1),(20,2),(7,3),(16,4),(1,5),(18,6)])

elfGame :: Int -> (Int, (HashMap.HashMap Int Int)) -> (Int, (HashMap.HashMap Int Int))
elfGame n mappPair = elfGame' (n - (HashMap.size $ snd mappPair)) mappPair
          where elfGame' 0 mappPair1 = mappPair1
                elfGame' n1 (cmp1, mapp1) | not (HashMap.member cmp1 mapp1)  = elfGame' (n1-1) (0 ,HashMap.insert cmp1 (n-n1 +1) mapp1)
                                          | otherwise      = elfGame' (n1-1) ( ((n-n1 +1) - val), HashMap.insert cmp1 (n-n1+1) mapp1)
                     where Just val = (HashMap.lookup cmp1 mapp1)


 
















