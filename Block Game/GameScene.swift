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
    var lastTouchNode: SKNode!
    
    // implicitly unwrapped optional doesn't have to be initialized. we can't pass self by calling the constructor here, and trying to override the default initializer
    // is a problem as we need to initialize class variables before calling super, yet we can't use self.
    // see: http://stackoverflow.com/questions/27028813/error-in-swift-class-property-not-initialized-at-super-init-call-how-to-initi
    var gameBoard: Gameboard!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.size = view.bounds.size
        
        self.gameBoard = Gameboard(rows: GameScene.NUM_ROWS, columns: GameScene.NUM_COLUMNS, gameScene: self)
        lastTouchNode = nil
        
        // pan recognizer for selecting tiles with a pan
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: "didPanOnTiles:")
        self.view?.addGestureRecognizer(gestureRecognizer)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch in touches {
            let position = touch.locationInView(self.view)
            self.handleTouches(position)
        }
    }
    
    func didPanOnTiles(gestureRecognizer: UIPanGestureRecognizer) {
        let position = gestureRecognizer.locationInView(self.view)
        self.handleTouches(position)
    }
    
    // handles sprite behavior (i.e. rotation, highlating) based on touch position
    func handleTouches(locationInView: CGPoint) {
        // convert to the coord system of this scene class
        let convertedPosition = self.convertPointFromView(locationInView)
        let touchedSprite = self.nodeAtPoint(convertedPosition)
        
        // find the tile we are touching, if it is a rotatable tile
        if let touchedSpriteName = touchedSprite.name {
            if let touchedTile = self.gameBoard.tileFromName(touchedSpriteName) {
                if let touchedTileRot = touchedTile as? RotatableTile {
                    if self.lastTouchNode !== touchedSprite {
                        self.lastTouchNode = touchedSprite
                        touchedTileRot.rotate()
                    }
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
