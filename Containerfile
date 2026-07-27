FROM haskell

WORKDIR /opt/sandbox

RUN cabal update

COPY ./sandbox.cabal .
RUN cabal build --only-dependencies -j4

COPY . .
RUN cabal install

CMD ["sandbox"]
