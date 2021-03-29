-- Chapter 14 Exercises --

import Data.Monoid
import Data.Foldable

-- 1
-- instance (Monoid a, Monoid b) => Monoid (a, b) where
--   -- mempty :: (a, b)
--   mempty = (mempty, mempty)
--   -- mappend :: (a, b) -> (a, b) -> (a, b)
--   (x1, y1) `mappend` (x2, y2) = (x1 <> x2, y1 <> y2)

-- 2
-- instance Monoid b => Monoid (a -> b) where
--   -- mempty :: a -> b
--   mempty = (\_ -> mempty)
--   -- mappend :: (a -> b) -> (a -> b) -> (a -> b)
--   f `mappend` g = \q -> f q `mappend` g q

-- 4
data Tree a = Leaf | Node (Tree a) a (Tree a)
  deriving Show

instance Functor Tree where
  -- fmap :: (a -> b) -> Tree a -> Tree b
  fmap _ (Leaf)       = Leaf
  fmap g (Node l v r) = Node (fmap g l) (g v) (fmap g r)

instance Foldable Tree where
  -- fold :: Monoid a => Tree a -> a
  fold (Leaf)       = mempty
  fold (Node l v r) = fold l <> v <> fold r
  -- foldMap :: Monoid b => (a -> b) -> Tree a -> b
  foldMap _ (Leaf)       = mempty
  foldMap g (Node l v r) = foldMap g l <> g v <> foldMap g r
  -- foldr :: (a -> b -> b) -> b -> Tree a -> b
  foldr _ i (Leaf)       = i
  foldr g i (Node l v r) = foldr g (g v $ foldr g i r) l
  -- foldl :: (a -> b -> a) -> a -> Tree b -> a
  foldl g i (Leaf)       = i
  foldl g i (Node l v r) = foldl g (g (foldl g i l) v) r

instance Traversable Tree where
  -- traverse :: Applicative f => 
  --  (a -> f b) -> Tree a -> f (Tree b)
  traverse g (Leaf)       = pure Leaf 
  traverse g (Node l v r) = Node <$> traverse g l <*> g v <*> traverse g r

tree1 :: Tree Int
tree1 = Node (Node Leaf 0 Leaf) 1 (Node Leaf 2 Leaf)

tree2 :: Tree Int
tree2 = Node (Node Leaf 10 Leaf) 1 (Node Leaf 2 Leaf)

dec :: (Ord a, Num a) => a -> Maybe a
dec n 
  | n <= 0    = Nothing
  | otherwise = Just $ n-1

inc :: (Ord a, Num a) => a -> Maybe a
inc n 
  | n >= 10   = Nothing
  | otherwise = Just $ n + 1

-- 5
filterF :: Foldable  t => (a -> Bool) -> t a -> [a]
filterF p = foldMap (\x -> if p x then [x] else [])

main :: IO ()
main = undefined
