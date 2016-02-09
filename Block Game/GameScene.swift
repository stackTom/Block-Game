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
        self.addChild(self.character.sprite!)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch in touches {
            let position = touch.locationInView(self.view)
            let touchedNode = getTouchedNode(position)
            
            if let touchedSpriteName = touchedNode?.name {
                // touched the character
                if touchedSpriteName == self.character.sprite?.name {
                    self.characterIsSelected = true
                // touched a tile, so move the character there. but only do so if the tile is adjacent to the character's current tile
                } else if (self.characterIsSelected) {
                    if self.gameController.tile(gameBoard.tileFromName(touchedSpriteName)!, adjacentToTile: self.character.currentTile) {
                        character.moveTo(self.gameBoard.tileFromName(touchedSpriteName)!)
                        let pathAction = SKAction.moveTo((character.currentTile.sprite?.position)!, duration: 0.2)
                        self.character.sprite?.runAction(pathAction)
                        self.characterIsSelected = false
                        self.gameController.lastTouchedTile = self.character.currentTile
                    }
                }
            }
        }
    }
    
    // handle pan gestures
    func didPanOnTiles(gestureRecognizer: UIPanGestureRecognizer) {
        let position = gestureRecognizer.locationInView(self.view)
        
        // if the pan gesture is beginning, get the location at which it begins
        if (gestureRecognizer.state == UIGestureRecognizerState.Began) {
            self.panInitialTouchedNode = getTouchedNode(position)
        // if the pan gesture ended, move the tile to the current tile following the route the User made
        } else if (gestureRecognizer.state == UIGestureRecognizerState.Ended) {
            let touchedNode = getTouchedNode(position)
            
            // let us move the tile along the path, only if there are no errors (i.e. non adjacent consecutive tiles) on our path
            if (!self.gameController.pathHasError) {
                let lastTouchedTile = touchedNode?.name == self.character.sprite?.name ? self.character.currentTile : self.gameBoard.tileFromName((touchedNode?.name)!)
                
                // move the character
                self.character.moveTo(lastTouchedTile)
                
                // actually do the animation
                let path = CGPathCreateMutable()
                CGPathMoveToPoint(path, nil, (self.character.sprite?.position.x)!, (self.character.sprite?.position.y)!)
                
                for tile in self.gameController.panRoute {
                    CGPathAddLineToPoint(path, nil, (tile.sprite?.position.x)!, (tile.sprite?.position.y)!)
                }
                
                let pathAction = SKAction.followPath(path, asOffset: false, orientToPath: false, duration: 2.0)
                self.character.sprite?.runAction(pathAction)
                self.gameController.pathHasError = false;
            }
            
            // clear array path. done to reset the route so a new one can be constructed
            self.gameController.panRoute.removeAll()
            self.gameController.pathHasError = false
            self.gameController.lastTouchedTile = self.character.currentTile
            
        // otherwise, this method is called while the user is panning. In such a case, add the current tile being panned on to the "route" to be potentially followed
        // by the character sprite
        } else {
            let touchedNode = getTouchedNode(position)
            // sometimes the gesture recognizer recognizes the character and sometimes the sprite it is on. if it is the character, set it to the tile the character is currently on
            // this prevents a segmentation fault. we must call the tile from name in other cases as the gesture recognizer will only give the character when the user's finger is right
            // above the character tile (at the first instances of panning). after that, we can't use the character's current tile, as the character won't move to a new position
            // until after the drag gesture is done
            let lastTouchedTile = touchedNode?.name == self.character.sprite?.name ? self.character.currentTile : self.gameBoard.tileFromName((touchedNode?.name)!)
            self.gameController.addTileToPath(lastTouchedTile)
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
