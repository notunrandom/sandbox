# Introduction

Current exploration aims to introduce lazy decoding of CBOR-in-CBOR in
[Block.hs][block-hs] 

# Roadmap

- [x] Read about Haskell lazyness, monads...
- [x] Learn to use `Codec.Serialise` and `Codec.CBOR` libraries
- [x] Find out how to test for lazyness
- [x] Find out whether `Codec.Serialise` allows for lazyness
- [x] Read documentation of `Codec.Serialise` and `Codec.CBOR` to find
  potential solutions
- [ ] Reproduce lazyness failure of CBOR-in-CBOR in [Block.hs][block-hs]
- [ ] Explore potential solutions to achieve lazyness of CBOR-in-CBOR decoding
- [ ] Port solution into [ouroboros-network][network-fork] code

# Technical notes

Observations:

- `Codec.Serialise.deserialise` is not lazy.
- Even its incremental interface is not:
  * Documentation states: *Note that the incremental behaviour is only for the
    input data, not the output value: the final deserialised value is
    constructed and returned as a whole, not incrementally*
  * Code of the incremental interface uses strict `Control.Monad.ST`
- However `unwrapCBORinCBOR` in [Block.hs][block-hs] uses its own
  `deserialise`, called `fromSerialised`.
- `Codec.CBOR.Encoding` (like CBOR itself) provides a way to write a list or
  bytes of indefinite length.

Solutions to explore:

- Use `Code.CBOR.Encoding.encodePreEncoded` (which seems to address the same
  situation as CBOR-in-CBOR). This is presumably what the TODO in
  [Block.hs][block-hs] that says *TODO: replace with encodeEmbeddedCBOR from
  cborg-0.2.4 once it is available* is referring to. This might actually solve
  the problem, since on the decoding end it should no longer appear to be
  embedded, so decoding might proceed incrementally (one datatype at a time).
- Rewrite `deserialise` using `Control.Monad.ST.Lazy`
- Use `Codec.CBOR.Term`
- Keep CBOR-in-CBOR idea but encode already serialised bytestring using
  `toChunks`/`fromChunks` and `encodeIndef`/`encodeBreak` and/or
  `Data.ByteString.Builder`


[network-fork]: https://github.com/notunrandom/
[block-hs]: https://github.com/IntersectMBO/ouroboros-network/blob/63675a60e7a24b5af3ce931df3077f980daeb6c5/ouroboros-network/api/lib/Ouroboros/Network/Block.hs#L492-L495
