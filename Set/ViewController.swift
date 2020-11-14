//
//  ViewController.swift
//  Set
//
//  Created by ジョナサン on 9/21/20.
//  Copyright © 2020 ジョナサン. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var deckView: DeckView!
    
    var cardButtons: [CardView]! {
        if let deck = deckView {
            return deck.subviews as? [CardView]
        }
        else {
            return nil
        }
    }
    
    var cardView: CardView! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.touchCard(_:)))
            self.cardView.addGestureRecognizer(gesture)
        }        
    }
    
    var game = Game()
    var start = 0
    var end = 0
    var scoreCount = 0 {
        didSet {
            scoreCountLabel.text = "Score: \(scoreCount)"
        }
    }

    func newGame(){
        //call game class => re-enable setCheck
        game = Game()
        scoreCount = 0
        game.score = 0
        cardButtons.forEach({ $0.removeFromSuperview() })
        //new deck
        game.availableCards = Deck()
        //new gameboard
        addCardsToGame(noOfCards: 12)
        //clear prev gameboard moves
        resetMoves()
    }

    override func viewDidLoad() {
        newGame()
        super.viewDidLoad()
    }

    @IBOutlet weak var scoreCountLabel: UILabel!
    
    func addCardsToGame(noOfCards: Int){
        let cards = game.getCards(noOfCards: noOfCards)
        game.cardsInGame.deck.append(contentsOf: cards)
        
        for index in 0..<noOfCards {
            cardView = CardView()
            cardView.shape = cards[index].shape
            cardView.shade = cards[index].shade
            cardView.color = cards[index].color
            cardView.count = cards[index].count
            deckView.addSubview(cardView)
        }
    }

    func resetMoves(){
        //for index in game.cardsInGame.deck.indices {
            //game.cardsInGame.deck[index].isSelected = false
            //game.cardsInGame.deck[index].pickCount = 0
            //game.cardsInGame.deck[index].isMatched = false
        //}
        game.selectedCards.removeAll()
    }
    
    @IBAction func touchCard(_ sender: UITapGestureRecognizer) {
        let card = sender.view as! CardView
        //print(card)
        if let cardNumber = cardButtons.firstIndex(of: card){
            //print(cardNumber)
            card.pickCount += 1;
            game.addCardsToSelected(card: card, origIndex: cardNumber)
            game.chooseCard(card: card)
            updateViewFromModel()
            print("Index: \(cardNumber) | pickCount: \(cardButtons[cardNumber].pickCount)")
            print(game.selectedCards)
        }
        else {
            print("Chosen card was not in cardButtons")
        }
    }

    func updateViewFromModel(){
        
        var passedMatchTest = false;
        for index in cardButtons.indices {
            let card = cardButtons[index]
            if card.isSelected {
                if game.passedSelectedTest(card: card){
                    card.select()
                }
                else {
                    card.deselect()
                }
                for index in game.selectedCards.indices {
                    if game.selectedCards[index].isMatched {
                        //highlight green
                        cardButtons[game.selectedCards[index].origIndex].matchSelect()
                        //adjust score
                        scoreCount = game.score
                        passedMatchTest = true
                    }
                    else if game.selectedCards[index].isMisMatched {
                        //highlight red
                        cardButtons[game.selectedCards[index].origIndex].misMatchSelect()
                        //adjust score
                        scoreCount = game.score
                        passedMatchTest = false
                    }
                }
                if game.selectedCards.count == 4 && passedMatchTest {
                    //if game.availableCards.deck.count > 0 {
                        for index in stride(from: 0, to: 3, by: 1){
                            //replace cards
                            //cardButtons[game.selectedCards[index].origIndex].count = 3
                            [cardButtons[game.selectedCards[index].origIndex]]
                            //reformat
                            cardButtons[game.selectedCards[index].origIndex].unMatchSelect()
                        }
                    //}
                    resetMoves()
                }
                else if game.selectedCards.count == 4 && !passedMatchTest {
                    for index in stride(from: 0, to: 3, by: 1){
                        //reformat
                        cardButtons[game.selectedCards[index].origIndex].unMisMatchSelect()
                    }
                    resetMoves()
                }
            }
        }
        
    }
    

    @IBAction func dealCards(_ sender: UIButton) {
        if game.availableCards.deck.count > 0 && game.cardsInGame.deck.count < 81 {
            addCardsToGame(noOfCards: 3)
        }
    }

    @IBAction func restart(_ sender: UIButton) {
        newGame()
    }
    
}

extension CardView {
    func select(){
        self.isDeselected = false
        self.isSelected = true
    }
    func deselect(){
        self.isSelected = false
        self.isDeselected = true
    }
    func matchSelect(){
        self.isMatched = true
    }
    func misMatchSelect(){
        self.isMisMatched = true
    }
    func unMatchSelect(){
        self.isMatched = false
        self.isSelected = false
        self.isDeselected = true
    }
    func unMisMatchSelect(){
        self.isMisMatched = false
        self.isSelected = false
        self.isDeselected = true
    }
}

@IBDesignable extension UIButton {
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
