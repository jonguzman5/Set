//
//  Set.swift
//  Set
//
//  Created by ジョナサン on 10/2/20.
//  Copyright © 2020 ジョナサン. All rights reserved.
//

import Foundation

class Game {
    var deckView = DeckView()
    var setCheck = SetCheck()
    
    var availableCards = Deck()//81
    var cardsInGame = Deck()//24
    var selectedCards = [CardView]()//3
    var score = 0;
    
    func getCards(noOfCards: Int) -> [Card]{
        var cards = [Card]()
        for _ in 0..<noOfCards {
            let card = availableCards.dealCard()!
            cards.append(card)
        }
        return cards
    }
    
    func passedSelectedTest(card: CardView) -> Bool {
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
    
    func addCardsToSelected(card: CardView, origIndex: Int){
        card.origIndex = origIndex
        print("ORIG_INDEX: \(card.origIndex)")
        if passedSelectedTest(card: card) {
            selectedCards.append(card)
        }
        else {
            card.pickCount = 0
            if !selectedCards.isEmpty{
                selectedCards.removeLast()
            }
        }
    }

    func chooseCard(card: CardView){
        //print("@chooseCard: \(selectedCards)")
        //if !cardsInGame.deck[index].isMatched {
            if selectedCards.count == 3 && setCheck.isSet(deck: selectedCards) {
                for index in selectedCards.indices {
                    selectedCards[index].isMatched = true
                }
                score += 3
            }
            else if selectedCards.count == 3 && !setCheck.isSet(deck: selectedCards) {
                for index in selectedCards.indices {
                    selectedCards[index].isMisMatched = true
                }
                score -= 5
            }
            //cardsInGame.deck[index].isSelected = true
        //}
    }
    
    init(){
        cardsInGame.deck.removeAll()
        selectedCards.removeAll()
    }
}
