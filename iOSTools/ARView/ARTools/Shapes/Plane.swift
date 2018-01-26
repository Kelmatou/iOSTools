//
//  Plane.swift
//  RealIT
//
//  Created by Antoine Clop on 1/9/18.
//  Copyright © 2018 3ie. All rights reserved.
//

import SceneKit

class Plane: Shape {
    
    // MARK: - Init
    
    init(width: Float = 0, length: Float = 0, round: Float = 0, material: Any? = nil, physicType: SCNPhysicsBodyType = .dynamic, bounce: CGFloat = 1) {
        super.init(width: width, height: 0.1, length: length, round: round, material: material, physicType: physicType, bounce: bounce)
    }
}
