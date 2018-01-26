//
//  Matrix.swift
//  RealIT
//
//  Created by Antoine Clop on 1/9/18.
//  Copyright © 2018 3ie. All rights reserved.
//

import ARKit

public typealias Transform = matrix_float4x4

extension float4x4 {

    var translation: Position {
        let translation = columns.3
        return Position(translation.x, translation.y, translation.z)
    }
}
