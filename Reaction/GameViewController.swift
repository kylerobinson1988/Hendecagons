//
//  GameViewController.swift
//  Reaction
//
//  Created by Kyle Brooks Robinson on 7/1/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit
import GameKit

class GameViewController: UIViewController {
    
    @IBOutlet var background: GradientView!
    @IBOutlet weak var levelLabel: UILabel!
    
    var currentScore = 0 {
        
        didSet {
            
            scoreLabel.text = "\(currentScore)"
            
        }
        
    }
    
    var currentLevel = 1 {
        
        didSet {
            
            levelLabel.text = "\(currentLevel)"
            
        }
        
    }
    
    var scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
    
    var timerBar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 20))
    
    var currentCircles: [HendecagonButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerBar.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(timerBar)
        
        scoreLabel.textColor = UIColor.whiteColor()
        scoreLabel.font = UIFont(name: "Geomancy-Hairline", size: 80)
        scoreLabel.text = "0"
        scoreLabel.frame.origin.y = view.frame.height - 120
        scoreLabel.frame.size.width = view.frame.width
        scoreLabel.textAlignment = NSTextAlignment.Center
        
        view.addSubview(scoreLabel)
        
        animateNewCirclesIn()

    }
    
    func runTimer(seconds: NSTimeInterval) {
        
        timerBar.layer.removeAllAnimations()
        
        timerBar.frame.size.width = view.frame.width
        
        UIView.animateWithDuration(seconds, animations: { () -> Void in
            
            self.timerBar.frame.size.width = 0
            
        }) { (finished) -> Void in
            
            if finished { self.gameOver() }
            
        }
        
    }

    func animateNewCirclesIn() {
        
        let levelAdjusted = (currentLevel - 1)
        
        let adjustedTimeInterval: NSTimeInterval = NSTimeInterval((levelInfo[levelAdjusted]["levelTimer"] as! Double))
        
        runTimer(adjustedTimeInterval)
        
        var cW = (view.frame.width - 120) / 3
        var cR = cW / 2
        
        let directions: [(CGFloat,CGFloat)] = levelCoordinates[levelAdjusted]
        
        for c in 0..<directions.count {
            
            var gamePiece = HendecagonButton()
            gamePiece.choice = c
            gamePiece.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            gamePiece.center = view.center
            view.addSubview(gamePiece)
            
            gamePiece.alpha = c == currentCorrectButton ? 1.0 : 0.5
            
            gamePiece.addTarget(self, action: "tapCircle:", forControlEvents: .TouchUpInside)
            
            currentCircles.append(gamePiece)
            
            let (dx, dy) = directions[c]
            
            UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                
                gamePiece.alpha = 0.5
                gamePiece.frame.size.width = cW
                gamePiece.frame.size.height = cW
                
                let x = self.view.center.x + dx * (cR + 10)
                let y = self.view.center.y + dy * (cR + 10)
                
                gamePiece.center = CGPoint(x: x, y: y)

            }, completion: nil)
            
        }
        
    }
    
    func animateOldCirclesOut() {
        
        var cW = (view.frame.width - 120) / 2 * 3
        
        for circle in currentCircles {
        
            circle.choice = 4
            
            let distX = circle.center.x - view.center.x
            let distY = circle.center.y - view.center.y
            
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                
                circle.frame.size.width = cW
                circle.frame.size.height = cW
                
                circle.center = CGPoint(x: distX * 6 + self.view.center.x, y: distY * 6 + self.view.center.y)
                
            }, completion: { (finished) -> Void in
                
                circle.removeFromSuperview()
                
            })
            
        }
        
        
    }
    
    var currentCorrectButton: Int = 0
    
    func tapCircle(circle: HendecagonButton) {
        
        // Check if it's the correct button.
        
        if circle.choice == currentCorrectButton {
            
            currentScore++
            
            let reportScore = GKScore(leaderboardIdentifier: "circles_touched")
            
            reportScore.value = Int64(currentScore)
            
            GKScore.reportScores([reportScore], withCompletionHandler: { (error) -> Void in
                
//                println("reported")
                
            })
            
            var levelAdjusted = (currentLevel - 1)
            
            var buttonCount = UInt32(levelInfo[levelAdjusted]["pieceCount"] as! Double)
            
            currentCorrectButton = Int(arc4random_uniform(buttonCount))
            
            animateOldCirclesOut()
            
            currentCircles = []
            
            let finishPoint = levelInfo[levelAdjusted]["levelFinish"] as! Int
            
            if currentScore == finishPoint {
                
                currentLevel = currentLevel + 1
                println("The level just went up!")
                println(currentLevel)
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                
                    self.background.firstColor = backgroundColors[levelAdjusted]["color1"]!
                    self.background.secondColor = backgroundColors[levelAdjusted]["color2"]!
                    
                    let startX = backgroundCoordinates[levelAdjusted]["startX"] as! CGFloat
                    let startY = backgroundCoordinates[levelAdjusted]["startY"] as! CGFloat
                    let endX = backgroundCoordinates[levelAdjusted]["endX"] as! CGFloat
                    let endY = backgroundCoordinates[levelAdjusted]["endY"] as! CGFloat
                    
                    self.background.startPoint = CGPoint(x: startX, y: startY)
                    self.background.endPoint = CGPoint(x: startX, y: startY)
                    
                    let rect = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
                    self.background.drawRect(rect)
                    
                    println("The background should have just changed.")
                    
                })
                
            }
            
            animateNewCirclesIn()
            
        } else {
            
            gameOver()
            
        }
        
    }
    
    func gameOver() {
        
        animateOldCirclesOut()
        
        let gameOverLabel = UILabel(frame: view.frame)
        gameOverLabel.textAlignment = .Center
        gameOverLabel.textColor = UIColor.whiteColor()
        gameOverLabel.text = "Game Over"
        gameOverLabel.font = UIFont(name: "Geomancy-Hairline", size: 50)
        
        gameOverLabel.alpha = 0
        
        view.addSubview((gameOverLabel))
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            
            gameOverLabel.alpha = 1
            self.scoreLabel.alpha = 0
            
        }) { (finished) -> Void in
            
            UIView.animateWithDuration(2.5, animations: { () -> Void in
                
                gameOverLabel.alpha = 0
                
                }) { (finished) -> Void in
            
                    self.endGame()
        
            }
        }
        
    }
    
    func endGame() {
        
        if let startVC = storyboard?.instantiateViewControllerWithIdentifier("StartVC") as? MainMenuViewController {
        
            navigationController?.viewControllers = [startVC]
        
        }
            
    }
    
}
