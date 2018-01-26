//
//  ARObjectManager.swift
//  RealIT
//
//  Created by Antoine Clop on 1/8/18.
//  Copyright © 2018 3ie. All rights reserved.
//

import ARKit

public class ARObjectManager {
    
    // MARK: - Properties
    
    private(set) public var objects: [ARObject] = []
    private(set) public var selectedObject: ARObject?
    
    // MARK: - Methods
    
    /**
     Find a object by name
     
     - parameter named: String
     
     - returns: the first object matching parameter. nil if not found
     */
    public func object(named: String) -> ARObject? {
        return objects.filter { $0.name == named }.first
    }
    
    // MARK: - Internal Methods
    
    /**
     Add an object to instances list
     
     - parameter object: the object instanciated
     */
    internal func addObject(_ object: ARObject) {
        objects.append(object)
    }
    
    /**
     Remove an object from instance list
     
     - parameter object: the object to remove from the list
     */
    internal func removeObject(_ object: ARObject) {
        guard let index = objects.index(of: object) else { return }
        removeObject(at: index)
    }
    
    /**
     Remove object at a specified index
     
     - parameter index: the position of the object in list
     */
    internal func removeObject(at index: Int) {
        guard index >= 0 && index < objects.count else { return }
        if let selectedObject = self.selectedObject, selectedObject == objects[index] {
            self.selectedObject = nil
        }
        objects[index].removeFromParentNode()
        objects.remove(at: index)
    }
    
    /**
     Remove all object from instance list
     */
    internal func removeAllObjects() {
        for object in objects {
            object.removeFromParentNode()
        }
        objects.removeAll()
        selectedObject = nil
    }
    
    /**
     Update selected object
     
     - parameter object: the new selected object or nil to unselect object. object must be present in objects list or nothing will be updated
     */
    internal func setSelected(_ object: ARObject?) {
        if object == nil || objects.contains(object!) {
            selectedObject = object
        }
    }
}
