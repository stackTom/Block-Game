//
//  GameScene.swift
//  Block Game
//
//  Created by fery3 on 1/19/16.
//  Copyright (c) 2016 Alfredo Terrero. All rights reserved.
//

import SpriteKit

// TODO: need a way to determine if a sprite was touched or not. we could use a dictionary with key = name of tile, and value is the tile object itself.
class GameScene: SKScene {
    static let NUM_ROWS = 3
    static let NUM_COLUMNS = 3
    
    var tiles: [[Tile]] = [[Tile]]()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.size = view.bounds.size
        
        // set up tiles Array
        
        for var column = 0; column < GameScene.NUM_COLUMNS; column++ {
            let tileRow = [Tile]()
            tiles.append(tileRow)
            for var row = 0; row < GameScene.NUM_ROWS; row++ {
                tiles[column].append(Tile(column: column, row: row, direction: .Up))
                let xCoord = CGFloat(row) * self.size.width / 3.0 + 60.0
                let yCoord = CGFloat(column) * self.size.height / 3.0 + 60.0
                let position = CGPointMake(xCoord, yCoord)
                
                let tileSprite = tiles[column][row].sprite!
                
                // name = row, column to identify sprite at specific location
                tileSprite.name = String(row) + ", " + String(column)
                
                //tileSprite.size = CGSizeMake(CGFloat(50.0), CGFloat(50.0))
                tileSprite.position = position
                // add sprite
                self.addChild(tileSprite)
                print("added \(column) \(row) at \(position)")
            }
        }
        
        // pan recognizer for selecting tiles with a pan
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: "didPanOnTiles:")
        self.view?.addGestureRecognizer(gestureRecognizer)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch in touches {
            let position = touch.locationInView(self.view)
            
            // convert to the coord system of this scene class
            let convertedPosition = self.convertPointFromView(position)
            let touchedSprite = self.nodeAtPoint(convertedPosition)
            
            
            print(touchedSprite.name)
        }
    }
    
    func didPanOnTiles(gestureRecognizer: UIPanGestureRecognizer) {
        let position = gestureRecognizer.locationInView(self.view)
        let convertedPosition = self.convertPointFromView(position)
        let touchedSprite = self.nodeAtPoint(convertedPosition)
        
        print(touchedSprite.name)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
