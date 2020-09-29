//
//  Deck.swift
//  Set
//
//  Created by ジョナサン on 9/22/20.
//  Copyright © 2020 ジョナサン. All rights reserved.
//

import Foundation

struct Deck {
    var deck = [Card]()
    var score = 0;
    
    func count() -> Int {
        return deck.count
    }
    
    func isEmpty() -> Bool {
        return deck.count == 0 ? true : false
    }
    
    mutating func dealCard() -> Card? {
        return self.isEmpty() ? nil : deck.remove(at: 0)
    }
    var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return deck.indices.filter{deck[$0].isSelected}.oneAndOnly
        }
        set(newValue) {
            for index in deck.indices {
                deck[index].isSelected = (index == newValue)
            }
        }
    }
    var indexOfFirstSelectedCard: Int? {
        get {
            let selectedCardIndices = deck.indices.filter{deck[$0].isSelected}
            return selectedCardIndices.count == 1 ? selectedCardIndices.first : nil
        }
        set(newValue) {
            for index in deck.indices {
                deck[index].isSelected = (index == newValue)
            }
        }
    }
    var indexOfSecondSelectedCard: Int? {
        get {
            let selectedCardIndices = deck.indices.filter{deck[$0].isSelected}
            return selectedCardIndices.count == 1 ? selectedCardIndices.endIndex : nil
        }
        set(newValue) {
            for index in deck.indices {
                deck[index].isSelected = (index == newValue)
            }
        }
    }
    
    func scaleMatch(a: Card, b: Card, c: Card) -> Bool {
        return (a.count < b.count) && (a.count < c.count) && (b.count < c.count)
    }
//    func colorMatch(a: Card, b: Card, c: Card) -> Bool {
//        return (a.color == b.color) && (a.color == c.color) && (b.color == c.color)
//    }
    func colorMatch(a: Card, c: Card) -> Bool {
        return (a.color == c.color)
    }
    func shadeMatch(a: Card, b: Card, c: Card) -> Bool {
        return (a.shade == b.shade) && (a.shade == c.shade) && (b.shade == c.shade)
    }
    func shapeMatch(a: Card, b: Card, c: Card) -> Bool {
        return (a.shape == b.shape) && (a.shape == c.shape) && (b.shape == c.shape)
    }
    
    mutating func chooseCard(at index: Int){
        assert(deck.indices.contains(index), "Deck.chooseCard(at: \(index)): Chosen index is not valid")
        if !deck[index].isMatched {
            //implement indexOfSecondSelectedCard here
            if let firstSelected = indexOfFirstSelectedCard, indexOfFirstSelectedCard != index {
                if colorMatch(a: deck[firstSelected], c: deck[index]){
                    deck[firstSelected].isSelected = true
                    //deck[secondSelected].isSelected = true
                    deck[index].isSelected = true
                    score += 1
                }
                else {
                    print("in inner else")
                }
                deck[index].isSelected = true
            }
            else {
                print("in outer else")
                for nonSelectedIndex in deck.indices {
                    deck[nonSelectedIndex].isSelected = false
                }
                deck[index].isSelected = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(){
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

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
