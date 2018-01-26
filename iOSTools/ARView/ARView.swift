//
//  ARView.swift
//  RealIT
//
//  Created by Antoine Clop on 1/8/18.
//  Copyright © 2018 3ie. All rights reserved.
//

import UIKit
import ARKit

open class ARView: ARSCNView {
    
    // MARK: - Properties
    public weak var ARdelegate: ARViewDelegate?
    private(set) public var objectManager: ARObjectManager = ARObjectManager()
    private var gestureManager: ARGestureManager?
    
    override open var bounds: CGRect {
        didSet {
            if let gestureManager = self.gestureManager {
                gestureManager.resetScreenTracking()
            }
        }
    }
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initARView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initARView()
    }
    
    private func initARView() {
        self.gestureManager = ARGestureManager(self)
        if let gestureManager = self.gestureManager {
            gestureManager.addGestures()
        }
    }
    
    // MARK: - Methods
    
    /**
     Create an object in ARView
     
     - parameter url: the path to the object
     - parameter named: the name of the object
     - parameter position: the initial position of the object
     - parameter angle: the initial angle of the object
     */
    public func createObject(url: URL, named: String? = nil, at position: Position, angle: Angle = Angle(0, 0, 0), gesturesAllowed: Set<Gesture> = []) {
        if let object = ARObject(url: url, named: named, gesturesAllowed: gesturesAllowed) {
            object.instantiate() { () in
                self.addToScene(object: object, at: position, angle: angle)
            }
        }
        else {
            debugPrint("[ERROR]: Cannot create object named: \(named ?? "(None)")")
        }
    }
    
    /**
     Create an object in ARView
     
     - parameter shape: the shape of the object
     - parameter named: the name of the object
     - parameter position: the initial position of the object
     - parameter angle: the initial angle of the object
     */
    public func createObject(shape: Shape, named: String? = nil, at position: Position, angle: Angle = Angle(0, 0, 0), gesturesAllowed: Set<Gesture> = []) {
        if let object = ARObject(shape: shape, named: named, gesturesAllowed: gesturesAllowed) {
            addToScene(object: object, at: position, angle: angle)
        }
        else {
            debugPrint("[ERROR]: Cannot create object named: \(named ?? "(None)")")
        }
    }
    
    /**
     Add an ARObject to the scene
     
     - parameter object: the object to be added
     - parameter position: the initial position of the object
     - parameter angle: the initial angle of the object
     */
    public func addObject(_ object: ARObject, at position: Position, angle: Angle = Angle(0, 0, 0)) {
        var safeObject: ARObject = object
        if object.isReference {
            if let copyObject = object.referenceCopy() {
                safeObject = copyObject
            }
        }
        safeObject.instantiate { () in
            self.addToScene(object: safeObject, at: position, angle: angle)
        }
    }
    
    /**
     Set object's position in ARView
     
     - parameter object: an existing object
     - parameter position: the new object's position
     */
    public func moveObject(_ object: ARObject, at position: Position) {
        if objectManager.objects.contains(object) {
            if let cameraTransform = session.currentFrame?.camera.transform {
                object.setPosition(position, relativeTo: cameraTransform)
                didMove(object: object, newPosition: position)
            }
            else {
                debugPrint("[ERROR]: Cannot move object: no point of view")
            }
        }
        else {
            debugPrint("[ERROR]: Object not found, cannot move in scene")
        }
    }
    
    /**
     Remove an object from ARView
     
     - parameter object: the object to remove
     */
    public func destroyObject(_ object: ARObject) {
        objectManager.removeObject(object)
        didRemove(object: object)
    }
    
    /**
     Remove all objects from ARView
     */
    public func reset() {
        objectManager.removeAllObjects()
    }
    
    /**
     Find object at a specific point on ARView
     
     - parameter point: the coordinates in ARView
     
     - returns: the object found or nil if nothing was at the position
     */
    public func object(at point: CGPoint) -> ARObject? {
        let hitTestOptions: [SCNHitTestOption: Any] = [.boundingBoxOnly: true]
        let hitTestResults: [SCNHitTestResult] = hitTest(point, options: hitTestOptions)
        return hitTestResults.lazy.flatMap { result in
            return ARObject.object(in: result.node)
            }.first
    }
    
    /**
     Calculate the distance of a object from user's point of view
     
     - parameter object: an object in the scene
     
     - returns: a Distance from user's point of view to object
     */
    public func distanceFromCamera(object: ARObject) -> Distance {
        if let pointOfView = self.pointOfView {
            let distanceVector: SCNVector3 = pointOfView.position - object.position
            return Distance(distanceVector)
        }
        else {
            debugPrint("[ERROR]: Cannot calculate distance from camera: no point of view")
            return Distance(0, 0, 0)
        }
    }
    
    /**
     Calculate the distance from an object to another
     
     - parameter object1: an object in the scene
     - parameter object2: an object in the scene
     
     - returns: a Distance from object1 to object2
     */
    public func distance(from object1: ARObject, to object2: ARObject) -> Distance {
        let distanceVector: SCNVector3 = object2.position - object1.position
        return Distance(distanceVector)
    }
    
    /**
     Provide virtual position from screen position
     
     - parameter position: a screen point to hit test
     - parameter objectPosition: an object from the scene. If ARView lacks of feature point, it will try to catch object's plane position
     
     - returns: a corresponding virtual position, the eventual object it touched and a boolean indicating if object touched was a plane. nil can be return if ARView has no information about camera's view
     */
    public func worldPosition(fromScreenPosition position: CGPoint, objectPosition: Position? = nil) -> (position: Position, planeAnchor: ARPlaneAnchor?, isOnPlane: Bool)? {
        let planeHitTestResults: [ARHitTestResult] = hitTest(position, types: .existingPlaneUsingExtent)
        if let result = planeHitTestResults.first {
            let planeHitTestPosition: Position = result.worldTransform.translation
            let planeAnchor: ARAnchor? = result.anchor
            return (planeHitTestPosition, planeAnchor as? ARPlaneAnchor, true)
        }
        
        let featureHitTestResult: FeatureHitTestResult? = hitTestWithFeatures(position, coneOpeningAngleInDegrees: 18, minDistance: 0.2, maxDistance: 2.0).first
        let featurePosition: Position? = featureHitTestResult?.position
        if featurePosition == nil {
            if let objectPosition = objectPosition,
                let pointOnInfinitePlane: Position = hitTestWithInfiniteHorizontalPlane(position, objectPosition) {
                return (pointOnInfinitePlane, nil, true)
            }
        }
        if let featurePosition = featurePosition {
            return (featurePosition, nil, false)
        }
        
        let unfilteredFeatureHitTestResults: [FeatureHitTestResult] = hitTestWithFeatures(position)
        if let result = unfilteredFeatureHitTestResults.first {
            return (result.position, nil, false)
        }
        return nil
    }
    
    // MARK: - Touches
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location: CGPoint = touch.location(in: self)
            if let object = object(at: location) {
                objectManager.setSelected(object)
                didSelect(object: object)
            }
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let object = objectManager.selectedObject {
            objectManager.setSelected(nil)
            didRelease(object: object)
        }
    }
    
    // MARK: - Private Methods
    
    /**
     Add an ARObject to the scene
     
     - parameter object: the object to be added
     - parameter position: the initial position of the object
     - parameter angle: the initial angle of the object
     */
    private func addToScene(object: ARObject, at position: Position, angle: Angle) {
        if let cameraTransform = session.currentFrame?.camera.transform {
            self.objectManager.addObject(object)
            object.setPosition(position, relativeTo: cameraTransform)
            object.setAngle(angle)
            DispatchQueue.main.async {
                self.scene.rootNode.addChildNode(object)
                self.didCreate(object: object)
            }
        }
        else {
            debugPrint("[ERROR]: Cannot add object to scene: unknown camera position")
        }
    }
}
