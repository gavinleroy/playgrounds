-- Programming in Haskell by Graham Hutton
-- Chapter 11, Unbeatable Tic-Tac-Toe

import Data.Char
import Data.List
import System.IO

-- Data --
size :: Int
size = 3

-- NINF, INF used for alpha beta pruning algorithm
data Player = NINF | O | B | X | INF
              deriving (Eq, Ord, Show)

type Grid = [[Player]]

-- Game Tree --

treedepth :: Int
treedepth = 9

data Tree a = Node a [Tree a]
              deriving Show

gametree :: Grid -> Player -> Tree Grid
gametree g p = Node g [gametree g' (next p) | g' <- moves g p]

prune :: Int -> Tree a -> Tree a
prune 0 (Node x _)  = Node x []
prune n (Node x ts) = Node x [prune (n-1) t | t <- ts]

minimax :: Tree Grid -> Tree (Grid, Player)
minimax (Node g []) 
  | wins O g    = Node (g, O) []
  | wins X g    = Node (g, X) []
  | otherwise   = Node (g, B) []
minimax (Node g ts) 
  | turn g == O = Node (g, minimum ps) ts'
  | turn g == X = Node (g, maximum ps) ts'
    where
      ps  = [p | Node (_, p) _ <- ts'] 
      ts' = map minimax ts                    

abhelper :: Bool -> Player -> Player -> [Tree Grid] -> [Tree (Grid, Player)]
abhelper _ _ _ []          = []
abhelper maxpturn a b (t:ts) 
  | b <= a                 = []
  | maxpturn               = Node (g', p) ts' : abhelper maxpturn alpha b ts
  | not maxpturn           = Node (g', p) ts' : abhelper maxpturn a beta ts
  where
    alpha            = maximum [NINF, a, p]
    beta             = minimum [INF, b, p]
    Node (g', p) ts' = alphabeta a b t

alphabeta :: Player -> Player -> Tree Grid -> Tree (Grid, Player)
alphabeta _ _ (Node g [])
  | wins O g  = Node (g, O) []
  | wins X g  = Node (g, X) []
  | otherwise = Node (g, B) []
alphabeta a b (Node g ts) 
  | turn g == O = Node (g, minimum (b : ps)) ts'
  | turn g == X = Node (g, maximum (a : ps)) ts'
    where
     ps = [p | Node (_, p) _ <- ts']
     ts' = abhelper (turn g == X) a b ts

bestmove :: Grid -> Player -> Grid
bestmove g p = head [g' | Node (g', p') _ <- ts, p' == best]
               where
                 tree = prune treedepth (gametree g p)
                 -- Node (_, best) ts = minimax tree 
                 Node (_, best) ts = alphabeta NINF INF tree

treesize :: Tree a -> Int
treesize (Node _ []) = 0
treesize (Node _ ts) = sum (map treesize ts) + 1

-- Utilities --

next :: Player -> Player
next O = X
next X = O
next B = B

empty :: Grid
empty = replicate size (replicate size B)

full :: Grid -> Bool
full = all (/=B) . concat

diag :: Grid -> [Player]
diag g = [g !! n !! n | n <- [0..size - 1]]

turn :: Grid -> Player
turn g = if os <= xs then O else X
         where
           os = length (filter (== O) ps)
           xs = length (filter (== X) ps)
           ps = concat g

valid :: Grid -> Int -> Bool
valid g n = 0 <= n && n < size^2 && concat g !! n == B

chop :: Int -> [a] -> [[a]]
chop _ [] = []
chop n ps = take n ps : chop n (drop n ps)

move :: Grid -> Int -> Player -> [Grid]
move g i p = if valid g i then [chop size (xs ++ [p] ++ ys)] else []
             where (xs, B:ys) = splitAt i (concat g)

moves :: Grid -> Player -> [Grid]
moves g p | won g     = []
          | full g    = []
          | otherwise = concat [move g i p | i <- [0..((size^2)-1)]]

wins :: Player -> Grid -> Bool
wins p g = any line (rows ++ cols ++ diags)
           where
             line  = all (==p)
             rows  = g
             cols  = transpose g
             diags = [diag g, diag (map reverse g)]

won :: Grid -> Bool
won g = wins O g || wins X g

interleave :: a -> [a] -> [a]
interleave x []     = []
interleave x [y]    = [y]
interleave x (y:ys) = y : x : interleave x ys

showPlayer :: Player -> [String]
showPlayer B = ["   ", "   ", "   "]
showPlayer O = ["   ", " O ", "   "]
showPlayer X = ["   ", " X ", "   "]

showRow :: [Player] -> [String]
showRow = combineadj . interleave bars . map showPlayer
          where
            combineadj = foldr1 (zipWith (++))
            bars       = replicate 3 "|" 

-- IO utilities --

getNat :: String -> IO Int
getNat prompt = do putStr prompt
                   xs <- getLine
                   if xs /= [] && all isDigit xs then
                     return (read xs)
                   else
                     do putStrLn "ERR: Invalid input"
                        getNat prompt
                        

putGrid :: Grid -> IO ()
putGrid = putStr . unlines . concat . interleave bars . map showRow
          where
            bars = [replicate ((size * 4) - 1) '-']

cls :: IO ()
cls = putStr "\ESC[2J"

goto :: (Int, Int) -> IO ()
goto (x, y) = putStr ("\ESC[" ++ show y ++ ";" ++ show x ++ "H")

prompt :: Player -> String
prompt p = "Player " ++ show p ++ ", enter your move: "

run' :: Grid -> Player -> IO ()
run' g p 
  | wins O g  = putStrLn "Player O wins!\n"
  | wins X g  = putStrLn "Player X wins!\n"
  | full g    = putStrLn "Draw!\n"
  | otherwise = do i <- getNat (prompt p)
                   case move g i p of
                     []   -> do putStrLn "ERR: Invalid move"
                                run' g p
                     [g'] -> run g' (next p) 

run :: Grid -> Player -> IO ()
run g p = do cls
             goto (1, 1)
             putGrid g
             run' g p

play' :: Grid -> Player -> IO()
play' g p 
  | wins O g = putStrLn "Player O wins!\n"
  | wins X g = putStrLn "Player X wins!\n"
  | full g   = putStrLn "Draw!\n"
  | p == O   = do i <- getNat (prompt p)
                  case move g i p of
                    []   -> do putStrLn "ERR: Invalid move"
                               play' g p
                    [g'] -> play g' (next p) 
  | p == X   = do putStr "Player X is thinking ..."
                  (play $! (bestmove g p)) (next p)

play :: Grid -> Player -> IO ()
play g p = do cls
              goto (1, 1)
              putGrid g
              play' g p

-- User vs Computer --
main :: IO ()
main = do hSetBuffering stdout NoBuffering
          play empty O

-- User vs User main --
-- main :: IO ()
-- main = do hSetBuffering stdout NoBuffering
--           run empty O
