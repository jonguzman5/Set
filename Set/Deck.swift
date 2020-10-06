//
//  Deck.swift
//  Set
//
//  Created by ジョナサン on 9/22/20.
//  Copyright © 2020 ジョナサン. All rights reserved.
//

import Foundation

class Deck {
    var deck = [Card]()

    func count() -> Int {
        return deck.count
    }

    func isEmpty() -> Bool {
        return deck.count == 0 ? true : false
    }

    func dealCard() -> Card? {
        return self.isEmpty() ? nil : deck.remove(at: 0)
    }

    init(){
        //print("@deck: \(deck)")
        for color in Card.Colors.all {
            for shape in Card.Shapes.all {
                for shade in Card.Shades.all {
                    for count in 1...3 {
                        deck += [Card(shape: shape, shade: shade, color: color, count: count)]
                    }
                }
            }
        }

        for _ in 1...10 {
            for index in deck.indices {
                let randomIndex = Int(arc4random_uniform(UInt32(index)))
                let card = deck.remove(at: randomIndex)
                deck.append(card)
            }
        }
    }
}
