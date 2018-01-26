//
//  Shape.swift
//  RealIT
//
//  Created by Antoine Clop on 1/9/18.
//  Copyright © 2018 3ie. All rights reserved.
//

import SceneKit

open class Shape {
    
    // MARK: - Properties
    
    var properties: ShapeProperties
    var geometry: SCNGeometry
    
    // MARK: - Init
    
    init(width: Float = 0, height: Float = 0, length: Float = 0, round: Float = 0, material: Any? = nil, physicType: SCNPhysicsBodyType = .dynamic, bounce: CGFloat = 1) {
        self.properties = ShapeProperties(width: width, height: height, length: length, round: round, material: material, physicType: physicType, bounce: bounce)
        self.geometry = SCNBox(width: properties.dimensions.width, height: properties.dimensions.height, length: properties.dimensions.length, chamferRadius: properties.dimensions.round)
        let material: SCNMaterial = SCNMaterial()
        material.diffuse.contents = self.properties.material
        self.geometry.materials = [material]
    }
}
