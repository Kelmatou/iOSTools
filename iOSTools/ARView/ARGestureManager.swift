//
//  ARViewGestureManager.swift
//  RealIT
//
//  Created by Antoine Clop on 1/10/18.
//  Copyright © 2018 3ie. All rights reserved.
//

import ARKit

open class ARGestureManager: NSObject, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    private var arView: ARView
    private var currentScreenPos: CGPoint?
    
    // MARK: - Init
    
    init(_ arView: ARView) {
        self.arView = arView
    }
    
    // MARK: - Internal Methods
    
    internal func addGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        panGesture.delegate = self
        arView.addGestureRecognizer(panGesture)
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_:)))
        rotationGesture.delegate = self
        arView.addGestureRecognizer(rotationGesture)
    }
    
    internal func resetScreenTracking() {
        currentScreenPos = nil
    }
    
    // MARK: - UIGestureRecognizerDelegate delegate
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - Gesture action
    
    @objc internal func didRotate(_ gesture: UIRotationGestureRecognizer) {
        guard gesture.state == .changed else { return }
        guard let objectSelected = arView.objectManager.selectedObject, objectSelected.gesturesAllowed.contains(.Rotation) else { return }
        let currentAngle: Angle = Angle(objectSelected.eulerAngles)
        let newAngle: Angle = Angle(currentAngle.x, currentAngle.y - Float(gesture.rotation), currentAngle.z)
        objectSelected.setAngle(newAngle)
        arView.didRotate(object: objectSelected, newAngle: newAngle)
        gesture.rotation = 0
    }
    
    @objc func didPan(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            guard let object = arView.objectManager.selectedObject, object.gesturesAllowed.contains(.Pan) else { return }
            guard let cameraTransform = arView.session.currentFrame?.camera.transform else { return }
            let translation: CGPoint = gesture.translation(in: arView)
            let previousPos: CGPoint = currentScreenPos ?? CGPoint(arView.projectPoint(object.position))
            currentScreenPos = CGPoint(x: previousPos.x + translation.x, y: previousPos.y + translation.y)
            if let screenPos = self.currentScreenPos, let worldInformation = arView.worldPosition(fromScreenPosition: screenPos, objectPosition: Position(object.position)) {
                object.setPosition(worldInformation.position, relativeTo: cameraTransform)
                arView.didMove(object: object, newPosition: worldInformation.position)
            }
            gesture.setTranslation(.zero, in: arView)
        }
        else if gesture.state != .began {
            arView.touchesEnded([], with: nil)
        }
    }
    
    // MARK: - Private Methods
    
    private func objectInteracting(with gesture: UIGestureRecognizer, in view: ARView) -> ARObject? {
        for index in 0 ..< gesture.numberOfTouches {
            let touchLocation = gesture.location(ofTouch: index, in: view)
            if let object = arView.object(at: touchLocation) {
                return object
            }
        }
        return arView.object(at: gesture.center(in: arView))
    }
}
