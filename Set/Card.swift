//
//  Card.swift
//  Set
//
//  Created by ジョナサン on 9/22/20.
//  Copyright © 2020 ジョナサン. All rights reserved.
//

import Foundation
import UIKit

class Card : Equatable {
    var pickCount = 0
    var origIndex = Int()
    
    var shape : Shapes
    var shade : Shades
    var color : Colors
    var count : Int
    
    var isSelected = false
    var isMatched  = false
    var isMisMatch = false
    
    
    
    enum Shapes {
        case squiggle
        case oval
        case diamond
        static var all = [Shapes.squiggle, .oval, .diamond]
    }
    
    enum Shades {
        case outlined
        case striped
        case filled
        static var all = [Shades.outlined, .striped, .filled]
    }

    enum Colors {
        case green
        case red
        case purple
        
        static var all = [Colors.green, .red, .purple]
    }

    init(shape: Shapes, shade: Shades, color: Colors, count: Int) {
        self.shape = shape
        self.shade = shade
        self.color = color
        self.count = count
    }
}

extension Card {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return (lhs.shape == rhs.shape) &&
               (lhs.color == rhs.color) &&
               (lhs.shade == rhs.shade) &&
               (lhs.count == rhs.count)
    }
}
