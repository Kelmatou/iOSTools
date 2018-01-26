//
//  ARObject.swift
//  RealIT
//
//  Created by Antoine Clop on 1/8/18.
//  Copyright © 2018 3ie. All rights reserved.
//

import ARKit

open class ARObject: SCNNode {
    
    // MARK: - Properties
    
    private(set) public var isLoading: Bool = false
    private var referenceNode: SCNReferenceNode?
    internal var isReference: Bool {
        return self.referenceNode != nil
    }
    public var gesturesAllowed: Set<Gesture> = []
    
    // MARK: - Init
    
    public init?(url: URL, named: String? = nil, gesturesAllowed: Set<Gesture> = []) {
        super.init()
        guard let referenceNode = SCNReferenceNode(url: url) else { return }
        self.referenceNode = referenceNode
        self.name = named
        self.gesturesAllowed = gesturesAllowed
    }
    
    public init?(shape: Shape, named: String? = nil, gesturesAllowed: Set<Gesture> = []) {
        super.init()
        self.geometry = shape.geometry
        self.name = named
        self.gesturesAllowed = gesturesAllowed
        self.physicsBody = SCNPhysicsBody(type: shape.properties.physicType, shape: nil)
        if let physicsBody = self.physicsBody {
            physicsBody.restitution = shape.properties.bounce
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    /**
     Loads object on a background queue
     */
    internal func instantiate(loadedHandler: @escaping () -> Void) {
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            if let referenceNode = self.referenceNode, !referenceNode.isLoaded {
                referenceNode.load()
                DispatchQueue.main.async {
                    if let child = self.referenceNode?.childNodes.first {
                        self.insertChildNode(child, at: 0)
                    }
                }
            }
            self.isLoading = false
            loadedHandler()
        }
    }
    
    /**
     Set position of the object instantly
     
     - parameter newPosition: the new position of the object
     - parameter cameraTransform: a matrix containing all camera position information
     */
    open func setPosition(_ newPosition: Position, relativeTo cameraTransform: Transform) {
        let cameraWorldPosition: Position = cameraTransform.translation
        let positionFromCamera: Position = newPosition - cameraWorldPosition
        position = SCNVector3(cameraWorldPosition + positionFromCamera)
    }
    
    /**
     Set angle of the object instantly
     
     - parameter newAngle: the new angle of the object
     */
    public func setAngle(_ newAngle: Angle) {
        eulerAngles.x = newAngle.x
        eulerAngles.y = newAngle.y
        eulerAngles.z = newAngle.z
    }
    
    /**
     Copy an ARObject created by reference url
     
     - returns: a copy of ARObject. nil if object was not created by reference url
     */
    internal func referenceCopy() -> ARObject? {
        guard let referenceURL = self.referenceNode?.referenceURL else { return nil }
        let newObject: ARObject? = ARObject(url: referenceURL, gesturesAllowed: self.gesturesAllowed)
        if let newObject = newObject {
            newObject.name = self.name
            for child in self.childNodes {
                newObject.addChildNode(child)
            }
        }
        return newObject
    }
    
    // MARK: - Static
    
    /**
     Find a ARObject in node
     
     - parameter node: the node to start search on
     
     - returns: the first ARObject found starting with node and exploring its parents. nil if nothing was found
     */
    public static func object(in node: SCNNode) -> ARObject? {
        if let object = node as? ARObject {
            return object
        }
        if let parent = node.parent {
            return object(in: parent)
        }
        return nil
    }
}
