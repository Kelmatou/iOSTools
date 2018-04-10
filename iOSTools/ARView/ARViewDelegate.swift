//
//  ARViewDelegate.swift
//  RealIT
//
//  Created by Antoine Clop on 1/8/18.
//  Copyright © 2018 3ie. All rights reserved.
//

import Foundation

@available(iOS 11.0, *)
@objc public protocol ARViewDelegate: class {
    
    @objc optional func didCreate(object: ARObject)
    @objc optional func didRemove(object: ARObject)
    @objc optional func didReset(arView: ARView)
    @objc optional func didSelect(object: ARObject)
    @objc optional func didMove(object: ARObject, newPosition: Position)
    @objc optional func didRotate(object: ARObject, newAngle: Angle)
    @objc optional func didRelease(object: ARObject)
}

@available(iOS 11.0, *)
extension ARView: ARViewDelegate {
    
    public func didCreate(object: ARObject) {
        if let delegate = self.ARdelegate, let didCreate = delegate.didCreate {
            didCreate(object)
        }
    }
    
    public func didRemove(object: ARObject) {
        if let delegate = self.ARdelegate, let didRemove = delegate.didRemove {
            didRemove(object)
        }
    }
    
    public func didReset(arView: ARView) {
        if let delegate = self.ARdelegate, let didReset = delegate.didReset {
            didReset(arView)
        }
    }
    
    public func didSelect(object: ARObject) {
        if let delegate = self.ARdelegate, let didSelect = delegate.didSelect {
            didSelect(object)
        }
    }
    
    public func didMove(object: ARObject, newPosition: Position) {
        if let delegate = self.ARdelegate, let didMove = delegate.didMove {
            didMove(object, newPosition)
        }
    }
    
    public func didRotate(object: ARObject, newAngle: Angle) {
        if let delegate = self.ARdelegate, let didRotate = delegate.didRotate {
            didRotate(object, newAngle)
        }
    }
    
    public func didRelease(object: ARObject) {
        if let delegate = self.ARdelegate, let didRelease = delegate.didRelease {
            didRelease(object)
        }
    }
}
