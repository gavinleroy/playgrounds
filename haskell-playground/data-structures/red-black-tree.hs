{- Red Black tree implementation
 - Gavin Gray
 - Following the paper 
 - "Functional Pearls : 
 -    Red-Black Trees in a Functional Setting"
 -}

data Color = R | B
  deriving (Show)

data Tree t 
  = Empty
  | Node Color (Tree t) t (Tree t)
  deriving (Show)

-- Important Invariants for a Red-Black tree
-- Invariant 1. No red node has a red parent.
-- Invariant 2. Every path from the root to an empty 
--    node contains the same number of black nodes.

-- This Red-Black tree will be used as a Set
type Set t = Tree t

-- return the empty set
empty :: Set t
empty = Empty

-- Is element e a member of the set
member :: Ord a => a -> Set a -> Bool
member _ Empty = False
member e (Node c lt e' rt) 
  | e < e'  = member e lt
  | e == e' = True
  | e > e'  = member e rt

-- Insert an element
insert :: Ord a => a -> Set a -> Set a
insert e s = makeblack $ insert' s
  where
    makeblack (Node _ lt x rt) = Node B lt x rt
    insert' Empty = Node R Empty e Empty
    insert' n@(Node c lt e' rt) 
      | e < e'  = balance c (insert' lt) e' rt
      | e == e' = n
      | e > e'  = balance c lt e' (insert' rt)

-- Balance a tree using the four cases
balance :: Color -> Set a -> a -> Set a -> Set a
-- Red left child with Red left child
balance B (Node R (Node R a x b) y c) z d 
  = Node R (Node B a x b) y (Node B c z d)
-- Red left child with Red right child
balance B (Node R a x (Node R b y c)) z d 
  = Node R (Node B a x b) y (Node B c z d)
-- Red right child with Red left child
balance B a x (Node R (Node R b y c) z d) 
  = Node R (Node B a x b) y (Node B c z d)
-- Red right child with Red right child
balance B a x (Node R b y (Node R c z d)) 
  = Node R (Node B a x b) y (Node B c z d)
-- Anything else if fine :)
balance color a x b = Node color a x b

height :: Tree a -> Int
height Empty = 0
height (Node _ lt _ rt) 
  = max (height lt) (height rt) + 1

main :: IO ()
main = do
  let s = foldr insert empty [1..1000000]
  -- putStrLn $ "Height of Set: " ++ (show $ height s)
  putStrLn "Checking member status ..."
  if member 573 s
  then putStrLn "Yes"
  else putStrLn "No"

