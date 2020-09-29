//
//  ViewController.swift
//  Set
//
//  Created by ジョナサン on 9/21/20.
//  Copyright © 2020 ジョナサン. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = Deck()

    override func viewDidLoad() {
        super.viewDidLoad()
        for index in cardButtons.indices {
            let button = cardButtons[index]
            if let card = game.dealCard(){
                button.setTitle(card.contents(), for: UIControl.State.normal)
            }
        }
        for index in stride(from: (cardButtons.count + 1)/2, to: cardButtons.count, by: 1){
            let button = cardButtons[index]
            button.isHidden = true
        }
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
            //print("Card Number: \(cardNumber)")
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
        else {
            print("Chosen card was not in cardButtons")
        }
    }
    
    func updateViewFromModel(){
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.deck[index]
            if card.isSelected {
                button.backgroundColor = UIColor.systemGray5
            }
            else {
                button.backgroundColor = UIColor.systemGray6
                if card.isMatched {
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                    scoreCount = game.score
                }
                else {
                    button.backgroundColor = UIColor.systemGray6
                    scoreCount = game.score
                }
            }
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
