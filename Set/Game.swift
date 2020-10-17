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
    
    func passedSelectedTest(card: Card) -> Bool {
        var card = card
        var passed = false;
        if card.pickCount == 1 {
            card.isSelected = true
            passed = true
        }
        else if card.pickCount == 2 {
            card.isSelected = false
            passed = false
        }
        return passed
    }
    
    func addCardsToSelected(at index: Int){
        var card = cardsInGame.deck[index]
        card.origIndex = index
        if passedSelectedTest(card: card) {
            selectedCards.deck.append(card)
        }
        else {
            cardsInGame.deck[index].pickCount = 0//why !card???
            if !selectedCards.isEmpty(){
                selectedCards.deck.removeLast()
            }
        }
    }

    func chooseCard(at index: Int){
        //print("@chooseCard: \(selectedCards)")
        if !cardsInGame.deck[index].isMatched {
            if selectedCards.deck.count == 3 && setCheck.isSet(deck: selectedCards.deck) {
                for index in selectedCards.deck.indices {
                    selectedCards.deck[index].isMatched = true
                }
                score += 3
            }
            else if selectedCards.deck.count == 3 && !setCheck.isSet(deck: selectedCards.deck) {
                for index in selectedCards.deck.indices {
                    selectedCards.deck[index].isMisMatch = true
                }
                score -= 5
            }
            cardsInGame.deck[index].isSelected = true
        }
    }
    
    init(){
        cardsInGame.deck.removeAll()
        selectedCards.deck.removeAll()
    }
}
