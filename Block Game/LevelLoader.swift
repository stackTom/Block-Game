//
//  LevelLoader.swift
//  Block Game
//
//  Created by Zishi Wu on 1/26/16.
//  Copyright © 2016 Alfredo Terrero. All rights reserved.
//

import Foundation

enum EncodedTileDirections: Int {
    case Right = 0, Down, Left, Up
    
    var enumString: String {
        switch self {
        case .Up:
            return "u"
        case .Right:
            return "r"
        case .Down:
            return "d"
        case .Left:
            return "l"
        }
    }
}

/*
Reads a .lvl file line by line, where each line is a row of the gameboard.
Encoding for .lvl file is done using the constants in the class to determine which type of tile to
load. We specify direction in the level file as follows: encodedTileDirections.Up.enumString<R>,where
EncodedTileDirections.Up.enumString is any of the possible string representations of the encodedTileDirections enum,
and <R> is any tile which is a rotatable tile (or a subclass of rotatable tile)
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
        self.gameboard = Gameboard(rows: numRows, columns: lines.count, boardWidth: self.gameScene.size.width, boardHeight: self.gameScene.size.height)
        
        var currColumn = 0
        for line in lines {
            var currRow = 0
            var direction = TileDirection.Up
            
            for char in line.characters {
                let currentTile = self.gameboard.tiles[currColumn][currRow]
                let currentTileSprite = currentTile.sprite!
                let spriteName = String(currColumn) + ", " + String(currRow)
                
                // make sure we init the new tile with the posizion and size of the old tile
                switch String(char) {
                case LevelLoader.DEFAULT_TILE:
                    break
                case LevelLoader.ARROW_TILE:
                    self.gameboard.tiles[currColumn][currRow] = ArrowTile(column: currColumn, row: currRow, direction: direction, spritePosition: currentTileSprite.position, spriteSize: currentTileSprite.size, spriteName: spriteName)
                    break
                case LevelLoader.ROTATABLE_TILE:
                    self.gameboard.tiles[currColumn][currRow] = RotatableTile(column: currColumn, row: currRow, direction: direction, spritePosition: currentTileSprite.position, spriteSize: currentTileSprite.size, spriteName: spriteName)
                    break
                case LevelLoader.LAVA_TILE:
                    self.gameboard.tiles[currColumn][currRow] = LavaTile(column: currColumn, row: currRow, spritePosition: currentTileSprite.position, spriteSize: currentTileSprite.size, spriteName: spriteName)
                    break
                case LevelLoader.TELEPORTER_TILE:
                    self.gameboard.tiles[currColumn][currRow] = TeleporterTile(column: currColumn, row: currRow, spritePosition: currentTileSprite.position, spriteSize: currentTileSprite.size, spriteName: spriteName)
                    break
                case EncodedTileDirections.Up.enumString:
                    direction = TileDirection.Up
                    currRow--
                    break
                case EncodedTileDirections.Right.enumString:
                    direction = TileDirection.Right
                    currRow--
                    break
                case EncodedTileDirections.Down.enumString:
                    direction = TileDirection.Down
                    currRow--
                    break
                case EncodedTileDirections.Left.enumString:
                    direction = TileDirection.Left
                    currRow--
                    break
                default:
                    break // throw and/or print an error here
                }
                currRow++
            }
            currColumn++
        }
        
        return self.gameboard
    }
}