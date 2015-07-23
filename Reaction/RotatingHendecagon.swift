//
//  RotatingHendecagon.swift
//  Reaction
//
//  Created by Kyle Brooks Robinson on 7/3/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

@IBDesignable class RotatingHendecagon: UIView {
    
    let shapeLayer = CAShapeLayer()
    let maskLayer = CAShapeLayer()
    var hendecPath = UIBezierPath()
    
    var choice: Int!
    var spinWithOptions: Bool?
    
    @IBInspectable var fillColor: UIColor = UIColor.whiteColor()
    
    override func drawRect(rect: CGRect) {
        
        var context = UIGraphicsGetCurrentContext()
        
        drawPolygonBezier(x: CGRectGetMidX(rect), y: CGRectGetMidY(rect), radius: CGRectGetWidth(rect) / 2, sides: 11, color: UIColor.whiteColor())
        
    }
    
    func drawPolygonBezier(#x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, color:UIColor) {
        let path = polygonPath(x: x, y: y, radius: radius, sides: sides)
        let bez = UIBezierPath(CGPath: path)
        // no need to convert UIColor to CGColor when using UIBezierPath
        color.setFill()
        bez.fill()
    }
    
    func polygonPath(#x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int) -> CGPathRef {
        let path = CGPathCreateMutable()
        let points = polygonPointArray(sides,x: x,y: y,radius: radius)
        var cpg = points[0]
        CGPathMoveToPoint(path, nil, cpg.x, cpg.y)
        for p in points {
            CGPathAddLineToPoint(path, nil, p.x, p.y)
        }
        CGPathCloseSubpath(path)
        return path
    }
    
    func degree2radian(a:CGFloat)->CGFloat {
        let b = CGFloat(M_PI) * a/180
        return b
    }
    
    func polygonPointArray(sides:Int,x:CGFloat,y:CGFloat,radius:CGFloat)->[CGPoint] {
        let angle = degree2radian(360/CGFloat(sides))
        let cx = x // x origin
        let cy = y // y origin
        let r  = radius // radius of circle
        var i = 0
        var points = [CGPoint]()
        while i <= sides {
            var xpo = cx + r * cos(angle * CGFloat(i))
            var ypo = cy + r * sin(angle * CGFloat(i))
            points.append(CGPoint(x: xpo, y: ypo))
            i++;
        }
        return points
    }
    


    
//    func prepareForEditing(editing:Bool){
//        
//        let animation = CABasicAnimation(keyPath: "path")
//        animation.duration = 10
//        
        // Your new shape here
//        animation.toValue = 
//        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        // The next two line preserves the final shape of animation,
        // if you remove it the shape will return to the original shape after the animation finished
//        animation.fillMode = kCAFillModeForwards
//        animation.removedOnCompletion = false
//        
//        shapeLayer.addAnimation(animation, forKey: nil)
//        maskLayer.addAnimation(animation, forKey: nil)
//    }
    
}
