//
//  Set.swift
//  Set
//
//  Created by ジョナサン on 10/2/20.
//  Copyright © 2020 ジョナサン. All rights reserved.
//

import Foundation

class Game {
    var deck = Deck()
    
    var score = 0;

    private var indicesOfSelectedCards : [Int]? {
        get {
            return deck.deck.indices.filter { deck.deck[$0].isSelected }
        }
        set(newValue) {
            for index in deck.deck.indices {
                deck.deck[index].isSelected = (index == newValue![index])
            }
        }
    }
    func scaleMatch(a: Card, b: Card, c: Card) -> Bool {
        return (a.count < b.count) && (a.count < c.count) && (b.count < c.count)
    }
    func colorMatch(a: Card, b: Card, c: Card) -> Bool {
        return (a.color == b.color) && (a.color == c.color) && (b.color == c.color)
    }
    func shadeMatch(a: Card, b: Card, c: Card) -> Bool {
        return (a.shade == b.shade) && (a.shade == c.shade) && (b.shade == c.shade)
    }
    func shapeMatch(a: Card, b: Card, c: Card) -> Bool {
        return (a.shape == b.shape) && (a.shape == c.shape) && (b.shape == c.shape)
    }

    var start1 = -2
    var start2 = -1
    func chooseCard(at index: Int){
        //print("@game: \(deck)")
        assert(deck.deck.indices.contains(index), "Deck.chooseCard(at: \(index)): Chosen index is not valid")
        if !deck.deck[index].isMatched {
            if indicesOfSelectedCards!.count == 2 {
                if let firstSelectedCard = indicesOfSelectedCards?[start1 + 2],
                   let secondSelectedCard = indicesOfSelectedCards?[start2 + 2],
                    firstSelectedCard != index,
                    secondSelectedCard != index,
                    firstSelectedCard != secondSelectedCard
                {
                    print("\(deck.deck[firstSelectedCard].color)")
                    print("\(deck.deck[secondSelectedCard].color)")
                    print("\(deck.deck[index].color)")
                    print("in here")
                    
                    if !colorMatch(a: deck.deck[firstSelectedCard], b: deck.deck[secondSelectedCard], c: deck.deck[index]){
                        print("colors matched")
                        deck.deck[firstSelectedCard].isMatched = true
                        deck.deck[secondSelectedCard].isMatched = true
                        deck.deck[index].isMatched = true
                        score += 3
                    }
                    else {
                        score -= 5
                    }
                    deck.deck[index].isSelected = true
                }
                else {
                    print("in outer else")
                    for nonSelectedIndex in deck.deck.indices {
                        deck.deck[nonSelectedIndex].isSelected = false
                    }
                    deck.deck[index].isSelected = true
                    indicesOfSelectedCards?[start1] = index
                    indicesOfSelectedCards?[start2] = index
                }
            }
            else {
                deck.deck[index].isSelected = true
            }
        }
    }

}
