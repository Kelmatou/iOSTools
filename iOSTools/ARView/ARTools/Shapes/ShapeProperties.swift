//
//  ShapeProperties.swift
//  RealIT
//
//  Created by Antoine Clop on 1/9/18.
//  Copyright © 2018 3ie. All rights reserved.
//

import SceneKit

open class ShapeProperties {
    
    // MARK: - Properties
    
    public var dimensions: ShapeSize
    public var material: Any?
    public var physicType: SCNPhysicsBodyType
    public var bounce: CGFloat
    
    // MARK: - Init
    
    init(width: Float = 0, height: Float = 0, length: Float = 0, round: Float = 0, material: Any? = nil, physicType: SCNPhysicsBodyType = .dynamic, bounce: CGFloat = 1) {
        self.dimensions = ShapeSize(width: width, height: height, length: length, round: round)
        self.material = material
        self.physicType = physicType
        self.bounce = bounce
    }
}
