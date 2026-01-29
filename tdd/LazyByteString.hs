{-# LANGUAGE TemplateHaskell #-}

{- This module served to find out how to test for lazyness.
 - If you replace ByteString.Lazy with the strict ByteString, the tests fails
 - (badly, QuickCheck's `withinz doesn't even work and even after Ctrl-C a
 - stray process fills up the computer's RAM).
 - Best source I found for how to test for lazyness is:
 - https://wiki.haskell.org/Maintaining_laziness
 -}

module LazyByteString where

import qualified Data.ByteString.Lazy as B
import Data.Word (Word8)
import Test.QuickCheck

prop_test :: Property
prop_test =
  once $ within 5000000 $
    let
      x = 1::Word8
      y = head $ B.unpack $ B.pack $ repeat x
      in y == x


-----------DO NOT WRITE BELOW THIS LINE (needed for TemplateHaskell)-----------

return []
runTests :: IO Bool
runTests = $quickCheckAll
