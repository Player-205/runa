module Shell where


import System.Process.Typed

type CommandPart = String
type Command = String

futhark  = "futhark"
cuda     = "cuda"
pureC    = "c"
repl     = "repl"
sep      = "|"

run :: [CommandPart] -> IO ()
run = runShell . unwords

runShell :: Command -> IO ()
runShell = runProcess_ . shell