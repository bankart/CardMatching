//
//  ViewController.swift
//  CardMatching
//
//  Created by taehoon lee on 2018. 4. 2..
//  Copyright © 2018년 taehoon lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var animationActivated: Bool = false
    private let targetBgColor: UIColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    private var flipCount: Int = 0 {
        didSet {
            restartButton.setTitle("Restart!! (flipted: \(flipCount))", for: .normal)
            print("flipCount: \(flipCount), warningCount: \(warningCount)")
//            if flipCount >= warningCount, animationActivated == false {
//                startAinmation()
//            }
        }
    }
    
    private var emojies = ["🧙‍♂️", "🧛‍♂️", "🧟‍♀️", "👻", "😈", "🎃", "💀", "👽", "🧞‍♂️", "🧜‍♀️", "💃", "👯‍♂️", "🐒"]
    
    private lazy var game: Concentration = {
        return Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    }()
    
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet var cardButtons: [UIButton]!
    private lazy var warningCount: Int = {
        return cardButtons.count / 2
    }()
    
    @IBAction func touchCard(_ sender: UIButton) {
        guard let emojiIndex = cardButtons.index(of: sender) else {
            print("Oops")
            return
        }
        
        flipCount += 1
        game.chooseCard(at: emojiIndex)
        reloadCards()
    }
    
    @IBAction func restartGame() {
        print("let's play more!!!")
//        stopAnimation()
        flipCount = 0
        game.reset()
        reloadCards()
    }
    
//    private func startAinmation() {
//        print("\(#function)")
//        animationActivated = true
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
//            if self.view.backgroundColor == self.targetBgColor {
//                self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//            } else {
//                self.view.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
//            }
//        }
//    }
//
//    private func stopAnimation() {
//        print("\(#function)")
//        animationActivated = false
//        DispatchQueue.main.suspend()
//        self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//    }
    
    private func reloadCards() {
        for index in cardButtons.indices {
            let btn = cardButtons[index]
            let card = game.cards[index]
            flip(for: btn,
                 with: card.isFaceUp ? emoji(for: card) : "",
                 backgroundColor: card.isFaceUp ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1))
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
        if emojiDic[card.identifier] == nil, emojies.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojies.count)))
            emojiDic[card.identifier] = emojies.remove(at: randomIndex)
        }
        return emojiDic[card.identifier] ?? "??"
    }
    
}

