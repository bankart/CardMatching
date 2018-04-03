//
//  ViewController.swift
//  CardMatching
//
//  Created by taehoon lee on 2018. 4. 2..
//  Copyright © 2018년 taehoon lee. All rights reserved.
//
//  외부에서 읽고/쓰고/호출해도 괜찮으면 internal
//  외부에서 읽기만 하는건 괜찮으면 private(set)
//  내부에서만 사용해야하면 private, 추후에 상황에 따라 접근 제한자는 변경할 수 있으므로 미심적을 때에는 private
//

import UIKit

class ViewController: UIViewController {
//    private var queue: DispatchQueue?
//    private var animationActivated: Bool = false
//    private let targetBgColor: UIColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    private var finished: Bool = false
    
    
    private var emojies = ["🧙‍♂️", "🧛‍♂️", "🧟‍♀️", "👻", "😈", "🎃", "💀", "👽", "🧞‍♂️", "🧜‍♀️", "💃", "👯‍♂️", "🐒"]
    private var emojiesForRandom: [String]?
    private lazy var game: Concentration = {
        // numberOfPairsOfCards 가 UI 와 강하게 결합한 프로퍼티이기 때문에 game 프로퍼티는 private 이 된다.
        return Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    }()
    
    // 카드가 몇 개인지는 프로젝트 내부에서는 알아도 괜찮기 때문에 internal
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    // ViewController 인스턴스에 영향을 주는 프로퍼티이므로 인스턴스 내부에서만 set 할 수 있어야 한다.
    private(set) var flipCount: Int = 0 {
        didSet {
            print("flipCount: \(flipCount), numberOfPairsOfCards: \(numberOfPairsOfCards)")
            if flipCount >= numberOfPairsOfCards {
                restartButton.setTitle("Restart!!", for: .normal)
                restartButton.isUserInteractionEnabled = true
                // delay 시간 동안 self 가 nil 될 수 있으므로 [weak self] 처리 해준다.
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
                    self?.finished = true
                    self?.reloadCards()
                }
            } else {
                restartButton.setTitle("Card Matched: \(flipCount)", for: .normal)
            }
        }
    }
    
    @IBOutlet private weak var restartButton: UIButton!
    @IBOutlet private var cardButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restartGame()
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        guard let emojiIndex = cardButtons.index(of: sender) else {
            print("Oops")
            return
        }
        
        game.chooseCard(at: emojiIndex)
        if game.cards[emojiIndex].isMatched {
            flipCount += 1
        }
        reloadCards()
    }
    
    @IBAction private func restartGame() {
        print("let's play!!!")
        flipCount = 0
        finished = false
        emojiesForRandom = emojies
        game.reset()
        reloadCards()
        restartButton.isUserInteractionEnabled = false
    }
    
    private func reloadCards() {
        for index in cardButtons.indices {
            let btn = cardButtons[index]
            let card = game.cards[index]
            if finished {
                flip(for: btn,
                     with: "",
                     backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            } else {
                flip(for: btn,
                     with: card.isFaceUp ? emoji(for: card) : "",
                     backgroundColor: card.isFaceUp ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : (card.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)))
            }
        }
    }
    
    private func flip(for button: UIButton, with emoji: String, backgroundColor bgColor: UIColor) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(.easeInOut)
        UIView.setAnimationDuration(0.35)
        
        button.setTitle(emoji, for: .normal)
        button.backgroundColor = bgColor
        
        UIView.commitAnimations()
    }
    
    private var emojiDic = [Int: String]()
    private func emoji(for card: Card) -> String {
        if emojiDic[card.identifier] == nil, emojiesForRandom!.count > 0 {
//            // 랜덤 이모지 뽑아내는 코드는 컨버팅이 많고 불편하다. 이런 부분은 extension 으로 뽑아낸다.
//            let randomIndex = Int(arc4random_uniform(UInt32(emojiesForRandom!.count)))
            emojiDic[card.identifier] = emojiesForRandom!.remove(at: emojiesForRandom!.count.arc4random)
        }
        return emojiDic[card.identifier] ?? "??"
    }
    
}


extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
