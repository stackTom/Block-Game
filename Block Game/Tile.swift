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
    
    var sprite: SKSpriteNode?
    
    // shortens retrieval of name from tile.direction.spriteName to tile.spriteName
    // is this line of code necessary?
    var spriteName: String {
        return "blank tile"
    }

    // return description of tile: direction, column, row
    var description: String {
        return "blank tile: [\(column), \(row)]"
    }
    
    // initialize tile, default direction is Right = 0 and cannot rotate
    init(column:Int, row:Int) {
        self.column = column
        self.row = row
        
        self.sprite = SKSpriteNode(imageNamed: "blank_tile")
    }
    
    convenience init(column: Int, row: Int, spritePosition: CGPoint, spriteSize: CGSize, spriteName: String) {
        self.init(column: column, row: row)
        self.sprite?.position = spritePosition
        self.sprite?.size = spriteSize
        self.sprite?.name = spriteName
    }
}

class ArrowTile: Tile {
    var direction: TileDirection
    
    // init to up arrow by default
    init(column: Int, row: Int, direction: TileDirection) {
        self.direction = direction
        super.init(column: column, row: row)
        self.sprite = SKSpriteNode(imageNamed: self.spriteName)
    }
    
    convenience init(column: Int, row: Int, direction: TileDirection, spritePosition: CGPoint, spriteSize: CGSize, spriteName: String) {
        self.init(column: column, row: row, direction: direction)
        self.sprite?.position = spritePosition
        self.sprite?.size = spriteSize
        self.sprite?.name = spriteName
    }
    
    override var spriteName: String {
        return self.direction.spriteName + "_tile"
    }
    
    override var description: String {
        return "\(self.direction): [\(column), \(row)]"
    }
}

class RotatableTile: ArrowTile {
    
    // rotate right by 90 degrees
    func rotate() {
        // get the new direction and convert it to raw value
        self.direction = TileDirection(rawValue: (self.direction.rawValue + 1) % Tile.NUM_DIRECTIONS)!
        
        // set the new texture of the sprite
        self.sprite?.texture = SKTexture(imageNamed: self.spriteName)
    }
}

class LavaTile: Tile {
    override init(column: Int, row: Int) {
        super.init(column: column, row: row)
        self.sprite = SKSpriteNode(imageNamed: "lava_tile")
    }
}

class TeleporterTile: Tile {
    override init(column: Int, row: Int) {
        super.init(column: column, row: row)
        self.sprite = SKSpriteNode(imageNamed: "teleporter_tile")
    }
}

