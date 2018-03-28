//
//  ViewController.swift
//  Concentration
//
//  Created by Victor Seo on 2018-03-14.
//  Copyright © 2018 Victora. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var newGameButton: UIButton!
    @IBAction func touchCard(_ sender: UIButton) {
//        let timeInitial = Date()
        game.flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
//        print(timeInitial.timeIntervalSinceNow)
    }
    @IBAction func touchNewGame(_ sender: UIButton) {
        if let pastGameIndex = game.themeNumber {
            game = Concentration(numberOfPairsOfCards: cardButtons.count / 2, from: pastGameIndex)
        } else {
            game = Concentration(numberOfPairsOfCards: cardButtons.count / 2)
        }
        updateViewFromModel()
    }
    var emoji = [Int:String]()
    var themeColors: [Int:[UIColor]] = [0:[#colorLiteral(red: 0.9647058824, green: 0.5725490196, blue: 0.1137254902, alpha: 1),#colorLiteral(red: 0.3764705882, green: 0.1529411765, blue: 0.2862745098, alpha: 1),#colorLiteral(red: 0.9647058824, green: 0.5725490196, blue: 0.1137254902, alpha: 1)], 1:[#colorLiteral(red: 0.1333333333, green: 0.3921568627, blue: 0.431372549, alpha: 1),#colorLiteral(red: 0.231372549, green: 0.537254902, blue: 0.6745098039, alpha: 1),#colorLiteral(red: 0.7490196078, green: 0.8235294118, blue: 0.8509803922, alpha: 1)], 2:[#colorLiteral(red: 0.8431372549, green: 0.6862745098, blue: 0.4470588235, alpha: 1),#colorLiteral(red: 0.937254902, green: 0.8705882353, blue: 0.7607843137, alpha: 1),#colorLiteral(red: 0.6588235294, green: 0.3960784314, blue: 0.1176470588, alpha: 1)], 3:[#colorLiteral(red: 0.9960784314, green: 0.7215686275, blue: 0.7411764706, alpha: 1),#colorLiteral(red: 0.9843137255, green: 0.937254902, blue: 0.8980392157, alpha: 1),#colorLiteral(red: 0.5215686275, green: 0.07058823529, blue: 0.1490196078, alpha: 1)], 4:[#colorLiteral(red: 0.831372549, green: 0.7450980392, blue: 0.6509803922, alpha: 1),#colorLiteral(red: 0.7450980392, green: 0.1333333333, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.9411764706, green: 0.9254901961, blue: 0.9137254902, alpha: 1)]]
    lazy var game = Concentration(numberOfPairsOfCards: cardButtons.count / 2)
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, game.currentEmoji.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(game.currentEmoji.count)))
            emoji[card.identifier] = game.currentEmoji.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
    func updateViewFromModel() {
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : themeColors[game.themeNumber!]![0]
            }
        }
        
        view.backgroundColor = themeColors[game.themeNumber!]![1]
        scoreLabel.text = "Score: \(game.score)"
        scoreLabel.textColor = themeColors[game.themeNumber!]![2]
        flipCountLabel.text = "Flips: \(game.flipCount)"
        flipCountLabel.textColor = themeColors[game.themeNumber!]![2]
        newGameButton.setTitleColor(themeColors[game.themeNumber!]![2], for: UIControlState.normal)
    }
}
