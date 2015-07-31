
//  GameViewController.swift
//  Reaction
//
//  Created by Kyle Brooks Robinson on 7/1/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit
import GameKit
import Parse
import Bolts
import AVFoundation

class MainMenuViewController: UIViewController, GKGameCenterControllerDelegate {

    @IBOutlet weak var logo: UILabel!
    @IBOutlet weak var leaderboardButton: UIButton!
    @IBOutlet weak var goLabel: UIButton!
    @IBOutlet weak var topScoreLabel: UILabel!
    @IBOutlet weak var rotatingHendecagon: RotatingHendecagon!
    
    var mainMenu = AVAudioPlayer()
    var boom = AVAudioPlayer()
    
    var rotatingShape = false
    var stopRotating = false
    var parseInfo1 = false
    var parseInfo2 = false
    
    var responseInfo = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getInfoFromParse()
        
        rotatingHendecagon.rotate360Degrees(completionDelegate: self)
        
        topScoreLabel.alpha = 0
        
        mainMenu = setupAudioPlayerWithFile("mainMenu", "wav")
        boom = setupAudioPlayerWithFile("boom", "wav")
        
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
            self.mainMenu.play()

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
        
        if parseInfo1 && parseInfo2 == true {
            
            if let gameVC = storyboard?.instantiateViewControllerWithIdentifier("GameVC") as? GameViewController {
                
                boom.play()
                
                UIView.animateWithDuration(2.5, animations: { () -> Void in
                    
                    navigationController?.viewControllers = [gameVC]

                    
                })
                
            }
            
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
    
    func getInfoFromParse() {
        
        let levels = PFQuery(className: "levels")
        let backgroundHexColors = PFQuery(className: "backgroundColors")
        
        levels.orderByAscending("levelNumber")
        backgroundHexColors.orderByAscending("level")
        
        levels.findObjectsInBackgroundWithBlock { (objects, error) -> Void in 
            
            if error == nil {
                
                println("No level errors.")
                
                if let objects = objects as? [PFObject] {
                    
                    for item in objects {
                        
                        let levelFinish = item["levelFinish"] as! Int
                        let levelNumber = item["levelNumber"] as! Int
                        let pieceCount = item["pieceCount"] as! Int
                        let levelTimer = item["timer"] as! Double
                        let sides = item["sides"] as! Int
                        
                        var coordinates: [(CGFloat, CGFloat)] = []
                        
                        if let the1 = item["the1"] as? [Double] {
                            
                            let x = CGFloat(the1[0])
                            let y = CGFloat(the1[1])
                            coordinates.append((x,y))
                            
                        }
                        
                        if let the2 = item["the2"] as? [Double] {
                            
                            let x = CGFloat(the2[0])
                            let y = CGFloat(the2[1])
                            coordinates.append((x,y))
                            
                        }
                        
                        if let the3 = item["the3"] as? [Double] {
                            
                            let x = CGFloat(the3[0])
                            let y = CGFloat(the3[1])
                            coordinates.append((x,y))
                            
                        }
                        
                        if let the4 = item["the4"] as? [Double] {
                            
                            let x = CGFloat(the4[0])
                            let y = CGFloat(the4[1])
                            coordinates.append((x,y))
                            
                        }
                        
                        if let the5 = item["the5"] as? [Double] {
                            
                            let x = CGFloat(the5[0])
                            let y = CGFloat(the5[1])
                            coordinates.append((x,y))
                            
                        }
                        
                        if let the6 = item["the6"] as? [Double] {
                            
                            let x = CGFloat(the6[0])
                            let y = CGFloat(the6[1])
                            coordinates.append((x,y))
                            
                        }
                        
                        if let the7 = item["the7"] as? [Double] {
                            
                            let x = CGFloat(the7[0])
                            let y = CGFloat(the7[1])
                            coordinates.append((x,y))
                            
                        }
                        
                        if let the8 = item["the8"] as? [Double] {
                            
                            let x = CGFloat(the8[0])
                            let y = CGFloat(the8[1])
                            coordinates.append((x,y))
                            
                        }
                        
                        if let the9 = item["the9"] as? [Double] {
                            
                            let x = CGFloat(the9[0])
                            let y = CGFloat(the9[1])
                            coordinates.append((x,y))
                            
                        }
                        
                        if let the10 = item["the10"] as? [Double] {
                            
                            let x = CGFloat(the10[0])
                            let y = CGFloat(the10[1])
                            coordinates.append((x,y))
                            
                        }
                        
                        if let the11 = item["the11"] as? [Double] {
                            
                            let x = CGFloat(the11[0])
                            let y = CGFloat(the11[1])
                            coordinates.append((x,y))
                            
                        }
                        
                        let newCollection: [String: AnyObject] = [
                            
                            "levelFinish": levelFinish,
                            "levelNumber": levelNumber,
                            "pieceCount": pieceCount,
                            "levelTimer": levelTimer,
                            "sides": sides,
                            
                        ]
                        
                        levelInfo.append(newCollection)
                        levelCoordinates.append(coordinates)
                        
                    }
                    
                    self.parseInfo1 = true
//                    println("Level Info! \(levelInfo)")
//                    println("Coordinates! \(levelCoordinates)")
                    
                }
                
            }
            
        }
        
        backgroundHexColors.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if error == nil {
                
                if let objects = objects as? [PFObject] {
                    
                    println(objects)
                    
                    for item in objects {
                        
                        let color1 = item["color1"] as? String
                        let color2 = item["color2"] as? String
                        
                        let newColor1: UIColor = self.stringHexToColor(color1!)
                        let newColor2: UIColor = self.stringHexToColor(color2!)
                        
                        let newColors: [String:UIColor] = [
                            
                            "color1": newColor1,
                            "color2": newColor2,
                            
                        ]
                        
                        backgroundColors.append(newColors)
                        
                        let startX = item["startX"] as? Int
                        let startY = item["startY"] as? Int
                        let endX = item["endX"] as? Int
                        let endY = item["endY"] as? Int
                        
                        let newCoordinates = [
                            
                            "startX": startX!,
                            "startY": startY!,
                            "endX": endX!,
                            "endY": endY!,
                            
                        ]
                        
                        backgroundCoordinates.append(newCoordinates)
                        
                    }
                    
                    self.parseInfo2 = true
                    println("Background colors!")
//                    println(backgroundColors)
                    println("Background coordinates!")
//                    println(backgroundCoordinates)

                }
                
            }
            
        }
        
    }
    
   
    func stringHexToColor(color: String) -> UIColor {
        
        var colorString: String = color.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if colorString.hasPrefix("#") {
            
            colorString = (colorString as NSString).substringFromIndex(1)
            
        }
        
        if count(colorString) != 6 {
            
            return UIColor.grayColor()
            
        }
        
        var rString = (colorString as NSString).substringToIndex(2)
        var gString = ((colorString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        var bString = ((colorString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r: CUnsignedInt = 0
        var g: CUnsignedInt = 0
        var b: CUnsignedInt = 0
        
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
        
    }


}

func setupAudioPlayerWithFile(file: String, type: String) -> AVAudioPlayer {
    
    var path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
    var url = NSURL.fileURLWithPath(path!)
    
    var error: NSError?
    
    var audioPlayer: AVAudioPlayer?
    
    audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
    
    return audioPlayer!
    
}








