{-# LANGUAGE TemplateHaskell #-}

module LazyByteString where

import qualified Data.ByteString.Lazy as B
import Data.Word (Word8)
import Test.QuickCheck

prop_test :: Property
prop_test =
  once $
      (1::Word8) == (head $ B.unpack $ B.pack $ repeat 1)


-----------DO NOT WRITE BELOW THIS LINE (needed for TemplateHaskell)-----------

return []
runTests :: IO Bool
runTests = $quickCheckAll
