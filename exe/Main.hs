module Main where

import           Animal (Animal(..))
import qualified Animal
import qualified Lib
import           Shape (Shape(..))
import qualified Shape

animalFile :: FilePath
animalFile = "animals.cbor"

fredTheFrog :: Animal
fredTheFrog = HoppingAnimal "Fred" 4

shapeFile :: FilePath
shapeFile = "shapes.cbor"

main :: IO ()
main = do
  Lib.write animalFile fredTheFrog
  a <- Animal.read animalFile
  print a
  Lib.write shapeFile (Circle 1.5)
  s <- Shape.read shapeFile
  print s
