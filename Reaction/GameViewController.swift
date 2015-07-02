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
    
    var currentScore = 0 {
        
        didSet {
            
            scoreLabel.text = "\(currentScore)"
            
        }
        
    }
    
    var currentLevel = 1 {
        
        didSet {
            
            // Update the Level label here.
            
        }
        
    }
    
    var scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 100))

//    var levelLabel = UILabel(frame: CGRect(x: 100, y: 0, width: , height: <#CGFloat#>))
    
    var timerBar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
    
    var currentCircles: [HendecagonButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timerBar.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(timerBar)
        
        scoreLabel.textColor = UIColor.whiteColor()
        scoreLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 80)
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
        
        runTimer(2.0)
        
        var cW = (view.frame.width - 120) / 2
        var cR = cW / 2
        
        // Top left, top right, bottom left, bottom right
        var directions: [(CGFloat,CGFloat)] = [(-1,-1),(1,-1),(-1,1),(1,1)]
        
        for c in 0..<4 {
            
            var circle = HendecagonButton()
            circle.choice = c
            circle.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            circle.center = view.center
            view.addSubview(circle)
            
            circle.alpha = c == currentCorrectButton ? 1.0 : 0.5
            
            circle.addTarget(self, action: "tapCircle:", forControlEvents: .TouchUpInside)
            
            currentCircles.append(circle)
            
            let (dx, dy) = directions[c]
            
            UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                
                circle.alpha = 0.5
                
//                circle.backgroundColor = UIColor(patternImage: UIImage(named: "Porkins.jpg")!)
                
                circle.frame.size.width = cW
                circle.frame.size.height = cW
                
                let x = self.view.center.x + dx * (cR + 10)
                let y = self.view.center.y + dy * (cR + 10)
                
                circle.center = CGPoint(x: x, y: y)

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var currentCorrectButton: Int = 0
    
    func tapCircle(circle: HendecagonButton) {
        
        // Check if it's the correct button.
        
        if circle.choice == currentCorrectButton {
            
            currentScore++
            
            let reportScore = GKScore(leaderboardIdentifier: "circles_touched")
            
            reportScore.value = Int64(currentScore)
            
            GKScore.reportScores([reportScore], withCompletionHandler: { (error) -> Void in
                
                println("reported")
                
            })
            
            currentCorrectButton = Int(arc4random_uniform(4))
            
            animateOldCirclesOut()
            currentCircles = []
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
        gameOverLabel.font = UIFont(name: "HelveticNeue-UltraLight", size: 100)
        
        gameOverLabel.alpha = 0
        
        view.addSubview((gameOverLabel))
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            
            gameOverLabel.alpha = 1
            self.scoreLabel.alpha = 0
            
        }) { (finished) -> Void in
            
            UIView.animateWithDuration(1.6, animations: { () -> Void in
                
                gameOverLabel.alpha = 0
                
                }) { (finished) -> Void in
            
                    self.endGame()
        
            }
        }
        
    }
    
    func endGame() {
        
        if let startVC = storyboard?.instantiateViewControllerWithIdentifier("StartVC") as? ViewController {
        
            navigationController?.viewControllers = [startVC]
        
        }
            
    }
    
}
