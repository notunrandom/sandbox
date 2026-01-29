{-# LANGUAGE TemplateHaskell #-}

{- This module explores lazyness of the Serialise library.
 - Apparently, serialise is lazy but deserialise is not.
 -}

module LazySerialise where

import Codec.Serialise
import qualified Data.ByteString.Lazy as BL
import Shape
import Test.QuickCheck

prop_serialiseIsLazyInfinite :: Property
prop_serialiseIsLazyInfinite =
  once $ within 5000000 $
   let
    c = Circle 1.5
    x = BL.head $ serialise $ repeat c
    in x == x

prop_serialiseIsLazyUndefined :: Property
prop_serialiseIsLazyUndefined =
  once $ within 5000000 $
   let
    c = Circle 1.5
    x = BL.head $ serialise $ replicate 1000 c ++ undefined
    in x == x

-- This one fails
prop_roundTripIsLazy :: Property
prop_roundTripIsLazy =
  once $ within 5000000 $
    let
      c = Circle 1.5
      d = head $ deserialise $ serialise $ repeat c
      in c == d

-----------DO NOT WRITE BELOW THIS LINE (needed for TemplateHaskell)-----------

return []
runTests :: IO Bool
runTests = $quickCheckAll
