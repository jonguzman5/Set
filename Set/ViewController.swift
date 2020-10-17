//
//  ViewController.swift
//  Set
//
//  Created by ジョナサン on 9/21/20.
//  Copyright © 2020 ジョナサン. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
        //new deck
        game.availableCards = Deck()
        for index in cardButtons.indices {
            let button = cardButtons[index]
            if let card = game.availableCards.dealCard(){
                //new gameboard
                game.addCardsToGame(card: card)
                //style reset
                button.setAttributedTitle(card.attributedContents(), for: UIControl.State.normal)
                button.deselect()
                button.normalize()
            }
        }
        //clear prev gameboard moves
        resetMoves()
        //re-hide buttons
        hideCards()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        newGame()
    }

    @IBOutlet weak var scoreCountLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!

    func resetMoves(){
        for index in game.cardsInGame.deck.indices {
            game.cardsInGame.deck[index].isSelected = false
            game.cardsInGame.deck[index].pickCount = 0
            game.cardsInGame.deck[index].isMatched = false
        }
        game.selectedCards.deck.removeAll()
    }
    func hideCards(){
        start = (cardButtons.count + 1)/2
        end = cardButtons.count
        for index in stride(from: start, to: end, by: 1){
            let button = cardButtons[index]
            button.isHidden = true
        }
    }
    func showCards(){
        if (start < end){
            for index in stride(from: start, to: start + 3, by: 1){
                let button = cardButtons[index]
                button.isHidden = false
            }
            start += 3
        }
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender){
            game.cardsInGame.deck[cardNumber].pickCount += 1;
            game.addCardsToSelected(at: cardNumber)
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            print("Index: \(cardNumber) | pickCount: \(game.cardsInGame.deck[cardNumber].pickCount)")
            print(game.selectedCards.deck)
        }
        else {
            print("Chosen card was not in cardButtons")
        }
    }

    func updateViewFromModel(){
        var passedMatchTest = false;
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cardsInGame.deck[index]
            if card.isSelected {
                if game.passedSelectedTest(card: card){
                    button.select()
                }
                else {
                    button.deselect()
                }
                for index in game.selectedCards.deck.indices {
                    if game.selectedCards.deck[index].isMatched {
                        //highlight green
                        cardButtons[game.selectedCards.deck[index].origIndex].matchSelect()
                        //adjust score
                        scoreCount = game.score
                        passedMatchTest = true
                    }
                    else if game.selectedCards.deck[index].isMisMatch {
                        //highlight red
                        cardButtons[game.selectedCards.deck[index].origIndex].misMatchSelect()
                        //adjust score
                        scoreCount = game.score
                        passedMatchTest = false
                    }
                }
                if game.selectedCards.deck.count == 4 && passedMatchTest {
                    if game.availableCards.deck.count > 0 {
                        for index in stride(from: 0, to: 3, by: 1){
                            //replace cards
                            cardButtons[game.selectedCards.deck[index].origIndex].setAttributedTitle(game.availableCards.dealCard()?.attributedContents(), for: UIControl.State.normal)
                            //reformat
                            cardButtons[game.selectedCards.deck[index].origIndex].normalize()
                        }
                    }
                    resetMoves()
                }
                else if game.selectedCards.deck.count == 4 && !passedMatchTest {
                    for index in stride(from: 0, to: 3, by: 1){
                        //reformat
                        cardButtons[game.selectedCards.deck[index].origIndex].normalize()
                    }
                    resetMoves()
                }
            }
        }
    }

    @IBAction func dealCards(_ sender: UIButton) {
        showCards()
    }

    @IBAction func restart(_ sender: UIButton) {
        newGame()
    }
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }
        else if self < 0 {
            return -Int(arc4random_uniform(UInt32(-self)))
        }
        else {
            return 0
        }
    }
}

extension UIButton {
    func select() {
        self.backgroundColor = UIColor.systemGray5
    }
    func matchSelect(){
        self.backgroundColor = UIColor.systemGray5
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.green.cgColor
    }
    func misMatchSelect(){
        self.backgroundColor = UIColor.systemGray5
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.red.cgColor
    }
    func deselect(){
        self.backgroundColor = UIColor.systemGray6
    }
    func normalize(){
        self.backgroundColor = UIColor.systemGray6
        self.layer.borderWidth = 0
        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    }
}
