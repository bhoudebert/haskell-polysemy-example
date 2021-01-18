module LibSpec where

import Lib

import Test.Hspec

import Polysemy
import Polysemy.Writer

questionMeToIOMocked :: Member (Embed IO) r => Sem (QuestionMe ': r) a -> Sem r a
questionMeToIOMocked = interpret \case
  LogQuestion question -> embed $ putStrLn ("<QUESTION MOCKED>:   " <> question)
  LogAnswer answer -> embed $ putStrLn ("<ANSWER MOCKED CONTEXT>:   " <> answer)

-- | See here we replace the call the interpreter so Ben isn't King anymore.
giveTitleToIOMocked :: Member (Embed IO) r => Sem (GiveTitle ': r) a -> Sem r a
giveTitleToIOMocked = interpret (\(BeKing _) -> return "<CROWD>:   Hail to the Enchanter!")

-- Records

questionMeToRecord :: Member (Writer [String]) r => Sem (QuestionMe ': r) a -> Sem r a
questionMeToRecord = interpret \case
  LogQuestion q -> tell ["count" <> q]
  LogAnswer n -> tell ["count" <> n]

giveTitleToRecord :: Member (Writer [String]) r => Sem (GiveTitle ': r) a -> Sem r a
giveTitleToRecord = interpret \case
  BeKing n -> do 
    tell ["Enchanter" <> n]
    return "records counted"

-- | Everything is happening at interpreter level so ... we can do everything now!
spec :: Spec
spec = do
  describe "Testing lib" $ do
    it "Should be a complete different logging from Main" $ do
      title <- runM . giveTitleToIOMocked. questionMeToIOMocked $ displayIt "Ben"
      title `shouldBe` "<CROWD>:   Hail to the Enchanter!" 
    it "There should be 3 calls to mocks (@see record)" $
      let (list, result) = Polysemy.run . runWriter . giveTitleToRecord . questionMeToRecord $ displayIt "Ben"
      in do 
        length list `shouldBe` 3 
        result `shouldBe` "records counted"