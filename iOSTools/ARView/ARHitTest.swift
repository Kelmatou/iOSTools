//
//  ARHitTest.swift
//  RealIT
//
//  Created by Antoine Clop on 1/9/18.
//  Copyright © 2018 3ie. All rights reserved.
//

import ARKit

struct HitTestRay {
    var origin: Position
    var direction: Position
    
    /**
     Provide the position of intersection between HitTestRay and a plane height
     
     - parameter planeY: the y coordinate of a plane
     
     - returns: the position of intersection. nil if they don't collide
     */
    func intersectionWithHorizontalPlane(atY planeY: Float) -> Position? {
        let normalizedDirection: simd_float3 = simd_normalize(direction)
        if normalizedDirection.y == 0 {
            if origin.y == planeY {
                return origin
            } else {
                return nil
            }
        }
        let distance: Float = (planeY - origin.y) / normalizedDirection.y
        if distance < 0 {
            return nil
        }
        return origin + (normalizedDirection * distance)
    }
}

struct FeatureHitTestResult {
    var position: Position
    var distanceToRayOrigin: Float
    var featureHit: Position
    var featureDistanceToHitResult: Float
    
    init(position: Position, distanceToRayOrigin: Float, featureHit: Position, featureDistanceToHitResult: Float) {
        self.position = position
        self.distanceToRayOrigin = distanceToRayOrigin
        self.featureHit = featureHit
        self.featureDistanceToHitResult = featureDistanceToHitResult
    }
    
    init(featurePoint: Position, ray: HitTestRay) {
        self.featureHit = featurePoint
        let originToFeature: Position = featurePoint - ray.origin
        self.position = ray.origin + (ray.direction * simd_dot(ray.direction, originToFeature))
        self.distanceToRayOrigin = simd_length(self.position - ray.origin)
        self.featureDistanceToHitResult = simd_length(simd_cross(originToFeature, ray.direction))
    }
}
