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
        let initialCards = getCardViews(noOfCards: 12)
        addCardsToGame(initialCards)
        deckView.animationHasBeenShown = false
        //clear prev gameboard moves
        resetMoves()
    }

    override func viewDidLoad() {
        newGame()
        deckButtonIn.setCardBack()
        deckButtonOut.setCardBack()
        dealCardsButton.setBorder()
        newGameButton.setBorder()
        super.viewDidLoad()
    }
    

    @IBOutlet weak var scoreCountLabel: UILabel!
    
    func getCardViews(noOfCards: Int) -> [CardView] {
        var cardViews = [CardView]()
        let cards = game.getCards(noOfCards: noOfCards)
        game.cardsInGame.deck.append(contentsOf: cards)
        for index in 0..<noOfCards {
            cardView = CardView()
            cardView.shape = cards[index].shape
            cardView.shade = cards[index].shade
            cardView.color = cards[index].color
            cardView.count = cards[index].count
            cardViews.append(cardView)
        }
        return cardViews
    }
    
    func addCardsToGame(_ cardViews: [CardView]){
        for cardView in cardViews {
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
            game.addCardsToSelected(card, cardNumber)
            game.chooseCard(card)
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
                if game.passedSelectedTest(card){
                    card.select()
                    card.transform = CGAffineTransform(scaleX: 2, y: 2)
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
                    if game.availableCards.deck.count > 0 {
                        for index in stride(from: 0, to: 3, by: 1){
                            let selectedCards = cardButtons[game.selectedCards[index].origIndex]
                            let dealtCards = getCardViews(noOfCards: 3)
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                     withDuration: 0.75,
                                     delay: 0,
                                     options: [.curveEaseOut],
                                     animations: {
                                        selectedCards.layer.zPosition = 1
                                        selectedCards.frame.origin.x = selectedCards.frame.size.width
                                        selectedCards.frame.origin.y = selectedCards.frame.size.height
                                        //selectedCards.alpha = 0
                                    },
                                     completion: { finished in
                                        UIView.transition(
                                            with: selectedCards,
                                            duration: 0.6,
                                            options: .transitionFlipFromLeft,
                                            animations: {
                                                selectedCards.isFaceUp = false
                                            },
                                            completion: { finished in
                                                UIView.transition(
                                                    with: selectedCards,
                                                    duration: 0.6,
                                                    options: .transitionFlipFromLeft,
                                                    animations: {
                                                        //selectedCards.alpha = 1
                                                        //replace cards
                                                        for index in 0..<dealtCards.count {
                                                            selectedCards.shape = dealtCards[index].shape
                                                            selectedCards.shade = dealtCards[index].shade
                                                            selectedCards.color = dealtCards[index].color
                                                            selectedCards.count = dealtCards[index].count
                                                            selectedCards.isFaceUp = true
                                                        }
                                                        //reformat
                                                        selectedCards.unMatchSelect()
                                                    }
                                                )
                                            }
                                        )
                                    }
                            )
                        }
                    }
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
    
    func flipBackOver(cards: [CardView]){
        for index in cards.indices {
            let card = cards[index]
            UIView.transition(
                with: card,
                duration: 1,
                options: .transitionFlipFromLeft,
                animations: {
                    //card.isFaceUp = !card.isFaceUp
                    card.isFaceUp = false
                }
            )
        }
    }
    
    @IBOutlet weak var deckButtonIn: UIButton!
    @IBOutlet weak var deckButtonOut: UIButton!
    @IBOutlet weak var dealCardsButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    
    @IBAction func dealCards(_ sender: UIButton) {
        deckView.animationHasBeenShown = false
        if game.availableCards.deck.count > 0 && game.cardsInGame.deck.count < 81 {
            let dealtCards = getCardViews(noOfCards: 3)
            addCardsToGame(dealtCards)
            flipBackOver(cards: cardButtons)
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
    func setCardBack(){
        let image = UIImage(named: "cardback.png")
        self.setBackgroundImage(image, for: UIControl.State.normal)
        self.layer.cornerRadius = 16.0
    }
    func setBorder(){
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 3.0
    }
}
