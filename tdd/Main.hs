module Main (main) where

import qualified LazyByteString

import System.Exit

main :: IO ()
main = do
  good <- and <$> sequence 
    [ LazyByteString.runTests
    ]
  if good
    then exitSuccess
    else exitFailure
