{-# LANGUAGE DeriveGeneric #-}

{- Based on Codec.Serialise.Tutorial.
 - Use Generic instance of encode/decode.
 -}

module Animal where

import           CBOR (unwrapCBORinCBOR, wrapCBORinCBOR)
import           Codec.Serialise
import qualified Data.ByteString.Lazy    as BSL
import           GHC.Generics (Generic)

data Animal
  = HoppingAnimal { animalName :: String, hoppingHeight :: Int }
  | WalkingAnimal { animalName :: String, walkingSpeed  :: Int }
  deriving (Eq, Generic, Show)

instance Serialise Animal

newtype SerialAnimal = SA { getAnimal :: Animal } deriving (Eq, Show)

instance Serialise SerialAnimal where
  encode = wrapCBORinCBOR (encode . getAnimal)
  decode = unwrapCBORinCBOR (fmap (const . SA) decode)

read :: FilePath -> IO Animal
read p = deserialise <$> BSL.readFile p

readS :: FilePath -> IO SerialAnimal
readS p = deserialise <$> BSL.readFile p
