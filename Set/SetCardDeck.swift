//
//  SetCardDeck.swift
//  Set
//
//  Created by ジョナサン on 9/21/20.
//  Copyright © 2020 ジョナサン. All rights reserved.
//

import Foundation

struct SetCardDeck {
    var deck = [SetCard]()
    
    func count() -> Int {
        return deck.count
    }
    
    func isEmpty() -> Bool {
        return deck.count == 0 ? true : false
    }
    
    mutating func dealCard() -> SetCard? {
        return self.isEmpty() ? nil : deck.remove(at: 0)
    }
    
    init(){
        for color in SetCard.Colors.all {
            for shape in SetCard.Shapes.all {
                for shade in SetCard.Shades.all {
                    for count in 1...3 {
                        deck += [SetCard(shape: shape, shade: shade, color: color, count: count)]
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
