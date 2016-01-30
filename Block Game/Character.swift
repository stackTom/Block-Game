//
//  Character.swift
//  Block Game
//
//  Created by Zishi Wu on 1/29/16.
//  Copyright © 2016 Alfredo Terrero. All rights reserved.
//

import SpriteKit

// by default, regular tiles aren't rotatable
class Character: CustomStringConvertible {
    
    // Properties of a character
    var column: Int
    var row: Int
    
    var sprite: SKSpriteNode?
    
    // shortens retrieval of name from character.direction.spriteName to tile.spriteName
    var spriteName: String {
        return "character"
    }
    
    // return description of character: column, row
    var description: String {
        return "character: [\(column), \(row)]"
    }
    
    // initialize character: we will test with starting point at 0,0
    init(column:Int, row:Int) {
        self.column = column
        self.row = row
        self.sprite = SKSpriteNode(imageNamed: "character")
    }
    
    convenience init(column: Int, row: Int, spritePosition: CGPoint, spriteSize: CGSize, spriteName: String) {
        self.init(column: column, row: row)
        self.sprite?.position = spritePosition
        self.sprite?.size = spriteSize
        self.sprite?.name = spriteName
    }

}
