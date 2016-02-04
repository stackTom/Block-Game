//
//  GameScene.swift
//  Block Game
//
//  Created by fery3 on 1/19/16.
//  Copyright (c) 2016 Alfredo Terrero. All rights reserved.
//

import SpriteKit

// TODO: need a way to determine if a sprite was touched or not. 
// we could use a dictionary with key = name of tile, and value is the tile object itself.
class GameScene: SKScene {
    static let NUM_ROWS = 5
    static let NUM_COLUMNS = 5
    var lastTouchNode: SKNode?
    
    // implicitly unwrapped optional doesn't have to be initialized. we can't pass self by calling the constructor here, and trying to override the default initializer
    // is a problem as we need to initialize class variables before calling super, yet we can't use self.
    // see: http://stackoverflow.com/questions/27028813/error-in-swift-class-property-not-initialized-at-super-init-call-how-to-initi
    var gameBoard: Gameboard!
    var character: Character!
    var levelLoader: LevelLoader!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.size = view.bounds.size
        
        lastTouchNode = nil
        
        // pan recognizer for selecting tiles with a pan
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: "didPanOnTiles:")
        self.view?.addGestureRecognizer(gestureRecognizer)
        self.levelLoader = LevelLoader(gameScene: self)
        self.gameBoard = levelLoader.loadLevel("test")
        let topLeftTile = self.gameBoard.tiles[0][0]
        // initialize character and shrink sprite to be half the tile size
        self.character = Character(column: 0, row: 0, currentTile: topLeftTile, spritePosition: topLeftTile.sprite!.position, spriteSize: topLeftTile.sprite!.size, spriteName: "character")
        self.character.sprite!.setScale(0.5)
        
        // add sprites to scene
        for tiles in self.gameBoard.tiles {
            for tile in tiles {
                self.addChild(tile.sprite!)
            }
        }
        self.addChild(character.sprite!)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch in touches {
            let position = touch.locationInView(self.view)
            self.handleTouches(position, canRepeatTouch: true)
        }
    }
    
    func didPanOnTiles(gestureRecognizer: UIPanGestureRecognizer) {
        let position = gestureRecognizer.locationInView(self.view)
        self.handleTouches(position, canRepeatTouch: false)
    }
    
    // handles sprite behavior (i.e. rotation, highlating) based on touch position
    func handleTouches(locationInView: CGPoint, canRepeatTouch: Bool) {
        // convert to the coord system of this scene class
        let convertedPosition = self.convertPointFromView(locationInView)
        let touchedSprite = self.nodeAtPoint(convertedPosition)
        
        // find the tile we are touching, if it is a rotatable tile
        if let touchedSpriteName = touchedSprite.name {
            // put character repositioning code here
            if touchedSpriteName == self.character.sprite?.name {
                
            } else if let touchedTile = self.gameBoard.tileFromName(touchedSpriteName) {
                self.character.moveTo(touchedTile)
                if let touchedTileRot = touchedTile as? RotatableTile {
                    // if repeat touches are allowed, simply rotate, else only rotate if we are touching a different node
                    if canRepeatTouch {
                        touchedTileRot.rotate()
                    } else if self.lastTouchNode !== touchedSprite {
                        touchedTileRot.rotate()
                    }
                }
            }
        }
        self.lastTouchNode = touchedSprite
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
