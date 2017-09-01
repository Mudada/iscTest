module Main where

import System.IO (hGetContents, openFile, IOMode(ReadMode))
import Text.ParserCombinators.Parsec (parse)
import Data.Either (rights)
import Parser
import Types (telephone, gTelephones)

main = do
    handle <- openFile "annuaireAnonyme.csv" ReadMode
    content <- hGetContents handle
    let splited = lines content
    let parsed = parse parseLine "error" <$> splited
    let cells = rights parsed
    let telephones = concat $ telephone <$> cells
    let gTels = gTelephones telephones
    let nbTels = length telephones
    let ratio = fromIntegral gTels / fromIntegral nbTels * 100
    putStrLn $ show gTels ++ " numero correctement formate parse sur " ++ show nbTels ++ " numero total."
    putStrLn $ "Soit " ++ show (100 - ratio) ++ "% de perte."
    -- mapM_ putStrLn $ show <$> parsed
    return ()
