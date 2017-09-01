module Parser
(parseLine,
 perfectTel,
 clunkyTel,
 parseTel,
 tel,
 ws,
 parseSF,
 sf,
 sep,
 empty,
 parseCell
) where

import Types
import Data.Char (digitToInt)
import Text.ParserCombinators.Parsec (many, parse, noneOf, oneOf, space, many1, char, choice, try, digit)
import Text.Parsec ((<|>)) 
import Text.Parsec.String (Parser)
import Data.List.Split (splitOn)

perfectTel :: Parser Telephone
perfectTel = do
    ws
    char '+'
    number <- many1 $ oneOf "1234567890" <* ws
    let (f:s:num) = digitToInt <$> number
    return $ Telephone [f,s] num

clunkyTel :: Parser Telephone
clunkyTel = do
    ws
    number <- many1 $ oneOf "1234567890.-" <* ws
    let num = digitToInt <$> filter (`notElem` ".-") number
    case num of x:y:xs |length num == 11 -> return $ Telephone [x,y] xs
                _ -> return $ Telephone [-1] num

parseTel :: Parser Telephone
parseTel = try perfectTel <|> try clunkyTel

tel :: Parser Cell
tel = fmap T $ parseTel

ws :: Parser String
ws = many space

parseSF :: Parser String
parseSF = do
    ws
    s <- noneOf " \n,"
    sf <- many $ noneOf ",\n"
    return $ s:sf

sf :: Parser Cell
sf = SF <$> parseSF

sep :: Parser Char
sep = char ','

empty :: Parser Cell
empty = ws *> pure Empty

parseCell :: Parser Cell
parseCell = choice $ try <$> [tel, sf, empty]

parseLine :: Parser Line
parseLine = do
    ln <- parseCell
    sep
    fn <- parseCell
    sep
    s <- parseCell
    sep
    t <- parseCell
    sep    
    f <- parseCell
    sep
    s <- parseCell
    return [ln, fn, s, t, f, s]
