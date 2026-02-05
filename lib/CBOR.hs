{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE RankNTypes          #-}

module CBOR where

import Data.ByteString.Base16.Lazy qualified as B16
import Data.ByteString.Lazy qualified as Lazy
import Data.ByteString.Lazy.Char8 qualified as BSC
import Codec.CBOR.Decoding (Decoder)
import Codec.CBOR.Decoding qualified as Dec
import Codec.CBOR.Encoding (Encoding)
import Codec.CBOR.Encoding qualified as Enc
import Codec.CBOR.Read qualified as Read
import Codec.CBOR.Write qualified as Write
import Codec.Serialise (Serialise (..))
import Control.Monad (when)

newtype Serialised a = Serialised { unSerialised :: Lazy.ByteString }
  deriving (Eq)

instance Show (Serialised a) where
  show (Serialised bytes) = BSC.unpack (B16.encode bytes)

wrapCBORinCBOR :: (a -> Encoding) -> a -> Encoding
wrapCBORinCBOR enc = encode . mkSerialised enc

unwrapCBORinCBOR :: (forall s. Decoder s (Lazy.ByteString -> a))
                 -> (forall s. Decoder s a)
unwrapCBORinCBOR dec = fromSerialised dec =<< decode

mkSerialised :: (a -> Encoding) -> a -> Serialised a
mkSerialised enc = Serialised . Write.toLazyByteString . enc

fromSerialised :: (forall s. Decoder s (Lazy.ByteString -> a))
               -> Serialised a -> (forall s. Decoder s a)
fromSerialised dec (Serialised payload) =
    case Read.deserialiseFromBytes dec payload of
      Left (Read.DeserialiseFailure _ reason) -> fail reason
      Right (trailing, mkA)
        | not (Lazy.null trailing) -> fail "trailing bytes in CBOR-in-CBOR"
        | otherwise                -> return (mkA payload)

instance Serialise (Serialised a) where
  encode (Serialised bs) = mconcat [
        Enc.encodeTag 24
      , Enc.encodeBytesIndef
      , Lazy.foldrChunks (\c acc -> acc <> Enc.encodePreEncoded c) mempty bs
      , Enc.encodeBreak
      ] 

  decode = do
      tag <- Dec.decodeTag
      when (tag /= 24) $ fail "expected tag 24 (CBOR-in-CBOR)"
      Serialised . Lazy.fromStrict <$> Dec.decodeBytes
