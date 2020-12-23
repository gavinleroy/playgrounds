-- map f (filter p xs)

import Data.Char

type Bit = Int

bin2int :: [Bit] -> Int
bin2int = foldr (\x y -> x + 2 * y) 0

int2bin :: Int -> [Bit]
int2bin 0 = []
int2bin n = n `mod` 2 : int2bin (n `div` 2)

make8 :: [Bit] -> [Bit]
make8 bits = take 8 (bits ++ repeat 0)

encode :: String -> [Bit]
encode = concat . map (make8 . int2bin . ord)

chop8 :: [Bit] -> [[Bit]]
chop8 [] = []
chop8 bits = take 8 bits : chop8 (drop 8 bits)

decode :: [Bit] -> String
decode = map (chr . bin2int) . chop8

-- all :: (a -> Bool) -> [Bool] -> Bool
-- all p = and . (map p)

-- any :: (a -> Bool) -> [Bool] -> Bool
-- any p = or . (map p)

take_while :: (a -> Bool) -> [a] -> [a]
take_while _ [] = []
take_while p (x:xs) | p x = x : take_while p xs
                    | otherwise = []

drop_while :: (a -> Bool) -> [a] -> [a]
drop_while _ [] = []
drop_while p (x:xs) | p x = drop_while p xs
                    | otherwise = x:xs

dec2intl :: [Int] -> Int
dec2intl = foldl (\x y -> 10*x + y) 0

dec2intr :: [Int] -> Int
dec2intr = foldr (\x y -> 10*y + x) 0
