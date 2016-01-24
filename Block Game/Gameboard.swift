//
//  Gameboard.swift
//  Block Game
//
//  Created by fery3 on 1/23/16.
//  Copyright © 2016 Alfredo Terrero. All rights reserved.
//

import Foundation
import SpriteKit

// Tried printing out board height, width versus spriteHeight, width to figure it out 
// problem with tile size but the ratio is good...something with code implementation
// or tile size is too small?
class Gameboard {
    
    var tiles: [[Tile]] = [[Tile]]()
    var tileNameToTile = [String: Tile]()
    
    init(rows: Int, columns: Int, gameScene: GameScene) {
        
        // Bottom (y = 0) so put board start at top
        let boardHeight = gameScene.size.height
        print("Board Height: \(boardHeight)")
        
        // Left (x = 0) so put board start at left
        let boardWidth =  gameScene.size.width
        print("Board Width: \(boardWidth)")
        
        // Adjust tileSprite size to fit into board depending on number of tiles
        let spriteHeight = CGFloat(0.75) * boardHeight / CGFloat(columns)
        let spriteWidth = CGFloat(0.75) * boardWidth / CGFloat(rows)
        print("Space Height: \(spriteHeight)")
        print("Space Width: \(spriteWidth)")
        
        
        // initialize coordinates for center of each tile in board in CGFloat type
        var xCoord: CGFloat = CGFloat(0.0)
        var yCoord: CGFloat = CGFloat(0.0)
        
        // coordinates for center of each tile in double to be converted to CGFloat
        // 0, 0 is bottom left so x = 0, y = boardHeight = top left
        // increment x a little to the right and decrement y a little downwards
        let xDouble = spriteWidth/2.0
        let yDouble = boardHeight - spriteHeight/2.0
        
        // set up tiles Array a.k.a. game board
        for var column = 0; column < columns; column++ {
            let tileRow = [Tile]()
            tiles.append(tileRow)
            
            // initialize or update value of yCoor 
            // since we start at top of screen, to populate tiles downwards, decrement by spriteHeight
            if column == 0 {
                yCoord = CGFloat(yDouble)
            } else {
                yCoord -= spriteHeight
            }
            
            for var row = 0; row < rows; row++ {
                // add a new tile to specific row, column
                let newTile = Tile(column: column, row: row, direction: .Up)
                tiles[column].append(newTile)
                
                // initialize or update value of xCoor 
                // since we start at left of screen, to populate tiles to the right, increment by spriteWidth
                if row == 0 {
                    xCoord = CGFloat(xDouble)
                } else {
                    // for some reason this spacing is bigger than the actual sprite image so it 
                    // causes empty nil space between the tiles...
                    xCoord += spriteWidth
                    
                    // this works but can't be guaranteed for all iPhones
                    // xCoord += 20.0
                }
                
                let position = CGPointMake(xCoord, yCoord)
                
                if let tileSprite = tiles[column][row].sprite {
                    // name = row, column to identify sprite at specific location
                    let tileName = String(column) + ", " + String(row)
                    self.tileNameToTile[tileName] = newTile
                    tileSprite.name = tileName
                    
                    tileSprite.size = CGSizeMake(spriteWidth, spriteHeight)
                    tileSprite.position = position
                    
                    // add sprite
                    gameScene.addChild(tileSprite)
                    print("added \(column) \(row) at \(position)")
                }
            }
        }
        tiles[0][1] = RotatableTile(column: 0, row: 1, direction: .Up)
        
    }
}