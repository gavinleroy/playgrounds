-- Chpt 17 Calculating Compilers --

-- Syntax and Semantics of the language
data Expr = Val Int | Add Expr Expr

-- eval :: Expr -> Int
-- eval (Val n) = n
-- eval (Add x y) = eval x + eval y

-- Stack Based Evaluation --

type Stack = [Int]

push :: Int -> Stack -> Stack
push = (:)

add :: Stack -> Stack
add (m : n : ss) = n + m : ss

-- eval' :: Expr -> Stack -> Stack
-- eval' (Val n)   s = push n s
-- eval' (Add x y) s = add (eval' y (eval' x s))

-- eval :: Expr -> Int
-- eval e = head (eval' e [])

-- Continuation-passing Evaluation --

type Cont = Stack -> Stack

eval' :: Expr -> Cont
eval' e s = eval'' e id s

eval'' :: Expr -> Cont -> Cont
eval'' (Val n)   c s = c $ push n s
eval'' (Add x y) c s = eval'' x (eval'' y (c . add)) s

main :: IO ()
main = undefined
