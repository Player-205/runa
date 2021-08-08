module Build where


import Data.YAML
import Data.ByteString.Lazy qualified as BS
import Data.Text qualified as T
import Config
import Shell
import Data.Foldable
import System.FilePath
import System.Directory

build args = do
  raw <- BS.readFile "package.yaml"
  case decode1 raw of
    Left (loc, err) ->
      putStrLn ("package.yaml" ++ ":" ++ prettyPosWithSource loc raw " error" ++ err)
    Right (Config cuda entryPoint') -> do
      let entryPoint = T.unpack entryPoint'
      let binary = "." </> "build" </> takeBaseName entryPoint
      createDirectoryIfMissing False ("build")
      case args of 
        ("cuda":args) -> buildCuda cuda binary args entryPoint
        _ -> defaultBuild binary args entryPoint

defaultBuild binary (opt:args) entryPoint = run [futhark, opt, "-o", binary, unwords args, entryPoint]

buildCuda Nothing binary args entryPoint = defaultBuild binary (cuda:args) entryPoint
buildCuda (Just cudaPath) binary args entryPoint = run [makePathToCuda (T.unpack cudaPath), futhark, cuda, "-o", binary, unwords args, entryPoint]


makePathToCuda cuda = fold 
  [ "LIBRARY_PATH=", cuda, "/lib64 "
  , "LD_LIBRARY_PATH=",cuda, "/lib64/ "
  , "CPATH=", cuda, "/include"
  ]
