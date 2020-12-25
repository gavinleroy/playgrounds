qsort :: Ord a => [a] -> [a]
qsort [] = []
qsort (x:xs) = qsort lower ++ [x] ++ qsort upper
               where
                 lower = [x' | x' <- xs, x' <= x]
                 upper = [x' | x' <- xs, x' > x]

fib :: Int -> Int
fib n | n < 2 = n
      | otherwise = fib (n-2) + fib (n-1)
