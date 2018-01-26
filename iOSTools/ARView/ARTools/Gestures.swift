//
//  Gestures.swift
//  RealIT
//
//  Created by Antoine Clop on 1/10/18.
//  Copyright © 2018 3ie. All rights reserved.
//

import UIKit

public enum Gesture {
    case Pan
    case Rotation
}

extension UIGestureRecognizer {
    
    func center(in view: UIView) -> CGPoint {
        let first = CGRect(origin: location(ofTouch: 0, in: view), size: .zero)
        let touchBounds = (1 ..< numberOfTouches).reduce(first) { touchBounds, index in
            return touchBounds.union(CGRect(origin: location(ofTouch: index, in: view), size: .zero))
        }
        return CGPoint(x: touchBounds.midX, y: touchBounds.midY)
    }
}
