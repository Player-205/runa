
module Config where



import Data.YAML
import Data.Text




data Config = Config 
  { cudaDir :: Maybe Text
  , mainIs  :: Text
  }
  deriving (Show)

instance FromYAML Config where
  parseYAML = withMap "Config" $ \m -> Config
    <$> m .:? "cuda-path"
    <*> m .: "main"

instance ToYAML Config where
  toYAML (Config Nothing main) = mapping ["main" .= main]
  toYAML (Config cuda main)    = mapping [ "cuda-path" .= cuda, "main" .= main]


defaultConfig = Config 
  { cudaDir = Nothing
  , mainIs = "app/main.fut" 
  }