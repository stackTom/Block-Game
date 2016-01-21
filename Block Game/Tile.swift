//
//  Tile.swift
//  Block Game
//
//  Created by Zishi Wu on 1/21/16.
//  Copyright © 2016 Alfredo Terrero. All rights reserved.
//

import SpriteKit

enum TileDirection: Int, CustomStringConvertible {
    
    // enum identification: right = 0, down = 1, left = 2, up = 3
    case Right = 0, Down, Left, Up
    
    // return filename matching direction
    // need to get sprite file for each direction
    var spriteName: String {
        switch self {
        case .Up:
            return "up"
        case .Right:
            return "right"
        case .Down:
            return "down"
        case .Left:
            return "left"
        }
    }
    // return tile direction
    var description: String {
        return self.spriteName
    }
    
}

// by default, regular tiles aren't rotatable
class Tile: CustomStringConvertible {
    static let NUM_DIRECTIONS = 4
    
    // Properties of a tile
    var column: Int
    var row: Int
    var direction: TileDirection
    var sprite: SKSpriteNode?
    
    // shortens retrieval of name from tile.direction.spriteName to tile.spriteName
    var spriteName: String {
        return direction.spriteName
    }

    // return description of tile: direction, column, row
    var description: String {
        return "\(direction): [\(column), \(row)]"
    }
    
    // initialize tile, default direction is Right = 0 and cannot rotate
    init(column:Int, row:Int, direction: TileDirection) {
        self.column = column
        self.row = row
        self.direction = .Right
        
        self.sprite = SKSpriteNode(imageNamed: "Spaceship")
    }
    
    // I initialize direction to right, but if user taps rotatable tile, it needs 
    // to change direction - rotatable tile subclass
    
    // Make subclasses of rotatable, non-rotatable, and teleporting tiles
    
    
    // There are tiles that can be rotated and tiles that cannot be rotated
    // Non-rotatable tiles are loaded at the start of the game
    // Rotatable tiles are the ones that user places on the existing grid
    // Cannot place tiles on top of each other
    // Then there will be some spots on grid where you can't place tile on
    // no class for teleporting as it is not changing something internal to itself
    
    
    // After user places a tile on the grid, if the tile can be rotated,
    // then when the user taps the tile, rotate 90 degrees clockwise
    // So if default direction is .Right, one tap turns tile to .Down direction
}

class RotatableTile: Tile {
    
    // rotate right by 90 degrees
    func rotate() {
        // get the new direction and convert it to raw value
        self.direction = TileDirection(rawValue: (self.direction.rawValue + 1) % Tile.NUM_DIRECTIONS)!
    }
}

