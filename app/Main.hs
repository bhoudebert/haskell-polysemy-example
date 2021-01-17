module Main where

import Lib
import Polysemy

main :: IO ()
main = do
  king <- runM . giveTitleToIO . questionMeToIO $ displayIt "Ben"
  putStrLn king
  peon <- runM . giveTitleToIO . questionMeToIO $ displayIt "Reymi"
  putStrLn peon
  _ <- runM . giveTitleToIO . questionMeToIO $ displayIt "EOF"
  pure ()
