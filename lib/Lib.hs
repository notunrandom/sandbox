module Lib where

import           Codec.Serialise
import qualified Data.ByteString.Lazy    as BSL

write :: Serialise a => FilePath -> a -> IO ()
write p x = BSL.writeFile p (serialise x)
