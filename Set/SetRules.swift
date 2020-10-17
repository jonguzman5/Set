//
//  SetRules.swift
//  Set
//
//  Created by ジョナサン on 10/16/20.
//  Copyright © 2020 ジョナサン. All rights reserved.
//

import Foundation

class SetRules {
    func scaleMatch(a: Card, b: Card, c: Card) -> Bool {
        return (a.count < b.count) && (a.count < c.count) && (b.count < c.count)
    }
    func scaleMisMatch(a: Card, b: Card, c: Card) -> Bool {
        return (a.count > b.count) && (a.count > c.count) && (b.count > c.count)
    }
    func countMatch(a: Card, b: Card, c: Card) -> Bool {
        return (a.count == b.count) && (a.count == c.count) && (b.count == c.count)
    }
    func countMisMatch(a: Card, b: Card, c: Card) -> Bool {
        return (a.count != b.count) && (a.count != c.count) && (b.count != c.count)
    }
    func colorMatch(a: Card, b: Card, c: Card) -> Bool {
        return (a.color == b.color) && (a.color == c.color) && (b.color == c.color)
    }
    func colorMisMatch(a: Card, b: Card, c: Card) -> Bool {
        return (a.color != b.color) && (a.color != c.color) && (b.color != c.color)
    }
    func shadeMatch(a: Card, b: Card, c: Card) -> Bool {
        return (a.shade == b.shade) && (a.shade == c.shade) && (b.shade == c.shade)
    }
    func shadeMisMatch(a: Card, b: Card, c: Card) -> Bool {
        return (a.shade != b.shade) && (a.shade != c.shade) && (b.shade != c.shade)
    }
    func shapeMatch(a: Card, b: Card, c: Card) -> Bool {
        return (a.shape == b.shape) && (a.shape == c.shape) && (b.shape == c.shape)
    }
    func shapeMisMatch(a: Card, b: Card, c: Card) -> Bool {
        return (a.shape != b.shape) && (a.shape != c.shape) && (b.shape != c.shape)
    }

}
