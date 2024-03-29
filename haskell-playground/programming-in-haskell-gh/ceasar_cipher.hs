-- Ceasar Cipher.hs
-- From "Programming in Haskell" by Graham Hutton
-- Chapter 5, list comprehensions

import Data.Char

let2int :: Char -> Int
let2int c = ord c - ord 'a'

int2let :: Int -> Char
int2let n = chr (ord 'a' + n)

shift :: Int -> Char -> Char
shift n c | isLower c = int2let ((let2int c + n) `mod` 26)
          | otherwise = c

encode :: Int -> String -> String
encode n cs = [shift n c | c <- cs]

decode :: Int -> String -> String
decode n cs = encode (-n) cs

-- cracking the cipher --
percent :: Int -> Int -> Float
percent n m = (fromIntegral n / fromIntegral m) * 100

count :: Char -> String -> Int
count c cs = length [c' | c' <- cs, c == c']

lowers :: String -> Int
lowers cs = length [c | c <- cs, 'a' <= c && c <= 'z']

freqs :: String -> [Float]
freqs cs = [percent (count c cs) n | c <- ['a'..'z']]
           where n = lowers cs

chisqr :: [Float] -> [Float] -> Float
chisqr os es = sum [((o - e)^2) / e | (o, e) <- zip os es]

rotate :: Int -> [a] -> [a]
rotate n xs = drop n xs ++ take n xs

positions :: Eq a => a -> [a] -> [Int]
positions x xs = [i | (x', i) <- zip xs [0..], x == x']

table :: [Float]
table = [8.1, 1.5, 2.8, 4.2, 12.7, 2.2, 2.0, 6.1, 7.0,
         0.2, 0.8, 4.0, 2.4, 6.7, 7.5, 1.9, 0.1, 6.0,
         6.3, 9.0, 2.8, 1.0, 2.4, 0.2, 2.0, 0.1]

crack :: String -> String
crack cs = encode (-f) cs
           where 
             f = head (positions (minimum chitab) chitab)
             chitab = [chisqr (rotate n table') table | n <- [0..25]]
             table' = freqs cs


-- Additional exercises from chapter --
sqrsum :: Int -> Int
sqrsum n = sum $ take n [x^2 | x <- [1..]]

grid :: Int -> Int -> [(Int, Int)]
grid m n = [(x, y) | x <- [0..m], y <- [0..n]]

replicate :: Int -> a -> [a]
replicate n c = [c | _ <- [1..n]]

pyths :: Int -> [(Int, Int, Int)]
pyths n = [(x, y, z) | x <- [1..n], y <- [x..n], z <- [y..n], x^2 + y^2 == z^2]

factors :: Int -> [Int]
factors n = [n' | n' <- [1..n], n `mod` n' == 0]

perfects :: Int -> [Int]
perfects n = [n' | n' <- [1..n], n' == (-n') + (sum $ factors n')]
