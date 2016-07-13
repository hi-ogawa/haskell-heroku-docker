{-# LANGUAGE OverloadedStrings #-}
module App where

import Data.Aeson
import System.Environment (lookupEnv)
import qualified Web.Scotty as S

main :: IO ()
main = do
  Just port <- lookupEnv "PORT"
  S.scotty (read port) app

app :: S.ScottyM ()
app = do
  S.get (S.regex ".*") $ do
    path <- S.param "0"
    S.json $ object [ "status" .= ("ok" :: String)
                    , "path" .= (path :: String)
                    ]
