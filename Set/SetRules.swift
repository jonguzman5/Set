//
//  SetRules.swift
//  Set
//
//  Created by ジョナサン on 10/16/20.
//  Copyright © 2020 ジョナサン. All rights reserved.
//

/*
Set Rules:
(colors match OR colors mismatch) AND
(shapes match OR shapes mismatch) AND
(shades match OR shades mismatch) AND
(count match OR count mismatch)
 */

import Foundation

class SetRules {
    func scaleMatch(a: CardView, b: CardView, c: CardView) -> Bool {
        return (a.count < b.count) && (a.count < c.count) && (b.count < c.count)
    }
    func scaleMisMatch(a: CardView, b: CardView, c: CardView) -> Bool {
        return (a.count > b.count) && (a.count > c.count) && (b.count > c.count)
    }
    func countMatch(a: CardView, b: CardView, c: CardView) -> Bool {
        return (a.count == b.count) && (a.count == c.count) && (b.count == c.count)
    }
    func countMisMatch(a: CardView, b: CardView, c: CardView) -> Bool {
        return (a.count != b.count) && (a.count != c.count) && (b.count != c.count)
    }
    func colorMatch(a: CardView, b: CardView, c: CardView) -> Bool {
        return (a.color == b.color) && (a.color == c.color) && (b.color == c.color)
    }
    func colorMisMatch(a: CardView, b: CardView, c: CardView) -> Bool {
        return (a.color != b.color) && (a.color != c.color) && (b.color != c.color)
    }
    func shadeMatch(a: CardView, b: CardView, c: CardView) -> Bool {
        return (a.shade == b.shade) && (a.shade == c.shade) && (b.shade == c.shade)
    }
    func shadeMisMatch(a: CardView, b: CardView, c: CardView) -> Bool {
        return (a.shade != b.shade) && (a.shade != c.shade) && (b.shade != c.shade)
    }
    func shapeMatch(a: CardView, b: CardView, c: CardView) -> Bool {
        return (a.shape == b.shape) && (a.shape == c.shape) && (b.shape == c.shape)
    }
    func shapeMisMatch(a: CardView, b: CardView, c: CardView) -> Bool {
        return (a.shape != b.shape) && (a.shape != c.shape) && (b.shape != c.shape)
    }

}
