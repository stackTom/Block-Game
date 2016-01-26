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
    
    let gameboard: Gameboard
    let mainBundle: NSBundle
    
    init(gameboard: Gameboard) {
        self.gameboard = gameboard
        self.mainBundle = NSBundle.mainBundle()
    }
    
    func loadLevel(levelName: String) {
        let filePath = self.mainBundle.pathForResource("/levels/" + levelName, ofType: LevelLoader.LEVEL_EXTENSION)
        
        if let streamReader = StreamReader(path: filePath!) {
            defer {
                streamReader.close()
            }
            
            for line in streamReader {
                for character in line.characters {
                    // add switch and load in tiles into gameboard using the constants defined above
                }
            }
        }
    }
}