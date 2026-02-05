module Main where

import Control.Monad (replicateM)
import Animal (Animal(..))
import Codec.CBOR.Encoding 
import Codec.CBOR.Write
import Test.QuickCheck
import qualified Animal
import qualified Data.ByteString.Lazy as BSL
import Codec.Serialise (Serialise (..))
import CBOR

genAnimal :: Gen Animal
genAnimal = oneof 
  [ WalkingAnimal <$> arbitrary <*> arbitrary
  , HoppingAnimal <$> arbitrary <*> arbitrary
  ]

genAnimals :: Gen [Animal]
genAnimals = replicateM 1000000 genAnimal

encodeAnimals :: [Animal] -> Encoding 
encodeAnimals xs = mconcat
  [ encodeListLenIndef
  , foldr (\x -> (<> encode x)) mempty xs 
  , encodeBreak
  ]

serialiseAnimals :: [Animal] -> BSL.ByteString
serialiseAnimals = toLazyByteString . encodeAnimals

serialiseAnimals' :: [Animal] -> BSL.ByteString
serialiseAnimals' = toLazyByteString . encode . Serialised . toLazyByteString . encodeAnimals

main :: IO ()
main = do
  animals <- generate genAnimals
  BSL.writeFile "animals.cbor" (serialiseAnimals' animals)
