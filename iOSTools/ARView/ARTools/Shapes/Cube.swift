//
//  Cube.swift
//  RealIT
//
//  Created by Antoine Clop on 1/9/18.
//  Copyright © 2018 3ie. All rights reserved.
//

import SceneKit

class Cube: Shape {
    
    // MARK: - Init
    
    init(size: Float = 0, round: Float = 0, material: Any? = nil, physicType: SCNPhysicsBodyType = .dynamic, bounce: CGFloat = 1) {
        super.init(width: size, height: size, length: size, round: round, material: material, physicType: physicType, bounce: bounce)
    }
}
