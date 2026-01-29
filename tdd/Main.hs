module Main (main) where

import qualified LazyByteString
import qualified LazySerialise
import           System.Exit

main :: IO ()
main = do
  good <- and <$> sequence 
    [ LazyByteString.runTests
    , LazySerialise.runTests
    ]
  if good
    then exitSuccess
    else exitFailure
