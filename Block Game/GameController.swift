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
    
    // add a tile to the tile array to construct the path created by the user panning
    func addTileToPath(tile: Tile) {
        if self.tileAdjacent(tile, toTile: self.lastTouchedTile) {
            panRoute.append(tile)
            self.lastTouchedTile = tile
            print("no error")
        } else {
            pathHasError = true
            print("error")
        }
    }
    
    // move the character to a tile. this is intended to be used without panning and only moves the tile once
    // TODO: add if to make sure tile is adjacent to current tile
    func moveCharacterToTile(tile: Tile) {
        self.character.moveTo(tile)
        let moveAction = SKAction.moveTo(tile.sprite!.position, duration: 0.5)
        self.character.sprite!.runAction(moveAction)
    }
    
    // animates the movemenet of the tile along the constructed tile path given by the tile array
    // only does this if there is no error (i.e., the path is constructed with tiles n, n + 1, n + 2... such that each successive
    // n is adjacent to the n before it
    func moveCharacterToTileAlongPath(tile: Tile) {
        if (!pathHasError) {
            self.character.moveTo(tile)
            
            // do the animation
            let path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, (self.character.sprite?.position.x)!, (self.character.sprite?.position.y)!)
            
            for tile in panRoute {
                CGPathAddLineToPoint(path, nil, (tile.sprite?.position.x)!, (tile.sprite?.position.y)!)
            }
            
            let pathAction = SKAction.followPath(path, asOffset: false, orientToPath: false, duration: 2.0)
            print("before \(self.character.sprite!.position)")
            self.character.sprite?.runAction(pathAction)
            self.lastTouchedTile = tile
            pathHasError = false;
            
            // clear array path
            self.panRoute.removeAll()
        }
    }
}