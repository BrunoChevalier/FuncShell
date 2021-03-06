module Main where

import ArgumentParser
import System.Environment
import System.Exit
import DefaultParser as DP
import TableParser as TP
import ExternalParser as EP

showHelp = 
  do 
    putStrLn "\nusage    : -h To get this help message."
    putStrLn "           -p <parser name> To choose your parser."
    putStrLn "           <your function> To use default parser.\n\n"
    putStrLn "examples : ps |fsh -p table \'filter (\\(pid:_)-> read pid > 9000)\'"
    putStrLn "           ls |fsh \'map(++\"append \")\'"

interpret parser function = 
  do
    bashInput <- getContents
    case parser of 
      "default"     -> DP.run function bashInput
      "table"       -> TP.run function bashInput
      parserModule  -> EP.run parserModule function bashInput

mapArgToIO :: Arguments -> IO ()
mapArgToIO argument = 
  case argument of 
    Arguments (Just H)  _  _ -> showHelp
    Arguments  (Just P) (Just parser) (Just function) -> interpret parser function
    Arguments Nothing Nothing (Just function) -> interpret "default" function
    _ -> putStrLn "Invalid arguments!" >> showHelp >> exitFailure

processArguments args = mapArgToIO (extractArguments args)

main = getArgs >>= processArguments
