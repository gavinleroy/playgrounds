import Control.Applicative
import Data.Char
import System.IO

-- Parser --
newtype Parser a = P (String -> [(a, String)])

instance Functor Parser where
  -- fmap :: (a -> b) -> Parser a -> Parser b
  fmap g pa = P (\inp -> case parse pa inp of
    []       -> []
    [(v, out)] -> [(g v, out)])

instance Applicative Parser where
  -- pure :: a -> Parser a
  pure v = P (\inp -> [(v, inp)])
  -- (<*>) :: Parser (a -> b) -> Parser a -> Parser b
  pg <*> pa = P (\inp -> case parse pg inp of
    []         -> []
    [(g, out)] -> parse (fmap g pa) out)
  
instance Monad Parser where
  -- (>>=) :: Parser a -> (a -> Parser b) -> Parser b
  pa >>= g = P (\inp -> case parse pa inp of
    []          -> []
    [(va, out)] -> parse (g va) out)

instance Alternative Parser where
  -- empty :: Parser a
  empty = P (\inp -> [])
  -- (<|>) :: Parser a -> Parser a -> Parser a
  px <|> py = P (\inp -> case parse px inp of
    []         -> parse py inp
    [(v, out)] -> [(v, out)])

parse :: Parser a -> String -> [(a, String)]
parse (P p) inp = p inp

item :: Parser Char
item = P (\inp -> case inp of
    []     -> []
    (x:xs) -> [(x, xs)])

sat :: (Char -> Bool) -> Parser Char
sat p = do x <- item
           if p x then return x else empty

-- Parser derivatives

digit :: Parser Char
digit = sat isDigit

lower :: Parser Char
lower = sat isLower

upper :: Parser Char
upper = sat isUpper

letter :: Parser Char
letter = sat isAlpha

alphanum :: Parser Char
alphanum = sat isAlphaNum

char :: Char -> Parser Char
char c = sat (==c)

string :: String -> Parser String
string []     = return []
string (c:cs) = do char c
                   string cs
                   return (c:cs)

ident :: Parser String
ident = do x <- lower
           xs <- many alphanum
           return (x:xs)

nat :: Parser Int
nat = do xs <- some digit
         return (read xs)

int :: Parser Int
int = do char '-'
         n <- nat
         return (-n) 
      <|> nat

space :: Parser ()
space = do many (sat isSpace)
           return ()

token :: Parser a -> Parser a
token p = do space
             v <- p
             space
             return v

identifier :: Parser String
identifier = token ident

natural :: Parser Int
natural = token int

symbol :: String -> Parser String
symbol s = token $ string s

-- Expressions -- Grammar
-- expr := term (+ expr | - expr | epsilon)
-- term := factor (* term | / term | epsilon)
-- factor := ( expr ) | nat
-- nat := 0 | 1 | 2 | ...

expr :: Parser Int
expr = do t <- term
          do symbol "+"
             e <- expr
             return (t + e)
           <|> do symbol "-"
                  e <- expr
                  return (t - e)
           <|> return t

term :: Parser Int
term = do f <- factor
          do symbol "*"
             t <- term
             return (f * t)
           <|> do symbol "/"
                  t <- term
                  return (f `div` t)
           <|> return f

factor :: Parser Int
factor = do symbol "("
            e <- expr
            symbol ")"
            return e
          <|> natural

-- eval :: String -> Int
-- eval xs = case (parse expr xs) of
--   [(n, [])]  -> n
--   [(_, out)] -> error ("unused input: " ++ out)
--   []         -> error "invalid input"

-- Calculator data --

type Pos = (Int, Int)

-- GUI things --

box :: [String]
box = ["+---------------+",
       "|               |", 
       "+---+---+---+---+", 
       "| q | c | d | = |", 
       "+---+---+---+---+", 
       "| 1 | 2 | 3 | + |", 
       "+---+---+---+---+", 
       "| 4 | 5 | 6 | - |", 
       "+---+---+---+---+", 
       "| 7 | 8 | 9 | * |", 
       "+---+---+---+---+", 
       "| 0 | ( | ) | / |", 
       "+---+---+---+---+"]

buttons :: String
buttons = standard ++ extra
  where 
    standard = "qcd=123+456-789*0()/"
    extra    = "QCD \ESC\BS\DEL\n"

goto :: Pos -> IO ()
goto (x, y) = putStr("\ESC[" ++ show y ++ ";" ++ show x ++ "H")

writeat :: Pos -> String -> IO ()
writeat p xs = do goto p
                  putStr xs

display xs = do writeat (3, 2) (replicate 13 ' ')
                writeat (3, 2) (reverse (take 13 (reverse xs)))

getCh :: IO Char
-- getCh = do ch <- getChar
--            return ch
getCh = do hSetEcho stdin False
           ch <- getChar
           hSetEcho stdin True
           return ch

showbox :: IO ()
showbox = sequence_ [writeat (1, y) b | (y, b) <- zip [1..] box]

calc :: String -> IO ()
calc xs = do display xs
             c <- getCh
             if elem c buttons then
               process c xs
             else 
               do beep
                  calc xs

process :: Char -> String -> IO ()
process c xs 
  | elem c "qQ\ESC"    = quit
  | elem c "dD\BS\DEL" = delete xs
  | elem c "=\n"       = eval xs
  | elem c "cC"        = clear
  | otherwise          = press c xs

quit :: IO ()
quit = goto (1, 14)

delete :: String -> IO ()
delete [] = calc []
delete xs = calc (init xs)

eval :: String -> IO ()
eval xs = case parse expr xs of
  [(n, [])] -> calc (show n)
  _         -> do beep
                  calc xs

beep :: IO ()
beep = putStr "\BEL"

clear :: IO ()
clear = calc []

cls :: IO ()
cls = putStr "\ESC[2J"

press :: Char -> String -> IO ()
press c xs = calc (xs ++ [c])

run :: IO ()
run = do cls
         showbox
         clear

main :: IO ()
main = do hSetBuffering stdout NoBuffering
          run
