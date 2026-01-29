module Main where

import           Animal (Animal(..))
import qualified Animal
import qualified Lib
import           Shape  (Shape(..))
import qualified Shape

animalFile, shapeFile, animalEmbeddedFile, shapeEmbeddedFile :: FilePath

animalFile         = "animals.cbor"
shapeFile          = "shapes.cbor"
animalEmbeddedFile = "animals-embed.cbor"
shapeEmbeddedFile  = "shapes-embed.cbor"

fredTheFrog :: Animal
fredTheFrog = HoppingAnimal "Fred" 4

main :: IO ()
main = do
  Lib.write animalFile fredTheFrog
  a <- Animal.read animalFile
  print a
  Lib.write shapeFile (Circle 1.5)
  s <- Shape.read shapeFile
  print s
  Lib.write animalEmbeddedFile (Animal.SA a)
  sa <- Animal.readS animalEmbeddedFile
  print sa
