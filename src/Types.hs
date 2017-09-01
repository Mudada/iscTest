module Types
(Line,
 Telephone (Telephone),
 Cell (T, SF, Empty),
 telephone,
 gTelephones,
 completeNumber
) where

type Line = [Cell]

data Telephone = Telephone { indicatif :: [Int],
                             numero :: [Int]
                           } deriving (Show, Eq)

data Cell = T Telephone | SF String | Empty
    deriving (Show, Eq)

completeNumber :: Telephone -> Bool
completeNumber t = length (numero t) == 10 
                && head (numero t) == 0

clunckyNumber :: Telephone -> Bool
clunckyNumber t = length (numero t) == 9

goodIndicatif :: Telephone -> Bool
goodIndicatif t = length (indicatif t) == 2

igTelephone :: Telephone -> Bool
igTelephone t = completeNumber t || goodIndicatif t && clunckyNumber t

telephone :: Line -> [Telephone]
telephone [] = []
telephone ((T x):xs) = [x]
telephone (x:xs) = telephone xs

gTelephones :: [Telephone] -> Int
gTelephones ts = foldl (flip ((+) . fromEnum)) 0 $ igTelephone <$> ts


