{-# LANGUAGE DeriveGeneric #-}

module Main where

import Codec.Serialise
import qualified Data.ByteString.Lazy as BSL
import GHC.Generics (Generic)
import Prelude hiding (readIO)

fileName :: FilePath
fileName = "out.cbor"

data Animal = HoppingAnimal { animalName :: String, hoppingHeight :: Int }
            | WalkingAnimal { animalName :: String, walkingSpeed  :: Int }
            deriving (Generic,Show)

instance Serialise Animal

fredTheFrog :: Animal
fredTheFrog = HoppingAnimal "Fred" 4

-- | To output value into a file
write :: Serialise a => FilePath -> a -> IO ()
write file val = BSL.writeFile file (serialise val)

-- | Outputs @Fred@ value into file
writeIO :: IO ()
writeIO = write fileName fredTheFrog

-- | Reads the value from file
readIO :: IO Animal
readIO = deserialise <$> BSL.readFile fileName

printIO :: IO ()
printIO = do
    val <- readIO
    print val

main :: IO ()
main = do
  writeIO
  printIO
