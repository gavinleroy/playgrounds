import System.IO

getCh :: IO Char
getCh = do hSetEcho stdin False
           ch <- getChar
           hSetEcho stdin True
           return ch

sGetStr :: IO String
sGetStr = do c <- getCh
             if c == '\n' then 
                   do putChar c
                      return []
             else do cs <- sGetStr
                     return (c:cs)

match :: String -> String -> String
match t g = [if elem c' g then c' else '-' | c' <- t] 

combine :: String -> String -> String
combine bef new = [if b == '-' then n else b | (b, n) <- zip bef new]

play :: String -> String -> IO ()
play target guess = do putStrLn $ "> " ++ guess
                       putStr "guess> " 
                       hFlush stdout
                       newguess <- getLine
                       if newguess == target then
                         putStrLn "You Win!"
                       else play target $! combine guess $! match target newguess

main :: IO ()
main = do
  putStr "Enter a password> "
  hFlush stdout
  s <- sGetStr
  play s $ take (length s) $ repeat '-'
