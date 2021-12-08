import Data.List (sort,permutations)
import Data.Map (Map)
import qualified Data.Map as Map
import Debug.Trace(trace)

initSame [] _ = True
initSame _ [] = False
initSame (a:r1) (b:r2)
    | a == b = initSame r1 r2
    | otherwise = False

split sep str =
    let 
        hsplit _ [] acc = [reverse acc]
        hsplit sep str acc
            | initSame sep str = (reverse acc) : (hsplit sep (drop (length sep) str) [])
            | otherwise = hsplit sep (tail str) ((head str) : acc)
    in
         hsplit sep str [] 

decode "abcefg"  = Just 0
decode "cf"      = Just 1
decode "acdeg"   = Just 2
decode "acdfg"   = Just 3
decode "bcdf"    = Just 4
decode "abdfg"   = Just 5
decode "abdefg"  = Just 6
decode "acf"     = Just 7
decode "abcdefg" = Just 8
decode "abcdfg"  = Just 9
decode _ = Nothing

translate dic str = map (\c -> (Map.!) dic c) str

bruteforce (sol:rest) input
    | done = dic
    | otherwise = bruteforce rest input
    where
        done = filter (==Nothing) decodings == []
        score = length $ filter (/= Nothing) decodings
        decodings = map decode sortedTran
        sortedTran = map sort translations
        translations = map (translate dic) input
        dic = Map.fromList (zip "abcdefg" sol)

solve (unsortedInput:unsortedOutput:[]) =
    let
        input = sort (map sort unsortedInput)
        output = map sort unsortedOutput
        dic = bruteforce (permutations "abcdefg") input
    in
        read (concat $ map ((\(Just x)->show x) . decode . sort . translate dic) output) :: Int

main = do
    input <- readFile "input.txt"
    let signals = map (map (split " ")) (map (split " | ") (lines input))
    
    -- part 1
    let outputs = map (\(a:b:[]) -> b) signals
    let allOutputs = concat outputs
    let partOne = filter (\l -> length l `elem` [2,3,4,7]) allOutputs
    print (length partOne)

    -- part 2
    let solved = map solve signals
    print $ sum solved