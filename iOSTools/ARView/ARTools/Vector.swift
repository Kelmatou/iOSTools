//
//  Vector.swift
//  RealIT
//
//  Created by Antoine Clop on 1/8/18.
//  Copyright © 2018 3ie. All rights reserved.
//

import SceneKit

public typealias Position = float3
public typealias Angle = float3
public typealias Distance = float3

extension SCNVector3 {
    
    static func -(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        let x: Float = left.x - right.x
        let y: Float = left.y - right.y
        let z: Float = left.z - right.z
        return SCNVector3(x: x, y: y, z: z)
    }
}

extension float3 {
    
    var value: Float {
        return sqrtf(powf(x, 2) + powf(y, 2) + powf(z, 2))
    }
}

extension SCNView {

    func unprojectPoint(_ point: Position) -> Position {
        return Position(unprojectPoint(SCNVector3(point)))
    }
}

extension CGPoint {
    
    init(_ vector: SCNVector3) {
        x = CGFloat(vector.x)
        y = CGFloat(vector.y)
    }
}
