
module Main where


import System.Environment
import System.Process.Typed
import Control.Monad
import Text.Printf
import Data.String
import System.Directory
import Data.ByteString qualified as BS

import CreateProject
import Shell
import Build



main :: IO ()
main = do
  commands <- getArgs
  case commands of
    ["new", name]  -> createProject name
    ("build":args) -> build args
    ("run"  :args) -> run ["echo", unwords args, sep, "./build/main"] 
    ["repl"]       -> run [futhark, repl]




