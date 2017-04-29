{-# LANGUAGE RecordWildCards #-}
module FireSimulator.Coordinate where

import FireSimulator.Types
import Data.Convertible
import qualified Data.Vector as V



-- | https://gis.stackexchange.com/a/2980
addOffset :: Double -> Double -> Coordinate -> Coordinate
addOffset x y (Coordinate lat lng) = Coordinate (lat + dLat*180.0/pi) (lng + dLng*180.0/pi)
    where
        earthRaius = 6378137.0

        dLat = x / earthRaius
        dLng = y / (earthRaius * (cos $ pi * lat / 180.0))



generateCoordinates :: Double -> Int -> Coordinate -> V.Vector (V.Vector Coordinate)
generateCoordinates offset max coord = V.fromList . map (\l -> V.fromList l) $ coordinates
    where
        initialCoord :: Coordinate
        initialCoord = addOffset (-(offset*convert max)) (-(offset*convert max)) coord

        genCoord :: Int -> Int -> Coordinate
        genCoord i j = addOffset (offset*convert i) (offset*convert j) initialCoord

        coordinates = map (\i -> map (genCoord i) [1..(2*max)]) [1..(2*max)]


defaultCoordinates :: Int -> V.Vector (V.Vector Coordinate)
defaultCoordinates n = generateCoordinates 10 n (Coordinate (-33.45) (-70.66609667))
