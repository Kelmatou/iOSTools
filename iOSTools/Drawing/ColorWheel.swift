//
//  ColorWheel.swift
//  iOSTools
//
//  Created by Antoine Clop on 7/27/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import UIKit

@objc public protocol ColorWheelDelegate: class {
  
  @objc optional func didSelectColor(_ colorWheel: ColorWheel, color: UIColor)
}

public class ColorWheel: UIView {
  
  public enum ColorWheelOrientation {
    case Horizontal
    case Vertical
  }
  
  // MARK: - Variable
  
  public weak var delegate: ColorWheelDelegate?
  private var needsUpdate: Bool = true
  public var orientation: ColorWheelOrientation = .Horizontal
  override public var bounds: CGRect {
    didSet {
      needsUpdate = true
    }
  }
  
  // MARK: - Drawing
  
  override public func draw(_ rect: CGRect) {
    if needsUpdate {
      needsUpdate = false
      drawColorWheel(rect)
      debugPrint("[DRAW] has a valid context: \(UIGraphicsGetCurrentContext() != nil)")
    }
  }
  
  public init(_ rect: CGRect, orientation: ColorWheelOrientation) {
    super.init(frame: rect)
    self.orientation = orientation
    setNeedsLayout()
    debugPrint("[INIT]")
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    orientation = .Horizontal
  }
  
  private func drawColorWheel(_ rect: CGRect) {
    let lastIndex: Int = Int(orientation == .Horizontal ? rect.height : rect.width)
    let distanceBetweenColorPick: Int = (lastIndex - 2) / 6
    let colorAdd: Int = (255 / distanceBetweenColorPick) < 1 ? 1 : (255 / distanceBetweenColorPick)
    var r: Int = 255
    var g: Int = 0
    var b: Int = 0
    var currentColor: UIColor = .red
    for index in 1..<lastIndex {
      let currentColorPick: Int = (index - 1) / distanceBetweenColorPick
      switch currentColorPick {
      case 0:
        g = g + colorAdd <= 255 ? (g + colorAdd) : 255
      case 1:
        r = r > colorAdd ? (r - colorAdd) : 0
      case 2:
        b = b + colorAdd <= 255 ? (b + colorAdd) : 255
      case 3:
        g = g > colorAdd ? (g - colorAdd) : 0
      case 4:
        r = r + colorAdd <= 255 ? (r + colorAdd) : 255
      case 5:
        b = b > colorAdd ? (b - colorAdd) : 0
      default:
        break
      }
      currentColor = UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1)
      var startPoint: CGPoint {
        if orientation == .Horizontal {
          return CGPoint(x: rect.origin.x, y: rect.origin.y + CGFloat(index))
        }
        else {
          return CGPoint(x: rect.origin.x + CGFloat(index), y: rect.origin.y)
        }
      }
      var endPoint: CGPoint {
        if orientation == .Horizontal {
          return CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + CGFloat(index))
        }
        else {
          return CGPoint(x: rect.origin.x + CGFloat(index), y: rect.origin.y + rect.height)
        }
      }
      Drawer.drawLine(between: startPoint, and: endPoint, color: currentColor)
    }
    if orientation == .Horizontal {
      Drawer.drawLine(between: CGPoint(x: rect.origin.x, y: rect.origin.y), and: CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y), color: .white)
      Drawer.drawLine(between: CGPoint(x: rect.origin.x, y: rect.origin.y + rect.height), and: CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + rect.height), color: .black)
    }
    else {
      Drawer.drawLine(between: CGPoint(x: rect.origin.x, y: rect.origin.y), and: CGPoint(x: rect.origin.x, y: rect.origin.y + rect.height), color: .white)
      Drawer.drawLine(between: CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y), and: CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + rect.height), color: .black)
    }
  }
  
  // MARK: - Interaction
  
  override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      let position: CGPoint = touch.location(in: self)
      if let newColor = self.layer.colorOfPixel(point: position) {
        didSelectColor(self, color: newColor)
      }
    }
  }
  
  override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      let position: CGPoint = touch.location(in: self)
      if let newColor = self.layer.colorOfPixel(point: position) {
        didSelectColor(self, color: newColor)
      }
    }
  }
  
  override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      let position: CGPoint = touch.location(in: self)
      if let newColor = self.layer.colorOfPixel(point: position) {
        didSelectColor(self, color: newColor)
      }
    }
  }
}

extension ColorWheel: ColorWheelDelegate {
  
  public func didSelectColor(_ colorWheel: ColorWheel, color: UIColor) {
    if let delegate = delegate, let didSelectColor = delegate.didSelectColor {
      didSelectColor(colorWheel, color)
    }
  }
}
