{-# LANGUAGE OverloadedStrings #-}
module Main where


import System.Environment
import System.Process.Typed
import Control.Monad
import Text.Printf
import Data.String

type Arg = String
type CommandPart = String
type Command = String

futhark       = "futhark"
cuda          = "cuda"
pureC         = "c"
repl          = "repl"
entryPoint    = "./main.fut"
sep           = "|"
libraryPath   = "LIBRARY_PATH=/usr/local/cuda-11.4/lib64"
ldLibraryPath = "LD_LIBRARY_PATH=/usr/local/cuda-11.4/lib64/"
cpath         = "CPATH=/usr/local/cuda-11.4/include"

main :: IO ()
main = do
  (command:args) <- getArgs
  case command of
    "build" -> build args
    "run"   -> run ["echo", unwords args, sep, "./main"] 
    "repl"  -> run [futhark, repl]
      

build :: [Arg] -> IO ()
build ("cuda":args) = run [libraryPath, ldLibraryPath, cpath, futhark, cuda, unwords args, entryPoint]
build args          = run [futhark, pureC, unwords args, entryPoint]

run :: [CommandPart] -> IO ()
run = runShell . unwords

runShell :: Command -> IO ()
runShell = runProcess_ . shell