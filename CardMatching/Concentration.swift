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
    private var touchedCardIndex: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
                print(cards[index])
            }
        }
    }
    private(set) var cards = [Card]()
    private var numberOfPairsOfCards: Int = -1
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(numberOfPairsOfCards: \(numberOfPairsOfCards)): you must have at least one pair of card")
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
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not int the cards")
        if !cards[index].isMatched {
            if let matchIndex = touchedCardIndex, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    print("matched!!!")
                }
                cards[index].isFaceUp = true
            } else {
                touchedCardIndex = index
            }
        }
    }
}
