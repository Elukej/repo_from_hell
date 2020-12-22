import Data.List
import qualified Data.Text as T
import qualified Data.Text.IO as IOT
import qualified Data.HashMap.Strict as HM
import Data.Array

main = do file <-  fmap ( (\(x,y) -> (read . T.unpack . T.takeWhileEnd (/= ' ') $ x :: Int, lines . T.unpack . T.drop 2 $ y )) . T.span (/= ':') ) . T.splitOn (T.pack "\n\n") <$> IOT.readFile "input_day20.txt"
          let newFile = (\(x,y) -> (x, [head y, last . transpose $ y, last y, head . transpose $ y]) ) <$> file
              hmap = HM.fromList file
              tlEdge = mkTLCorner (findEdges [1] newFile) $ head . findEdges [2] $ newFile
              unordPic =  mkAllPicChains 12 newFile 
              ordPic = foldr (\x acc -> merge (prepChain x) $ mkMat acc) (prepChain $ last unordPic) (init unordPic)
              cropPic = mkMat $ fmap (\(x,y) -> (x,fmap (drop 1 . init) . drop 1 . init $ y) ) . bordToPic hmap $ ordPic
              assPic = concat $ fmap (\z -> foldl' (\acc (x,y) -> zipWith (++) acc y) (snd . head $ z) (drop 1 z)) cropPic
              monstString = "                  # #    ##    ##    ### #  #  #  #  #  #   "
              monstArr = listArray ((0,0),(2,19)) monstString
              (numMonst,finalPicture) = findOrient monstArr assPic
          print $ foldl' (\acc x -> (fst x) * acc) 1 . findEdges [2] $ newFile --part1
          print numMonst
          print $ (length . filter (== '#') . concat $ finalPicture) - numMonst * (length . filter (== '#') $ monstString) -- part2

nrEdge :: [(Int,[String])] -> [String] -> [Maybe Int]
nrEdge list str = nrEdge' list str 
            where nrEdge' _ [] = []
                  nrEdge' [] (y:str1) = (findIndex (== y) str):(nrEdge' list str1) 
                  nrEdge' ((x1,x2):list1) (y:str1) | (y `elem` x2) || ((reverse y) `elem` x2) = nrEdge' list str1 
                                                   | otherwise                                = nrEdge' list1 (y:str1)

findEdges :: [Int] -> [(Int,[String])] -> [(Int,[String])]
findEdges nums list = findEdges' list
         where findEdges' [] = []
               findEdges' ((x1,x2):list1) = if (length . nrEdge (delete (x1,x2) list) $ x2) `elem` nums then (x1,x2):(findEdges' list1) else findEdges' list1 



-- u radu sa granicama, reverse je ekvivalentan transpose
flipV bord  = [reverse (bord !! 0), bord !! 3, reverse (bord !! 2), bord !! 1] 
flipH bord  = [bord !! 2, reverse (bord !! 1), bord !! 0, reverse (bord !! 3)]
rot90  = reverse . flipV
rot180 = flipH . flipV
rot270 = reverse . flipH

findShrEdge :: (Int,[String]) -> [(Int,[String])] -> [(Int,[String])]
findShrEdge _ [] = []
findShrEdge (x1,p1) ((x2,p2):list) = if (length edges) < 4 then (x2,p2):(findShrEdge (x1,p1) list) else findShrEdge (x1,p1) list
                   where edges = nrEdge [(x2,p2)] p1

shrBord :: (Int,[String]) -> (Int,[String]) -> Bool
shrBord (x1,p1) (x2,p2) = ((p1 !! 0) == (p2 !! 2)) || ((p1 !! 1) == (p2 !! 3)) || ((p1 !! 2) == (p2 !! 0)) || ((p1 !! 3) == (p2 !! 1))

transf :: (Int,[String]) -> (Int,[String]) -> ([String] -> [String])
transf (x1,p1) (x2,p2) | shrBord (x1,p1) (x2,p2) = (id)
                       | shrBord (x1,p1) (x2,rot90 p2) = (rot90)
                       | shrBord (x1,p1) (x2,rot180 p2) = (rot180)
                       | shrBord (x1,p1) (x2,rot270 p2) = (rot270)
                       | shrBord (x1,p1) (x2,flipV p2) = (flipV)
                       | shrBord (x1,p1) (x2,rot90 . flipV $ p2) = (rot90 . flipV)
                       | shrBord (x1,p1) (x2,rot180 . flipV $ p2) = (rot180 . flipV)
                       | shrBord (x1,p1) (x2,rot270 . flipV $ p2) = (rot270 . flipV)


-- list ovde ce biti spoljni okvir slike, ne mora cela posto spoljni okvir daje sve potrebne granice (znaci findEdges [1,2] vraca spoljni)
mkTLCorner :: [(Int,[String])] -> (Int,[String]) -> (Int,[String])
mkTLCorner list (x1,p1) | (Just 0) `elem` edgeInd && (Just 1) `elem` edgeInd = (x1,rot90 p1)
                        | (Just 1) `elem` edgeInd && (Just 2) `elem` edgeInd = (x1,rot180 p1)
                        | (Just 2) `elem` edgeInd && (Just 3) `elem` edgeInd = (x1,rot270 p1)
                        | (Just 3) `elem` edgeInd && (Just 0) `elem` edgeInd = (x1,p1)
           where edgeInd = nrEdge list p1


--beg je ovde podrazumevano napravljen u gornji levi cosak ako je ind = 1, tj ako je tek usao u funkciju
mkChain ind beg list = mkChain' ind beg $ filter (\(x,y) -> x /= (fst beg)) $ findEdges [1,2] list
           where mkChain' _ _ [] = []
                 mkChain' 1 beg1 list1 | (Just 0) `elem` edgeInd1 = (fst beg1, (id) . snd $ beg1) : (neigh1, f1 str1) : ( mkChain' 0 (neigh1, f1 str1) $ delete (neigh1,str1) list1 )
                                       | (Just 0) `elem` edgeInd2 = (fst beg1, (id) . snd $ beg1) : (neigh2, f2 str2) : ( mkChain' 0 (neigh2, f2 str2) $ delete (neigh2,str2) list1 )
                                       | (Just 0) `elem` edgeInd3 = (fst beg1, (reverse) . snd $ beg1) : (neigh1, f3 str1) : ( mkChain' 0 (neigh1, f3 str1) $ delete (neigh1,str1) list1 )
                                       | (Just 0) `elem` edgeInd4 = (fst beg1, (reverse) . snd $ beg1) : (neigh2, f4 str2) : ( mkChain' 0 (neigh2, f4 str2) $  delete (neigh2,str2) list1 )
                             where [(neigh1,str1),(neigh2,str2)] = findShrEdge beg1 list1
                                   f1 = transf beg1 (neigh1,str1)
                                   f2 = transf beg1 (neigh2,str2)
                                   f3 = transf (fst beg1, reverse . snd $ beg1) (neigh1,str1)
                                   f4 = transf (fst beg1, reverse . snd $ beg1) (neigh2,str2)
                                   edgeInd1 = nrEdge (delete (neigh1,str1) list) . f1 $ str1
                                   edgeInd2 = nrEdge (delete (neigh2,str2) list) . f2 $ str2
                                   edgeInd3 = nrEdge (delete (neigh1,str1) list) . f3 $ str1
                                   edgeInd4 = nrEdge (delete (neigh2,str2) list) . f4 $ str2
                 mkChain' 0 beg1 list1 = (neigh, f str) : ( mkChain' 0 (neigh, f str) $ delete (neigh,str) list1 ) 
                        where [(neigh,str)] = findShrEdge beg1 list1
                              f = transf beg1 (neigh,str)

mkAllPicChains 0 _ = []
mkAllPicChains 1 pic = [pic]
mkAllPicChains dim pic = (mkChain 1 beg pic):(mkAllPicChains (dim-2) $ findEdges [0] pic) 
            where beg = if dim == 2 then mkTLCorner (tail pic) (head pic) else mkTLCorner (findEdges [1] pic) $ head . findEdges [2] $ pic




mkMat :: [(Int,[String])] -> [[(Int,[String])]] 
mkMat list = mkMat' list
           where mkMat' [] = []
                 mkMat' list1 = (take row list1):(mkMat' $ drop row list1 )
                 row = round . sqrt . fromIntegral . length $ list

mFlipV mat = fmap ( fmap (\(x,y) -> (x,flipV y)) . reverse ) mat
mFlipH mat = fmap ( fmap (\(x,y) -> (x,flipH y)) ) . reverse $ mat
mTranspose mat = fmap ( fmap (\(x,y) -> (x,reverse y)) ) . transpose $ mat
mRot90     = mTranspose . mFlipV 
mRot180    = mFlipH . mFlipV
mRot270    = mTranspose . mFlipH

--podrazumeva da je dobio matricu u inPic a ne jednostruki niz
transfChain ch1 inPic | shrBord (ch1 !! 1) (head . head $ inPic)                    = inPic
                      | shrBord (ch1 !! 1) (head . head $ mRot90 inPic)             = mRot90 inPic
                      | shrBord (ch1 !! 1) (head . head $ mRot180 inPic)            = mRot180 inPic
                      | shrBord (ch1 !! 1) (head . head $ mRot270 inPic)            = mRot270 inPic
                      | shrBord (ch1 !! 1) (head . head $ mFlipV inPic)             = mFlipV inPic
                      | shrBord (ch1 !! 1) (head . head $ mRot90 . mFlipV $ inPic)  = mRot90 . mFlipV $ inPic
                      | shrBord (ch1 !! 1) (head . head $ mRot180 . mFlipV $ inPic) = mRot180 . mFlipV $ inPic
                      | shrBord (ch1 !! 1) (head . head $ mRot270 . mFlipV $ inPic) = mRot270 . mFlipV $ inPic


prepChain ch1 | length ch1 == 1 = ch1
              | otherwise =  (take row ch1) ++ (prepChain' $ rCol ++ lCol) ++ (reverse . take row . drop (2*row - 2) $ ch1)
           where row = (round $ (fromIntegral . length $ ch1) / 4) + 1
                 prepChain' [] = []
                 prepChain' ch2 = (last ch2):[head ch2] ++ (prepChain' . drop 1 . init $ ch2)
                 rCol = take ((length ch1 - 2 * row) `div` 2) . drop row $ ch1
                 lCol = drop (length ch1 - ((length ch1 - 2 * row) `div` 2)) ch1


--ch1 mora da bude preradjen sa prepChain u pozivu funkcije. inPic mora biti matrica a ne niz
merge :: [(Int, [String])] -> [[(Int, [String])]] -> [(Int, [String])]
merge ch1 inPic = (take row1 ch1) ++ (merge' (take (length ch1 - 2 * row1) . drop row1 $ ch1) (transfChain ch1 inPic)) ++ (drop (length ch1 - row1) ch1)
           where merge' [] [] = []
                 merge' (x1:x2:ch2) inPic1 = x1:(head inPic1) ++ [x2] ++ (merge' ch2 $ drop 1 inPic1) 
                 row1 = (round $ (fromIntegral . length $ ch1) / 4) + 1
                 

picFlipV     = fmap (reverse)
picFlipH     = reverse
picRot90     = transpose . picFlipV 
picRot180    = picFlipH . picFlipV
picRot270    = transpose . picFlipH


transfPic (x,p) (picX,picP)  | (head p) == (head picP)                           = (picX,picP)
                             | (head p) == (head . picRot90 $ picP)              = (picX,picRot90 picP)
                             | (head p) == (head . picRot180 $ picP)             = (picX,picRot180 picP)
                             | (head p) == (head . picRot270 $ picP)             = (picX,picRot270 picP)
                             | (head p) == (head . picFlipV $ picP)              = (picX,picFlipV picP)
                             | (head p) == (head . picRot90 . picFlipV  $ picP)  = (picX,picRot90 . picFlipV $ picP)
                             | (head p) == (head . picRot180 . picFlipV  $ picP) = (picX,picRot180 . picFlipV $ picP)
                             | (head p) == (head . picRot270 . picFlipV $ picP)  = (picX,picRot270 . picFlipV $ picP)

bordToPic :: HM.HashMap Int [String] -> [(Int,[String])] -> [(Int,[String])]
bordToPic hmap list = bordToPic' list
           where bordToPic' [] = []
                 bordToPic' ((x,p):list) = (picX,picP):(bordToPic' list)
                    where (Just pic)    = HM.lookup x hmap
                          (picX,picP)   = transfPic (x,p) (x,pic)


isMonst row col monstArr picArr = isMonst' 0 0
                      where isMonst' rowM colM | rowM == ((fst . snd $ bounds monstArr) + 1) = True
                                               | colM == ((snd . snd $ bounds monstArr) + 1) = isMonst' (rowM + 1) 0
                                               | monstArr ! (rowM,colM) == '#' = if picArr ! (row + rowM, col + colM) == '#' then isMonst' rowM (colM + 1) else False
                                               | otherwise = isMonst' rowM (colM + 1)

cntMonst monstArr picArr = cntMonst' 0 0
       where cntMonst' row1 col1 | row1 == ((fst . snd $ bounds picArr) - (fst . snd $ bounds monstArr) + 1) = 0
                                 | col1 == ((snd . snd $ bounds picArr) - (snd . snd $ bounds monstArr) + 1) = cntMonst' (row1 + 1) 0
                                 | isMonst row1 col1 monstArr picArr = 1 + ( cntMonst' row1 (col1 + 1) )
                                 | otherwise = cntMonst' row1 (col1 + 1)



findOrient monstArr pic | (nrMonst pic) > 0 =  (nrMonst pic, pic)
                        | (nrMonst . picRot90 $ pic) > 0 = (nrMonst . picRot90 $ pic, picRot90 pic)
                        | (nrMonst . picRot180 $ pic) > 0 = (nrMonst . picRot180 $ pic, picRot180 pic)
                        | (nrMonst . picRot270 $ pic) > 0 = (nrMonst . picRot270 $ pic, picRot270 pic)
                        | (nrMonst . picFlipV $ pic) > 0 = (nrMonst . picFlipV $ pic, picFlipV pic)
                        | (nrMonst . picRot90 . picFlipV $ pic) > 0 = (nrMonst . picRot90 . picFlipV $ pic, picRot90 . picFlipV $ pic)
                        | (nrMonst . picRot180 . picFlipV $ pic) > 0 = (nrMonst . picRot180 . picFlipV $ pic, picRot180 . picFlipV $ pic)
                        | (nrMonst . picRot270 . picFlipV $ pic) > 0 = (nrMonst . picRot270 . picFlipV $ pic, picRot270 . picFlipV $ pic)
      where mkArr = listArray ((0,0),(length pic - 1, (length . head $ pic) - 1 )) . concat
            nrMonst = cntMonst monstArr . mkArr








