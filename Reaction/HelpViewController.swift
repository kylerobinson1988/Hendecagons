//
//  HelpViewController.swift
//  Reaction
//
//  Created by Kyle Brooks Robinson on 8/11/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var hendecagonsLabel: UILabel!
    @IBOutlet weak var helpText: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.welcomeLabel.center.y -= self.view.frame.height
        self.hendecagonsLabel.center.y -= self.view.frame.height
        self.helpText.alpha = 0
        self.backButton.center.y += self.view.frame.height
        
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            
            self.welcomeLabel.center.y += self.view.frame.height
            self.hendecagonsLabel.center.y += self.view.frame.height
            self.helpText.alpha = 1
            self.backButton.center.y -= self.view.frame.height

        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
    
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            
            self.welcomeLabel.center.y -= self.view.frame.height
            self.hendecagonsLabel.center.y -= self.view.frame.height
            self.helpText.alpha = 0
            self.backButton.center.y += self.view.frame.height
            
            self.dismissViewControllerAnimated(true, completion: nil)

        })
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
