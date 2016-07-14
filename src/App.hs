{-# LANGUAGE OverloadedStrings #-}
module App where

import Data.Aeson
import System.Environment (lookupEnv)
import qualified Web.Scotty as S

import Incrementer (increment)

main :: IO ()
main = do
  Just port <- lookupEnv "PORT"
  S.scotty (read port) app

app :: S.ScottyM ()
app =
  S.get (S.regex ".*") $ do
    path <- S.param "0"
    count <- S.liftAndCatchIO $ increment path
    S.json $ object [ "status" .= ("ok" :: String)
                    , "path" .= (path :: String)
                    , "visitCount" .= count
                    ]
