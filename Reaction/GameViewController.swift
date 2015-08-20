//
//  GameViewController.swift
//  Reaction
//
//  Created by Kyle Brooks Robinson on 7/1/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit
import GameKit
import AVFoundation

class GameViewController: UIViewController {
    
    @IBOutlet weak var levelHeader: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var finalScoreLabel: UILabel!
    
    var drumLoop = AVAudioPlayer()
    var riff = AVAudioPlayer()
    var riff2 = AVAudioPlayer()
    var recordScratch = AVAudioPlayer()
    
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
    
    var viewLayer: CALayer {
        
        return gameView.layer
        
    }
    
    var timerBar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 20))
    
    var currentCircles: [GameButton] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        gameOverLabel.hidden = true
        finalScoreLabel.hidden = true
        
        drumLoop = setupAudioPlayerWithFile("drumloop", "wav")
        riff = setupAudioPlayerWithFile("riff", "wav")
        riff2 = setupAudioPlayerWithFile("riff", "wav")
        recordScratch = setupAudioPlayerWithFile("recordScratch", "wav")
        
        drumLoop.play()
        drumLoop.numberOfLoops = -1
        drumLoop.volume = 0.7
        
        riff.volume = 1.0
        riff2.volume = 1.0
        recordScratch.volume = 0.7
        
        println(backgroundColors)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.addGradientLayer(0)
            
        })
        
        timerBar.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(timerBar)
        
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
        
        var cW = (view.frame.width - 120) / 2.5
        var cR = cW / 3
        
        let directions: [(CGFloat,CGFloat)] = levelCoordinates[levelAdjusted]
        
        for c in 0..<directions.count {
            
            var gamePiece = GameButton()
            gamePiece.choice = c
            gamePiece.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            gamePiece.center = view.center
            view.addSubview(gamePiece)
            
            gamePiece.numberOfSides = c == currentCorrectButton ? 11 : levelInfo[levelAdjusted]["sides"] as! Int
            
            gamePiece.addTarget(self, action: "tapCircle:", forControlEvents: .TouchUpInside)
            
            currentCircles.append(gamePiece)
            
            let (dx, dy) = directions[c]
            
            UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                
                gamePiece.alpha = 1.0
                gamePiece.frame.size.width = cW
                gamePiece.frame.size.height = cW
                
                let x = self.view.center.x + dx * (cR + 10)
                let y = self.view.center.y + dy * (cR + 10)
                
                gamePiece.center = CGPoint(x: x, y: y)

            }, completion: nil)
            
        }
        
    }
    
    func animateOldCirclesOut() {
        
        for circle in currentCircles {
            
            let levelAdjusted = (currentLevel - 1)
            
            circle.choice = levelInfo[levelAdjusted]["pieceCount"] as! Int
            
            circle.alpha = 1
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                circle.alpha = 0
                
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
            

            if riff.playing == true {
                
                riff2.play()
                
            } else {
                
                riff.play()
                
            }
            
            let reportScore = GKScore(leaderboardIdentifier: "hendecagonsTapped")
            
            reportScore.value = Int64(currentScore)
            
            GKScore.reportScores([reportScore], withCompletionHandler: { (error) -> Void in
                
                println("reported")
                
            })
            
            var levelAdjusted = (currentLevel - 1)
            
            var buttonCount = UInt32(levelInfo[levelAdjusted]["pieceCount"] as! Double)
            
            currentCorrectButton = Int(arc4random_uniform(buttonCount))
            
            animateOldCirclesOut()
                        
            currentCircles = []
            
            let finishPoint = levelInfo[levelAdjusted]["levelFinish"] as! Int
            
            if currentScore == finishPoint {
                
                currentLevel = currentLevel + 1
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                
                    self.addGradientLayer(levelAdjusted)
                    
                })
                
            }
            
            animateNewCirclesIn()
            
        } else {
            
            runTimer(0)
            
        }
        
    }
    
    func gameOver() {
        
        drumLoop.stop()
        recordScratch.play()
        
        animateOldCirclesOut()
        
        gameOverLabel.hidden = false
        finalScoreLabel.hidden = false
        
        finalScoreLabel.text = "\(currentScore) PoInts"
        
        gameOverLabel.alpha = 0
        finalScoreLabel.alpha = 0
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            
            self.gameOverLabel.alpha = 1
            self.finalScoreLabel.alpha = 1
            self.scoreLabel.alpha = 0
            self.levelLabel.alpha = 0
            self.levelHeader.alpha = 0
            
        }) { (finished) -> Void in
            
            UIView.animateWithDuration(2.5, animations: { () -> Void in
                
                self.finalScoreLabel.alpha = 0
                self.gameOverLabel.alpha = 0
                
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
    
    func addGradientLayer(level: Int) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        
        let firstColor = backgroundColors[level]["color1"]!
        let secondColor = backgroundColors[level]["color2"]!
        
//        println("first color \(firstColor)")
//        println("second color \(secondColor)")
        
        let startPoint = CGPoint(x: 0.0, y: 1.0)
        let endPoint = CGPoint(x: 1.0, y: 0)
        
        gradientLayer.colors = [firstColor.CGColor, secondColor.CGColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        viewLayer.addSublayer(gradientLayer)

    }
    
}






