-- State Transition --

type State = Int -- This could be generic

newtype ST a = S (State -> (a, State))

app :: ST a -> State -> (a, State)
app (S st) = st

instance Functor ST where
  -- fmap :: (a -> b) -> ST a -> ST b
  fmap g st = S (\s -> 
    let (x, s') = app st s in 
      (g x, s'))

instance Applicative ST where
  -- pure :: a -> ST a
  pure x = S (\s -> (x, s))
  -- (<*>) ST (a -> b) -> ST a -> ST b
  stf <*> stx = S (\s ->
    let (f, s') = app stf s
        (x, s'') = app stx s'
        in (f x, s''))

instance Monad ST where
  -- (>>=) ST a -> (a -> ST b) -> ST b
  st >>= f = S (\s -> let (x, s') = app st s in app (f x) s')

-- Testing state transition with trees --
data Tree a = Leaf a | Node (Tree a) (Tree a)
  deriving Show

tree :: Tree Char
tree = Node (Node (Leaf 'a') (Leaf 'b')) (Leaf 'c')

fresh :: ST Int
fresh = S (\n -> (n, n+1))

alabel :: Tree a -> ST (Tree Int)
alabel (Leaf _)   = Leaf <$> fresh
alabel (Node l r) = Node <$> alabel l <*> alabel r

mlabel :: Tree a -> ST (Tree Int)
mlabel (Leaf _)   = do n <- fresh
                       return (Leaf n)
mlabel (Node l r) = do l' <- mlabel l
                       r' <- mlabel r
                       return (Node l' r')

-- Chapter 12 Exercises --
data Tree_ a = Leaf_ | Node_ (Tree_ a) a (Tree_ a)
  deriving Show

instance Functor Tree_ where
  -- fmap :: (a -> b) -> Tree_ a -> Tree_ b
    fmap g (Leaf_) = Leaf_
    fmap g (Node_ l v r) = (Node_ (fmap g l) (g v) (fmap g r))

-- instance Functor ((->) a) where
  -- fmap :: (b -> c) -> (a -> b) -> (a -> c)
  -- fmap = (.)
  
-- instance Applicative ((->) a) where
  -- pure :: b -> (a -> b)
  -- pure = const
  -- (<*>) :: (a -> b -> c) -> (a -> b) -> (a -> c)
  -- g <*> h = \x -> g x (h x)
