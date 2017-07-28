//
//  Drawing.swift
//  iOSTools
//
//  Created by Antoine Clop on 7/27/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import Foundation

/**
 All these functions MUST be called from a draw(_ rect) method to get a valid UIGraphicsGetCurrentContext
 */
public class Drawer {
  
  /**
   Will draw a line between 2 CGPoints
   
   - parameter p1: the start position
   - parameter p2: the arrival position
   - parameter color: the color of the line
   - parameter width: the width of the line
   */
  public static func drawLine(between p1: CGPoint, and p2: CGPoint, color: UIColor, width: CGFloat = 1) {
    if let context = UIGraphicsGetCurrentContext() {
      context.setLineWidth(width)
      context.addLines(between: [p1, p2])
      context.setStrokeColor(color.cgColor)
      context.setLineCap(.square)
      context.strokePath()
    }
    else {
      debugPrint("[ERROR]: Cannot get current context to draw line")
    }
  }
}
