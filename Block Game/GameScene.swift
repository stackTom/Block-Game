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
    static let NUM_ROWS = 10
    static let NUM_COLUMNS = 10
    
    // implicitly unwrapped optional doesn't have to be initialized. we can't pass self by calling the constructor here, and trying to override the default initializer
    // is a problem as we need to initialize class variables before calling super, yet we can't use self.
    // see: http://stackoverflow.com/questions/27028813/error-in-swift-class-property-not-initialized-at-super-init-call-how-to-initi
    var gameBoard: Gameboard!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.size = view.bounds.size
        
        self.gameBoard = Gameboard(rows: GameScene.NUM_ROWS, columns: GameScene.NUM_COLUMNS, gameScene: self)
        
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
            
            // print row and column numbers of tile
            print(touchedSprite.name )
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
