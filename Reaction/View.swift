//
//  View.swift
//  Reaction
//
//  Created by Kyle Brooks Robinson on 7/22/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

// I added this extension based on code from this link: http://www.andrewcbancroft.com/2014/10/15/rotate-animation-in-swift/

import UIKit

extension UIView {
    
    func rotate360Degrees(duration: CFTimeInterval = 10.0, completionDelegate: AnyObject? = nil) {
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            
            rotateAnimation.delegate = delegate
            
        }
        
        self.layer.addAnimation(rotateAnimation, forKey: nil)
    
    }

}