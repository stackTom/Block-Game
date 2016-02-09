//
//  GameController.swift
//  Block Game
//
//  Created by fery3 on 2/8/16.
//  Copyright © 2016 Alfredo Terrero. All rights reserved.
//

import Foundation

// manage the state of the game as well as manage valid game moves
class GameController {
    var character: Character
    var gameboard: Gameboard
    
    init(character: Character, gameboard: Gameboard) {
        self.character = character
        self.gameboard = gameboard
    }
    
    func tileAdjacent(tile1: Tile, toTile tile2: Tile) -> Bool {
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
    
    func moveCharacterToTile(tile: Tile) {
        if self.tileAdjacent(tile, toTile: self.character.currentTile) {
            self.character.moveTo(tile)
        }
    }
}