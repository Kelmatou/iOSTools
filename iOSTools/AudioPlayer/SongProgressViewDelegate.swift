//
//  SongProgressViewDelegate.swift
//  iOSTools
//
//  Created by Antoine Clop on 12/7/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import Foundation

extension SongProgressView: SongProgressViewDelegate {
  
  public func touchBegan(_ view: SongProgressView, touch: UITouch) {
    if let delegate = delegate, let touchBegan = delegate.touchBegan {
      touchBegan(view, touch)
    }
  }
  
  public func touchMoved(_ view: SongProgressView, touch: UITouch) {
    if let delegate = delegate, let touchMoved = delegate.touchMoved {
      touchMoved(view, touch)
    }
  }
  
  public func touchEnded(_ view: SongProgressView, touch: UITouch) {
    if let delegate = delegate, let touchEnded = delegate.touchEnded {
      touchEnded(view, touch)
    }
  }
}
