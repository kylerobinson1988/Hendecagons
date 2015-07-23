
//  ViewController.swift
//  Reaction
//
//  Created by Kyle Brooks Robinson on 7/1/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit
import GameKit

class ViewController: UIViewController, GKGameCenterControllerDelegate {

    @IBOutlet weak var logo: UILabel!
    @IBOutlet weak var leaderboardButton: UIButton!
    @IBOutlet weak var goLabel: UIButton!
    @IBOutlet weak var topScoreLabel: UILabel!
    @IBOutlet weak var rotatingHendecagon: RotatingHendecagon!
    
    var rotatingShape = false
    var stopRotating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rotatingHendecagon.rotate360Degrees(completionDelegate: self)
        
        topScoreLabel.alpha = 0
        
        goLabel.frame.size.width = 0
        goLabel.frame.size.height = 0
        goLabel.center = view.center
        goLabel.alpha = 0
        goLabel.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            
            self.goLabel.alpha = 1
            self.goLabel.transform = CGAffineTransformMakeScale(1.0, 1.0)
            
        })
        
        self.logo.center.y -= self.view.frame.height

        UIView.animateWithDuration(2.0, animations: { () -> Void in
            
            self.logo.center.y += self.view.frame.height

        })
        
        
        GKLocalPlayer.localPlayer().authenticateHandler = { (viewController, error) -> Void in
            
            if viewController != nil {
                
                self.presentViewController(viewController, animated: true, completion: nil)
                
            } else {
                
                println(GKLocalPlayer.localPlayer().authenticated)
                self.loadScore()
                
            }
            
        }
        
        
    }
    
    func refresh() {
        
        if self.rotatingShape == false {
            
            self.rotatingHendecagon.rotate360Degrees(completionDelegate: self)

            self.rotatingShape = true
            
        }
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        if self.stopRotating == false {
            
            self.rotatingHendecagon.rotate360Degrees(completionDelegate: self)
        
        } else {
        
            self.reset()
        
        }
        
    }
    
    func reset() {
        self.rotatingShape = false
        self.stopRotating = false
    }
    
    override func viewWillAppear(animated: Bool) {
        
        loadScore()
        
    }
    
    func loadScore() {
        
        if GKLocalPlayer.localPlayer().authenticated == false { return }
        
        GKLeaderboard.loadLeaderboardsWithCompletionHandler { (leaderboards, error) -> Void in
            
            println(leaderboards)
            
            for leaderboard in leaderboards as! [GKLeaderboard] {
                
                if leaderboard.identifier == "circles_touched" {
                    
                    leaderboard.loadScoresWithCompletionHandler({ (scores, error) -> Void in
                        
                        if leaderboard.localPlayerScore != nil {

                            self.topScoreLabel.text = "\(leaderboard.localPlayerScore.value)"
                                UIView.animateWithDuration(0.4, animations: { () -> Void in
                                    
                                    self.topScoreLabel.alpha = 1
                                    
                                })
                            
                        }
                        
                    })
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func goButton(sender: AnyObject) {
    
        if let gameVC = storyboard?.instantiateViewControllerWithIdentifier("GameVC") as? GameViewController {
            
            navigationController?.viewControllers = [gameVC]
            
        }
    
    }
    
    @IBAction func leaderboardButtonPressed(sender: AnyObject) {
    
        let gameVC = GKGameCenterViewController()
        gameVC.leaderboardIdentifier = "circles_touched"
        gameVC.gameCenterDelegate = self
        presentViewController(gameVC, animated: true, completion: nil)
    
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

