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
    var panInitialTouchedNode: SKNode?
    
    // implicitly unwrapped optional doesn't have to be initialized. we can't pass self by calling the constructor here, and trying to override the default initializer
    // is a problem as we need to initialize class variables before calling super, yet we can't use self.
    // see: http://stackoverflow.com/questions/27028813/error-in-swift-class-property-not-initialized-at-super-init-call-how-to-initi
    var gameBoard: Gameboard!
    var character: Character!
    var levelLoader: LevelLoader!
    var characterIsSelected = false
    var gameController: GameController!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.size = view.bounds.size
        
        lastTouchNode = nil
        panInitialTouchedNode = nil
        
        // pan recognizer for selecting tiles with a pan
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: "didPanOnTiles:")
        self.view?.addGestureRecognizer(gestureRecognizer)
        self.levelLoader = LevelLoader(gameScene: self)
        self.gameBoard = levelLoader.loadLevel("test")
        let topLeftTile = self.gameBoard.tiles[0][0]
        // initialize character and shrink sprite to be half the tile size
        self.character = Character(column: 0, row: 0, currentTile: topLeftTile, spritePosition: topLeftTile.sprite!.position, spriteSize: topLeftTile.sprite!.size, spriteName: "character")
        self.character.sprite!.setScale(0.5)
        self.gameController = GameController(character: self.character, gameboard: self.gameBoard)
        
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
            let touchedNode = getTouchedNode(position)
            
            if let touchedSpriteName = touchedNode?.name where touchedNode !== character.sprite {
                gameController.moveCharacterToTileAlongPath(self.gameBoard.tileFromName(touchedSpriteName)!)
            }
        }
    }
    
    // handle pan gestures
    func didPanOnTiles(gestureRecognizer: UIPanGestureRecognizer) {
        let position = gestureRecognizer.locationInView(self.view)
        
        // if the pan gesture is beginning, get the location at which it begins
        if (gestureRecognizer.state == UIGestureRecognizerState.Began) {
            self.panInitialTouchedNode = getTouchedNode(position)
        // if the pan gesture ended, move the tile to the current tile after the pan has ended
        } else if (gestureRecognizer.state == UIGestureRecognizerState.Ended) {
            let touchedNode = getTouchedNode(position)
            
            // but only do so if we began the pan gesture touching the character tile or the tile on which the character tile is originally on
            if let touchedSpriteName = touchedNode?.name where (self.panInitialTouchedNode!.name! == character.currentTile.description || self.panInitialTouchedNode?.name == character.sprite?.name) {
                gameController.moveCharacterToTileAlongPath(self.gameBoard.tileFromName(touchedSpriteName)!)
            }
        // otherwise, this method is called while the user is panning. In such a case, add the current tile being panned on to the "route" to be potentially followed
        // by the character sprite
        } else {
            let tile = self.gameBoard.tileFromName((getTouchedNode(position)?.name)!)
            self.gameController.addTileToPath(tile!)
        }
    }
    
    // handles sprite behavior (i.e. rotation, highlating) based on touch position
    func getTouchedNode(locationInView: CGPoint) -> SKNode? {
        // convert to the coord system of this scene class
        let convertedPosition = self.convertPointFromView(locationInView)
        let touchedSprite = self.nodeAtPoint(convertedPosition)
        self.lastTouchNode = touchedSprite
        
        return touchedSprite
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
