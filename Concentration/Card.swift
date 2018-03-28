//
//  Card.swift
//  Concentration
//
//  Created by Victor Seo on 2018-03-15.
//  Copyright © 2018 Victora. All rights reserved.
//

import Foundation

struct Card {
    var flippedTime: Date?
    // ----------
    var isFaceUp = false
    var isMatched = false
    var isSeen = false
    var identifier: Int
    static var identifierFactory = 0
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
}
