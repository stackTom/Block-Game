//
//  GameController.swift
//  Block Game
//
//  Created by fery3 on 2/8/16.
//  Copyright © 2016 Alfredo Terrero. All rights reserved.
//

import Foundation
import SpriteKit

// manage the state of the game as well as manage valid game moves
class GameController {
    var character: Character
    var gameboard: Gameboard
    var panRoute: [Tile]!
    var pathHasError = false
    var lastTouchedTile: Tile!
    
    init(character: Character, gameboard: Gameboard) {
        self.character = character
        self.gameboard = gameboard
        self.lastTouchedTile = self.character.currentTile
        panRoute = [Tile]()
    }
    
    // check if two tiles are adjacent
    func tile(tile1: Tile, adjacentToTile tile2: Tile) -> Bool {
        let tile1Row = tile1.row
        let tile2Row = tile2.row
        let tile1Column = tile1.column
        let tile2Column = tile2.column
        
        for var deltaX = -1; deltaX < 2; deltaX++ {
            for var deltaY = -1; deltaY < 2; deltaY++ {
                if tile2Row + deltaX == tile1Row && tile2Column + deltaY == tile1Column {
                    return true
                }
            }
        }
        
        return false
    }
    
    // add a tile to the tile array to construct the path created by the user panning
    func addTileToPath(tile: Tile) {
        if self.tile(tile, adjacentToTile: self.lastTouchedTile) {
            panRoute.append(tile)
            self.lastTouchedTile = tile
        } else {
            pathHasError = true
        }
    }
}