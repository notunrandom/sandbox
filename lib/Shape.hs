module Shape where

{- Based on Codec.Serialise.Tutorial.
 - Handwritten instance of Serialise
 -}

import           Codec.CBOR.Encoding
import           Codec.Serialise
import           Codec.Serialise.Decoding
import qualified Data.ByteString.Lazy      as BSL

data Shape
  = Circle    { radius :: Double }
  | Square    { side   :: Double }
  | Rectangle { sideA  :: Double
              , sideB  :: Double
              }
  deriving (Eq,Show)

instance Serialise Shape where
  encode = encodeShape
  decode = decodeShape

encodeShape :: Shape -> Encoding
encodeShape (Circle r) =
  encodeListLen 2
  <> encodeWord 7
  <> encodeDouble r
encodeShape (Square x) =
  encodeListLen 2
  <> encodeWord 8
  <> encodeDouble x
encodeShape (Rectangle x y) =
  encodeListLen 3
  <> encodeWord 9
  <> encodeDouble x
  <> encodeDouble y

decodeShape :: Decoder s Shape
decodeShape = do
  n <- decodeListLen
  t <- decodeWord
  case (n,t) of
    (2, 7) -> Circle    <$> decode
    (2, 8) -> Square    <$> decode
    (3, 9) -> Rectangle <$> decode <*> decode
    _      -> fail "invalid Shape encoding"

read :: FilePath -> IO Shape
read p = deserialise <$> BSL.readFile p

