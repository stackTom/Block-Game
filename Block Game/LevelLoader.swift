//
//  LevelLoader.swift
//  Block Game
//
//  Created by Zishi Wu on 1/26/16.
//  Copyright © 2016 Alfredo Terrero. All rights reserved.
//

import Foundation

/*
Reads a .lvl file line by line, where each line is a row of the gameboard.
Encoding for level file is done using the constants in the class to determine which type of tile to load
*/

class LevelLoader {
    // encoding characters for the type of tile
    static let DEFAULT_TILE = "D"
    static let ARROW_TILE = "A"
    static let ROTATABLE_TILE = "R"
    static let LAVA_TILE = "L"
    static let TELEPORTER_TILE = "T"
    
    static let LEVEL_EXTENSION = ".lvl"
    
    var gameboard: Gameboard!
    let mainBundle: NSBundle
    var gameScene: GameScene
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        self.gameboard = nil
        self.mainBundle = NSBundle.mainBundle()
    }
    
    func loadLevel(levelName: String) -> Gameboard {
        let filePath = self.mainBundle.pathForResource("/levels/" + levelName, ofType: LevelLoader.LEVEL_EXTENSION)
        var lines = [String]()
        
        if let streamReader = StreamReader(path: filePath!) {
            defer {
                streamReader.close()
            }
            
            // put the lines in our array so we can create the gameboard of appropriate size
            for line in streamReader {
                lines.append(String(line))
            }
        }
        let numRows = lines[0].characters.count
        self.gameboard = Gameboard(rows: numRows, columns: lines.count, gameScene: self.gameScene)
        
        for line in lines {
            for char in line.characters {
                switch String(char) {
                case LevelLoader.DEFAULT_TILE:
                    break
                case LevelLoader.ARROW_TILE:
                    break
                case LevelLoader.ROTATABLE_TILE:
                    break
                case LevelLoader.LAVA_TILE:
                    break
                case LevelLoader.TELEPORTER_TILE:
                    break
                default:
                    break // throw and/or print an error here
                }
            }
        }
        
        return self.gameboard
    }
}