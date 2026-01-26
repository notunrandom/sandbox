{-# LANGUAGE TemplateHaskell #-}

module LazyByteString where

import Test.QuickCheck

prop_test :: Property
prop_test = once $ (1::Int) === (1::Int)


-----------DO NOT WRITE BELOW THIS LINE (needed for TemplateHaskell)-----------

return []
runTests :: IO Bool
runTests = $quickCheckAll
