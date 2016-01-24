//
//  Gameboard.swift
//  Block Game
//
//  Created by fery3 on 1/23/16.
//  Copyright © 2016 Alfredo Terrero. All rights reserved.
//

import Foundation
import SpriteKit

class Gameboard {
    var tiles: [[Tile]] = [[Tile]]()
    
    init(rows: Int, columns: Int, gameScene: GameScene) {
        // set up tiles Array
        for var column = 0; column < columns; column++ {
            let tileRow = [Tile]()
            tiles.append(tileRow)
            for var row = 0; row < rows; row++ {
                tiles[column].append(Tile(column: column, row: row, direction: .Up))
                var xCoord: CGFloat = CGFloat(0.0)
                var yCoord: CGFloat = CGFloat(0.0)
                
                if row == 0 {
                    xCoord = gameScene.size.width / 6.0 + 10.0
                    
                    if column == 0 {
                        yCoord = gameScene.size.height / 3.0 + 60.0
                    } else {
                        if let tileSprite = tiles[column - 1][row].sprite {
                            yCoord = tileSprite.position.y + tileSprite.size.height
                        }
                    }
                } else {
                    xCoord = tiles[column][row - 1].sprite!.position.x + tiles[column][row - 1].sprite!.size.width
                    yCoord = tiles[column][row - 1].sprite!.position.y
                }
                let position = CGPointMake(xCoord, yCoord)
                
                if let tileSprite = tiles[column][row].sprite {
                    // name = row, column to identify sprite at specific location
                    tileSprite.name = String(row) + ", " + String(column)
                    
                    tileSprite.size = CGSizeMake(CGFloat(20.0), CGFloat(20.0))
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