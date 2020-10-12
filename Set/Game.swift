//
//  Set.swift
//  Set
//
//  Created by ジョナサン on 10/2/20.
//  Copyright © 2020 ジョナサン. All rights reserved.
//

import Foundation

class Game {
    var setCheck = SetCheck()
    var availableCards = Deck()//81
    var cardsInGame = Deck()//24
    var selectedCards = Deck()//3
    var score = 0;
    
    func addCardsToGame(card: Card){
        cardsInGame.deck.append(card)
    }
    
    func addCardsToSelected(at index: Int){//card: Card
        var card = cardsInGame.deck[index]
        card.isSelected = true
        selectedCards.deck.append(card)
    }
    
    func isSet() -> Bool {
        var isSet = false
        if selectedCards.deck[0] != selectedCards.deck[2],
           selectedCards.deck[1] != selectedCards.deck[2],
           selectedCards.deck[0] != selectedCards.deck[1]
        {
            if setCheck.colorMatch(
                    a: selectedCards.deck[0],
                    b: selectedCards.deck[1],
                    c: selectedCards.deck[2]
                )
                && setCheck.shapeMatch(
                    a: selectedCards.deck[0],
                    b: selectedCards.deck[1],
                    c: selectedCards.deck[2]
                )
                && setCheck.countMatch(
                    a: selectedCards.deck[0],
                    b: selectedCards.deck[1],
                    c: selectedCards.deck[2]
                )
                && setCheck.shadeMisMatch(
                    a: selectedCards.deck[0],
                    b: selectedCards.deck[1],
                    c: selectedCards.deck[2]
                )
            {
                isSet = true
            }
            else if setCheck.shapeMisMatch(
                    a: selectedCards.deck[0],
                    b: selectedCards.deck[1],
                    c: selectedCards.deck[2]
                )
                && setCheck.colorMisMatch(
                    a: selectedCards.deck[0],
                    b: selectedCards.deck[1],
                    c: selectedCards.deck[2]
                )
                && setCheck.countMisMatch(
                    a: selectedCards.deck[0],
                    b: selectedCards.deck[1],
                    c: selectedCards.deck[2]
                )
                && setCheck.shadeMatch(
                    a: selectedCards.deck[0],
                    b: selectedCards.deck[1],
                    c: selectedCards.deck[2]
                )
            {
                isSet = true
            }
            else if setCheck.shapeMisMatch(
                    a: selectedCards.deck[0],
                    b: selectedCards.deck[1],
                    c: selectedCards.deck[2]
                )
                && setCheck.colorMisMatch(
                    a: selectedCards.deck[0],
                    b: selectedCards.deck[1],
                    c: selectedCards.deck[2]
                )
                && setCheck.countMisMatch(
                    a: selectedCards.deck[0],
                    b: selectedCards.deck[1],
                    c: selectedCards.deck[2]
                )
                && setCheck.shadeMisMatch(
                    a: selectedCards.deck[0],
                    b: selectedCards.deck[1],
                    c: selectedCards.deck[2]
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

    func chooseCard(at index: Int){
        //print("@chooseCard: \(selectedCards)")
        if !cardsInGame.deck[index].isMatched {
            if selectedCards.deck.count == 3 && isSet() {
                print("0: \(selectedCards.deck[0])")
                print("1: \(selectedCards.deck[1])")
                print("2: \(selectedCards.deck[2])")
                cardsInGame.deck[index].isMatched = true
                selectedCards.deck[0].isMatched = true
                selectedCards.deck[1].isMatched = true
                selectedCards.deck[2].isMatched = true
                score += 3
            }
            else if selectedCards.deck.count == 3 && !isSet(){
                print("not set")
                cardsInGame.deck[index].isMisMatch = true
                selectedCards.deck[0].isMisMatch = true
                selectedCards.deck[1].isMisMatch = true
                selectedCards.deck[2].isMisMatch = true
                score -= 5
                selectedCards.deck.removeAll()
            }
            cardsInGame.deck[index].isSelected = true
        }
    }
    
    init(){
        cardsInGame.deck.removeAll()
        selectedCards.deck.removeAll()
    }
}
