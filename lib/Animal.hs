{-# LANGUAGE DeriveGeneric #-}

{- Based on Codec.Serialise.Tutorial.
 - Use Generic instance of encode/decode.
 -}

module Animal where

import           Codec.Serialise
import qualified Data.ByteString.Lazy    as BSL
import           GHC.Generics (Generic)

data Animal
  = HoppingAnimal { animalName :: String, hoppingHeight :: Int }
  | WalkingAnimal { animalName :: String, walkingSpeed  :: Int }
  deriving (Generic, Show)

instance Serialise Animal

read :: FilePath -> IO Animal
read p = deserialise <$> BSL.readFile p

