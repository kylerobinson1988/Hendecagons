//
//  LevelInfo.swift
//  Reaction
//
//  Created by Kyle Brooks Robinson on 7/29/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

var levelInfo: [[String:AnyObject]] = []
var levelCoordinates: [[(CGFloat, CGFloat)]] = []

var backgroundColors: [[String:UIColor]] = []
var backgroundCoordinates: [[String:AnyObject]] = []

var directions: [(CGFloat, CGFloat)] = [(0,3.5),(-2.5,3),(-2.5,-3),(0,-3.5),(2.5,-3),(2.5,3),(0,1.5),(-1.75,0.5),(-1,-1.5),(1,-1.5),(1.75,0.5)]