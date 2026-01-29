module Main (main) where

import qualified LazyByteString
import qualified LazyCBOR
import qualified LazySerialise
import           System.Exit

main :: IO ()
main = do
  good <- and <$> sequence 
    [ LazyByteString.runTests
    , LazyCBOR.runTests
    , LazySerialise.runTests
    ]
  if good
    then exitSuccess
    else exitFailure
