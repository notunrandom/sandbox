{-# LANGUAGE TemplateHaskell #-}

{- This module explores lazyness of the CBOR in CBOR code from
 - ouroboros-network's Block.hs
 -}

module LazyCBOR where

import           Animal
import           Codec.Serialise
import qualified Data.ByteString.Lazy as BL
import           Test.QuickCheck

fredTheFrog :: Animal
fredTheFrog = HoppingAnimal "Fred" 4

prop_serialiseIsLazyInfinite :: Property
prop_serialiseIsLazyInfinite =
  once $ within 5000000 $
   let
    f = SA fredTheFrog
    x = BL.head $ serialise $ repeat f
    in x == x

prop_serialiseIsLazyUndefined :: Property
prop_serialiseIsLazyUndefined =
  once $ within 5000000 $
   let
    f = SA fredTheFrog
    x = BL.head $ serialise $ replicate 1000 f ++ undefined
    in x == x

prop_serialiseRoundTrip :: Property
prop_serialiseRoundTrip =
  once $ within 5000000 $
   let
    f  = SA fredTheFrog
    f' = deserialise $ serialise f
    in f' == f

-----------DO NOT WRITE BELOW THIS LINE (needed for TemplateHaskell)-----------

return []
runTests :: IO Bool
runTests = $quickCheckAll
