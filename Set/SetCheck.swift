//
//  SetCheck.swift
//  Set
//
//  Created by ジョナサン on 10/12/20.
//  Copyright © 2020 ジョナサン. All rights reserved.
//

import Foundation

class SetCheck {
    var setRules = SetRules()
    func isSet(deck: [CardView]) -> Bool {
        var isSet = false
        if deck[0] != deck[2],
           deck[1] != deck[2],
           deck[0] != deck[1]
        {
            if
            (
                setRules.colorMatch(
                    a: deck[0],
                    b: deck[1],
                    c: deck[2]
                )
                ||
                setRules.colorMisMatch(
                    a: deck[0],
                    b: deck[1],
                    c: deck[2]
                )
            )
                &&
            (
                setRules.shapeMatch(
                    a: deck[0],
                    b: deck[1],
                    c: deck[2]
                )
                ||
                setRules.shapeMisMatch(
                    a: deck[0],
                    b: deck[1],
                    c: deck[2]
                )
            )
                &&
            (
                setRules.shadeMatch(
                    a: deck[0],
                    b: deck[1],
                    c: deck[2]
                )
                ||
                setRules.shadeMisMatch(
                    a: deck[0],
                    b: deck[1],
                    c: deck[2]
                )
            )
                &&
            (
                setRules.countMatch(
                    a: deck[0],
                    b: deck[1],
                    c: deck[2]
                )
                ||
                setRules.countMisMatch(
                    a: deck[0],
                    b: deck[1],
                    c: deck[2]
                )
            )
            {
                isSet = true
            }
            else {
                isSet = false
            }
        }
        return isSet
    }

}
