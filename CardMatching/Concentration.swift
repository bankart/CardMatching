//
//  Concentration.swift
//  CardMatching
//
//  Created by taehoon lee on 2018. 4. 2..
//  Copyright © 2018년 taehoon lee. All rights reserved.
//
//  release note link: https://developer.apple.com/library/content/releasenotes/DeveloperTools/RN-Xcode/Chapters/Introduction.html
//  > Hashable 채택하면 enum, struct 인 경우에 변수들은 hashValue 로 동작하고, == 함수는 자동으로 구현된다.
//    구현하지 않아도 에러가 나지 않고 정상동작해서 확인해보니 이런 신세계가!!! [2018/4/3]
//

import Foundation

struct Card: Hashable {
    var isFaceUp: Bool = false
    var isMatched: Bool = false
    private var identifier: Int
    var hashValue: Int {
        return identifier
    }
    
    private static var uniqueIdentifier: Int = -1
    static func getUniqueIdentifier() -> Int {
        uniqueIdentifier += 1
        return uniqueIdentifier
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

struct Concentration {
    private var touchedCardIndex: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.onAndOnly
            
//            let faceUpCardIndices = cards.indices.filter { cards[$0].isFaceUp }
//            return faceUpCardIndices.last
            
//            var foundIndex: Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if foundIndex == nil {
//                        foundIndex = index
//                    } else {
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
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
    
    mutating func reset() {
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
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not int the cards")
        if !cards[index].isMatched {
            if let matchIndex = touchedCardIndex, matchIndex != index {
                if cards[matchIndex] == cards[index] {
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


extension Collection {
    var onAndOnly: Element? {
        return count == 1 ? first : nil
    }
}

