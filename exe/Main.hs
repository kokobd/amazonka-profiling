{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Amazonka qualified
import Amazonka.S3 qualified as S3
import Control.Monad (void)
import Control.Monad.Random.Class
import Control.Monad.Trans.Class (lift)
import Data.Generics.Labels ()
import Data.Text qualified as T
import Data.Traversable (for)

main :: IO ()
main = do
  env <- Amazonka.newEnv Amazonka.discover
  void $
    for (replicate 1000 ()) $ \_ -> do
      randomStr <- fmap (T.pack . take 1000000) $ getRandomRs ('a', 'z')
      void . Amazonka.runResourceT . Amazonka.send env $
        S3.newPutObject "bellroy-eventlog-test" "test" (Amazonka.toBody randomStr)
