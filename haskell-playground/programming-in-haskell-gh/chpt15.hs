-- Primes using Lazy Evaluation --
sieve :: [Int] -> [Int]
sieve (p:xs) = p : sieve [x | x <- xs, x `mod` p /= 0]

primes :: [Int]
primes = sieve [2..]

-- Chpt 15 exercises --

-- 1

-- 2

-- 3

-- 4

-- 5

-- 6

main :: IO ()
main = undefined
