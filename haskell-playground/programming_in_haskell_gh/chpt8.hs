-- Simple continuation example for
-- addition exressions. 

type Cont = [Op]

data Op   = EVAL Expr 
            | EADD Expr
            | EMULT Expr
            | ADD Int
            | MULT Int

data Expr = Val Int
            | Add Expr Expr
            | Mult Expr Expr

value :: Expr -> Int
value e = eval e []

eval :: Expr -> Cont -> Int
eval (Val n) c    = exec c n
eval (Add x y) c  = eval x (EADD y : c)
eval (Mult x y) c = eval x (EMULT y : c)

exec :: Cont -> Int -> Int
exec [] n             = n
exec (EVAL x : cs) n  = eval x cs
exec (EADD x : cs) n  = eval x (MULT n : cs)
exec (EMULT x : cs) n = eval x (ADD n : cs)
exec (ADD x : cs) n   = exec cs (x+n)
exec (MULT x : cs) n  = exec cs (x*n)

-- Chapter 8 Exercises --

-- 1
data Nat = Zero
           | One Nat
     deriving (Eq, Show)

dec2nat :: Int -> Nat
dec2nat x | x == 0    = Zero
          | otherwise = One (dec2nat (x - 1))

nat2dec :: Nat -> Int
nat2dec Zero    = 0
nat2dec (One n) = 1 + nat2dec n

add :: Nat -> Nat -> Nat
add Zero y    = y
add (One n) y = One $ add n y

mult :: Nat -> Nat -> Nat
mult Zero y    = Zero
mult (One x) y = add y $ mult x y

-- 3
data Tree a = Leaf a
              | Node (Tree a) (Tree a)
              deriving Show

leafcount :: Tree a -> Int
leafcount (Leaf _)   = 1
leafcount (Node l r) = leafcount l + leafcount r

balanced :: Tree a -> Bool
balanced (Leaf _)   = True
balanced (Node l r) = balanced l && balanced r && diff <= 1
                      where
                        diff = leafcount r - leafcount l

-- 4
split :: [a] -> ([a], [a])
split xs = splitAt (length xs `div` 2) xs

balance :: [a] -> Tree a
balance (x:[]) = Leaf x
balance xs     = Node (balance l) (balance r)
                 where
                   (l, r) = split xs

-- 5
folde :: (Int -> a) -> (a -> a -> a) -> Expr -> a
folde f g (Val n) = f n
folde f g (Add x y) = g (folde f g x) (folde f g y) 

-- 6
eeval :: Expr -> Int
eeval = folde id (+)

size :: Expr -> Int
size = folde (\_ -> 1) (+)


-- 7
-- instance Eq a => Eq (Maybe a) where
--   (Just x) == (Just y) = x == y
--   (Nothing) == (Nothing) = True
--   _ == _ = False

--   x /= y = not (x == y)

-- instance Eq a => Eq [a] where
--   xs == ys = and [x == y | (x, y) <- zip xs ys]
--
--   xs /= ys = not (xs == ys)
