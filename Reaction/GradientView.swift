//
//  GradientView.swift
//  Reaction
//
//  Created by Kyle Brooks Robinson on 7/1/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView {

    @IBInspectable var firstColor: UIColor = UIColor.whiteColor()
    @IBInspectable var secondColor: UIColor = UIColor.blackColor()
    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0)
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0)
    
    override func drawRect(rect: CGRect) {
        
        var gl = CAGradientLayer()
        gl.frame = layer.bounds
        gl.colors = [firstColor.CGColor, secondColor.CGColor]
        gl.startPoint = startPoint
        gl.endPoint = endPoint
        gl.locations = [0.0, 1.0]
        layer.insertSublayer(gl, atIndex: 0)
        
    }

}

//@IBDesignable class NewGradientView: UIView {
//    
//    @IBInspectable var firstColor: UIColor?
//    @IBInspectable var secondColor: UIColor?
//    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0)
//    @IBInspectable var endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0)
//    
//    override func drawRect(rect: CGRect) {
//        
//        var gl = CAGradientLayer()
//        gl.frame = layer.bounds
//        gl.colors = [firstColor!.CGColor, secondColor.CGColor]
//        gl.startPoint = startPoint
//        gl.endPoint = endPoint
//        gl.locations = [0.0, 1.0]
//        layer.insertSublayer(gl, atIndex: 0)
//        
//    }
//    
//}
