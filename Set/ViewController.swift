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
    
    func newGame(){
        scoreCount = 0
        for index in cardButtons.indices {
            let button = cardButtons[index]
            if let card = game.availableCards.dealCard(){
                game.addCardsToGame(card: card)
                button.setAttributedTitle(card.attributedContents(), for: UIControl.State.normal)
                button.deselect()
                button.normalize()
            }
        }
        for index in stride(from: (cardButtons.count + 1)/2, to: cardButtons.count, by: 1){
            let button = cardButtons[index]
            button.isHidden = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        newGame()
    }
    
    var shape = Dictionary<Card, String>()
    
    var scoreCount = 0 {
        didSet {
            scoreCountLabel.text = "Score: \(scoreCount)"
        }
    }
    
    @IBOutlet weak var scoreCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
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
                if card.isMatched {
                    button.matchSelect()
                    scoreCount = game.score
                    //replace cards
                    button.setAttributedTitle(card.attributedContents(), for: UIControl.State.normal)
                    //reformat
                    button.normalize()
                }
                else if card.isMisMatch {
                    button.misMatchSelect()
                    scoreCount = game.score
                }
            }
            //else {if card.isMatched {} else {}}
        }
    }
    
    var start = 13
    @IBAction func dealCards(_ sender: UIButton) {
        if (start < cardButtons.count){
            for index in stride(from: start, to: start + 3, by: 1){
                let button = cardButtons[index]
                button.isHidden = false
            }
            start += 3
        }
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
