//
//  Concentration.swift
//  CardMatching
//
//  Created by taehoon lee on 2018. 4. 2..
//  Copyright © 2018년 taehoon lee. All rights reserved.
//

import Foundation

struct Card {
    var isFaceUp: Bool = false
    var isMatched: Bool = false
    var identifier: Int
    
    private static var uniqueIdentifier: Int = -1
    static func getUniqueIdentifier() -> Int {
        uniqueIdentifier += 1
        return uniqueIdentifier
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}

class Concentration {
    private var touchedCardIndex: Int?
    private(set) var cards = [Card]()
    private var numberOfPairsOfCards: Int = -1
    init(numberOfPairsOfCards: Int) {
//        for _ in 0..<numberOfPairsOfCards {
//            let card = Card()
//            cards += [card, card]
//        }
//        // TODO: shuffle the cards
//        cards = shuffle(cards)
        self.numberOfPairsOfCards = numberOfPairsOfCards
        reset()
    }
    
    func reset() {
        cards = reset(self.numberOfPairsOfCards)
    }
    
    private func reset(_ numberOfPairsOfCards: Int) -> [Card] {
        var shuffledCards = [Card]()
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            shuffledCards += [card, card]
        }
        // TODO: shuffle the cards
        shuffledCards = shuffle(shuffledCards)
        return shuffledCards
    }
    
    private func shuffle(_ cards: [Card]) -> [Card] {
        var temp = cards
        var result = [Card]()
        var index = temp.count - 1
        while index >= 0 {
            let randomCard = temp.remove(at: Int(arc4random_uniform(UInt32(index))))
            result.append(randomCard)
            index -= 1
        }
        return result
    }
    
    func chooseCard(at index: Int) {
        if touchedCardIndex == nil {
            for cardIndex in cards.indices {
                if !cards[cardIndex].isMatched {
                    cards[cardIndex].isFaceUp = false
                }
            }
            cards[index].isFaceUp = true
            touchedCardIndex = index
        } else {
            if touchedCardIndex! != index {
                if cards[touchedCardIndex!].identifier == cards[index].identifier {
                    cards[index].isMatched = true
                    cards[touchedCardIndex!].isMatched = true

                }
                touchedCardIndex = nil
            }
            cards[index].isFaceUp = true
        }
    }
}
