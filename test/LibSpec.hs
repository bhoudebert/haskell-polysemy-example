module LibSpec where

import Lib

import Test.Hspec

import Test.QuickCheck
import Test.QuickCheck.Instances ()

import GHC.IO (liftIO)

import Generic.Random
import Test.QuickCheck.Monadic
import Polysemy

questionMeToIOMocked :: Member (Embed IO) r => Sem (QuestionMe ': r) a -> Sem r a
questionMeToIOMocked = interpret \case
  LogQuestion question -> embed $ putStrLn ("<QUESTION MOCKED>:   " <> question)
  LogAnswer answer -> embed $ putStrLn ("<ANSWER MOCKED CONTEXT>:   " <> answer)

-- | See here we replace the call the interpreter so Ben isn't King anymore.
giveTitleToIOMocked :: Member (Embed IO) r => Sem (GiveTitle ': r) a -> Sem r a
giveTitleToIOMocked = interpret (\(BeKing _) -> return "<CROWD>:   Hail to the Enchanter!")

-- | Everything is happening at interpreter level so ... we can do everything now!
spec :: Spec
spec = do
  describe "Testing lib" $ do
    it "Should be a complete different logging from Main" $ do
      title <- runM . giveTitleToIOMocked. questionMeToIOMocked $ displayIt "Ben"
      title `shouldBe` "<CROWD>:   Hail to the Enchanter!" 
