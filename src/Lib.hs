
module Lib where

import Polysemy

import Data.Char

data QuestionMe m a where
  LogQuestion :: String -> QuestionMe m ()
  LogAnswer :: String -> QuestionMe m ()

makeSem ''QuestionMe

data GiveTitle m a where
  BeKing :: String -> GiveTitle m String

makeSem ''GiveTitle  

displayIt :: 
--  Members '[LogMe, GiveTitle] r => String -> Sem r String
    Member QuestionMe r =>
    Member GiveTitle r => String -> Sem r String 
displayIt name = do
  logQuestion "Who are you?"
  logAnswer name
  beKing name

questionMeToIO :: Member (Embed IO) r => Sem (QuestionMe ': r) a -> Sem r a
questionMeToIO = interpret \case
  LogQuestion question -> embed $ putStrLn ("<QUESTION>:   " <> question)
  LogAnswer answer -> embed $ putStrLn ("<ANSWER>:   " <> answer)

giveTitleToIO :: Member (Embed IO) r => Sem (GiveTitle ': r) a -> Sem r a
giveTitleToIO = interpret \case
  BeKing name -> do
    title <- embed $ getTitle name
    pure $ title <> map toUpper name <> " !"

-- Read king from DB
getTitle :: String -> IO String
getTitle "Ben" = return "<CROWD>:   Hail to the king "
getTitle _ = return "<CROWD:    You're not the king peon "