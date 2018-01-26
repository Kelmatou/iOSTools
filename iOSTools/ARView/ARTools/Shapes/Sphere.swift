//
//  Sphere.swift
//  RealIT
//
//  Created by Antoine Clop on 1/9/18.
//  Copyright © 2018 3ie. All rights reserved.
//

import SceneKit

class Sphere: Shape {
    
    // MARK: - Init
    
    init(radius: Float = 0, material: Any? = nil, physicType: SCNPhysicsBodyType = .dynamic, bounce: CGFloat = 1) {
        super.init(width: radius, height: radius, length: radius, round: radius / 2, material: material, physicType: physicType, bounce: bounce)
        self.geometry = SCNSphere(radius: self.properties.dimensions.width)
    }
}
