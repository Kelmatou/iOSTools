//
//  SongProgressView.swift
//  iOSTools
//
//  Created by Antoine Clop on 12/7/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import UIKit

@objc public protocol SongProgressViewDelegate: class {
  @objc optional func touchBegan(_ view: SongProgressView, touch: UITouch)
  @objc optional func touchMoved(_ view: SongProgressView, touch: UITouch)
  @objc optional func touchEnded(_ view: SongProgressView, touch: UITouch)
}

public class SongProgressView: UIProgressView {

  // MARK: - Properties
  
  public weak var delegate: SongProgressViewDelegate?
  public var canMoveInSong: Bool = true
  
  // MARK: - Touches
  
  override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      setProgress(from: touch)
      touchBegan(self, touch: touch)
    }
  }
  
  override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      setProgress(from: touch)
      touchMoved(self, touch: touch)
    }
  }
  
  override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      setProgress(from: touch)
      touchEnded(self, touch: touch)
    }
  }
  
  // MARK: - Tools
  
  public func enable() {
    isUserInteractionEnabled = true
  }
  
  public func resetAndDisable() {
    setProgress(0, animated: false)
    isUserInteractionEnabled = false
  }
  
  internal func setProgress(from touch: UITouch) {
    let position: CGPoint = touch.location(in: self)
    let proportion: Float = Float(position.x / self.bounds.width)
    self.setProgress(proportion, animated: false)
  }
}
