//
//  Pixel.swift
//  iOSTools
//
//  Created by Antoine Clop on 7/27/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import Foundation

public extension CALayer {
  
  public func colorOfPixel(point: CGPoint) -> UIColor? {
    var pixel: [CUnsignedChar] = [0, 0, 0, 0]
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
    let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
    if let context = context {
      context.translateBy(x: -point.x, y: -point.y)
      self.render(in: context)
      let red: CGFloat   = CGFloat(pixel[0]) / 255.0
      let green: CGFloat = CGFloat(pixel[1]) / 255.0
      let blue: CGFloat  = CGFloat(pixel[2]) / 255.0
      let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
      return color
    }
    return nil
  }
}
