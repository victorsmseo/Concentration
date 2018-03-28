//
//  Concentration.swift
//  Concentration
//
//  Created by Victor Seo on 2018-03-15.
//  Copyright © 2018 Victora. All rights reserved.
//

import Foundation

class Concentration {
    var flipCount = 0
    var score = 0
    var indexOfOneAndOnlyFaceUpCard: Int?
    var themeNumber: Int?
    var currentEmoji = [String]()
    var cards = [Card]()
    var emojiDictionary: [Int: [String]] = [0: ["🦇","🎃","👻","🧟‍♂️","💀","🧛🏻‍♂️","🧙🏻‍♂️","🤡"], 1: ["🐬","🐟","🐳","🐋","🦈","🐡","🐠","🦑"], 2: ["🦂","🦗","🕷","🦅","🦉","🐫","🌵","🐍"], 3: ["🌺","🌹","🌸","🌼","🌻","💐","🥀","🌷"], 4: ["🎅🏻","👼🏻","🎄","🎁","🤶🏻","⛪️","🦌","🎊"]]
    init(numberOfPairsOfCards: Int) {
        initializeCards(numberOfPairsOfCards)
        themeNumber = 3
        currentEmoji = emojiDictionary[themeNumber!]!
    }
    init(numberOfPairsOfCards: Int, from index: Int) {
        initializeCards(numberOfPairsOfCards)
        themeNumber = randomize(among: emojiDictionary.count, without: index)
        currentEmoji = emojiDictionary[themeNumber!]!
    }
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            cards[index].flippedTime = cards[index].flippedTime ?? Date()
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                    let timeMatchIndex: Double = cards[matchIndex].flippedTime!.timeIntervalSinceReferenceDate
                    let timeIndex: Double = cards[index].flippedTime!.timeIntervalSinceReferenceDate
                    if cards[matchIndex].flippedTime != nil, cards[index].flippedTime != nil {
                        let timeDifference = abs(timeMatchIndex - timeIndex)
                        let bonusPoints: Int
                        switch timeDifference {
                        case 0..<1:
                            bonusPoints = 5
                        case 1..<2:
                            bonusPoints = 4
                        case 2..<3:
                            bonusPoints = 3
                        case 3..<4:
                            bonusPoints = 2
                        case 4..<5:
                            bonusPoints = 1
                        default:
                            bonusPoints = 0
                        }
                        score += bonusPoints
                    }
                } else {
                    negativePoints(for: index)
                    negativePoints(for: matchIndex)
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    func chooseTheme() {
        themeNumber = themeNumber ?? Int(arc4random_uniform(UInt32(emojiDictionary.count)))
    }
    func chooseTheme(without index: Int) {
        themeNumber = themeNumber ?? randomize(among: emojiDictionary.count, without: index)
    }
    func initializeCards(_ numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        shuffle()
    }
    func negativePoints(for index: Int) {
        if cards[index].isSeen {
            score -= 1
        } else {
            cards[index].isSeen = true
        }
    }
    func randomize(among numberOfIndex: Int, without index: Int) -> Int {
        var randomIndex = Int(arc4random_uniform(UInt32(numberOfIndex)))
        while randomIndex == index {
            randomIndex = Int(arc4random_uniform(UInt32(numberOfIndex)))
        }
        return randomIndex
    }
    func shuffle() {
        var orderedNumberList = Array(0...15)
        var tempCards = [Card]()
        for _ in 0..<cards.count {
            let randomIndex = Int(arc4random_uniform(UInt32(orderedNumberList.count)))
            let randomValue = orderedNumberList.remove(at: randomIndex)
            tempCards.append(cards[randomValue])
        }
        cards = tempCards
    }
}
