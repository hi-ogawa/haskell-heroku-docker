{-# LANGUAGE OverloadedStrings #-}
module Incrementer where

import Data.Maybe (fromJust)
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE
import Database.Redis
import Network.URI hiding (path)
import System.Environment (lookupEnv)
import System.IO.Unsafe (unsafePerformIO)

increment :: String -> IO Integer
increment key = do
  let keyBS = TE.encodeUtf8 . T.pack $ key
  conn <- connect redisConnection
  runRedis conn $ do
    Right b <- exists keyBS
    case b of
      True  -> do
        Right i <- incr keyBS
        return i
      False -> do
        set keyBS "1"
        return 1

redisConnection :: ConnectInfo
redisConnection =
  let redisUrl = unsafePerformIO $ fromJust <$> lookupEnv "REDIS_URL"
      Just (URI _ (Just (URIAuth up host port)) _ _ _) = parseURI redisUrl
      password = tail . init . snd . break (':' ==) $ up
      port' = read $ drop 1 port :: Int
  in
  defaultConnectInfo { connectHost = host
                     , connectPort = PortNumber $ toEnum port'
                     , connectAuth = Just $ (TE.encodeUtf8 . T.pack) password
                     }
