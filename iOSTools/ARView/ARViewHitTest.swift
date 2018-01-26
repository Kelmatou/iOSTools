//
//  ARViewHitTest.swift
//  RealIT
//
//  Created by Antoine Clop on 1/9/18.
//  Copyright © 2018 3ie. All rights reserved.
//

import ARKit

extension ARView {
    
    /**
     Create a hit test ray from screen to a specified point
     
     - parameter point: a screen point to hit test
     
     - returns: a hit test ray
     */
    private func hitTestRayFromScreenPosition(_ point: CGPoint) -> HitTestRay? {
        guard let frame = session.currentFrame else { return nil }
        let cameraPos: Position = frame.camera.transform.translation
        let positionVec: Position = Position(x: Float(point.x), y: Float(point.y), z: 1.0)
        let screenPosOnFarClippingPlane: Position = unprojectPoint(positionVec)
        let rayDirection: Position = simd_normalize(screenPosOnFarClippingPlane - cameraPos)
        return HitTestRay(origin: cameraPos, direction: rayDirection)
    }
    
    /**
     Hit test from a screen point to a virtual plane
     
     - parameter point: a screen point to hit test
     - parameter pointOnPlane: a point from the virtual plane
     
     - returns: the eventual intersection between hit test ray and the virtual plane
     */
    internal func hitTestWithInfiniteHorizontalPlane(_ point: CGPoint, _ pointOnPlane: Position) -> Position? {
        guard let ray = hitTestRayFromScreenPosition(point) else { return nil }
        if ray.direction.y > -0.03 {
            return nil
        }
        return ray.intersectionWithHorizontalPlane(atY: pointOnPlane.y)
    }
    
    /**
     Hit test on feature points from a point on screen. Can specify many search options
     
     - parameter point: a screen point to hit test
     - parameter coneOpeningAngleInDegrees: define the angle to search feature point
     - parameter minDistance: define the minimum distance to search feature point
     - parameter maxDistance: define the maximum distance to search feature point
     - parameter maxResults: define the maximum number of result to return
     
     - returns: the closest feature point(s) from hit test ray
     */
    internal func hitTestWithFeatures(_ point: CGPoint, coneOpeningAngleInDegrees: Float, minDistance: Float = 0, maxDistance: Float = Float.greatestFiniteMagnitude, maxResults: Int = 1) -> [FeatureHitTestResult] {
        guard let features = session.currentFrame?.rawFeaturePoints, let ray = hitTestRayFromScreenPosition(point) else {
            return []
        }
        let maxAngleInDegrees: Float = min(coneOpeningAngleInDegrees, 360) / 2
        let maxAngle: Float = (maxAngleInDegrees / 180) * .pi
        let results: [FeatureHitTestResult] = features.points.flatMap { featurePosition -> FeatureHitTestResult? in
            let originToFeature: Position = featurePosition - ray.origin
            let crossPosition: Position = simd_cross(originToFeature, ray.direction)
            let featureDistanceFromResult: Float = simd_length(crossPosition)
            let hitTestResult: Position = ray.origin + (ray.direction * simd_dot(ray.direction, originToFeature))
            let hitTestResultDistance: Float = simd_length(hitTestResult - ray.origin)
            if hitTestResultDistance < minDistance || hitTestResultDistance > maxDistance {
                return nil
            }
            let originToFeatureNormalized: Position = simd_normalize(originToFeature)
            let angleBetweenRayAndFeature: Float = acos(simd_dot(ray.direction, originToFeatureNormalized))
            if angleBetweenRayAndFeature > maxAngle {
                return nil
            }
            return FeatureHitTestResult(position: hitTestResult, distanceToRayOrigin: hitTestResultDistance, featureHit: featurePosition, featureDistanceToHitResult: featureDistanceFromResult)
        }
        let sortedResults: [FeatureHitTestResult] = results.sorted { $0.distanceToRayOrigin < $1.distanceToRayOrigin }
        let remainingResults: [FeatureHitTestResult] = Array(sortedResults.dropFirst(maxResults))
        return remainingResults
    }
    
    /**
     Hit test on feature points from a point on screen
     
     - parameter point: a screen point to hit test
     
     - returns: the closest feature point from hit test ray
     */
    internal func hitTestWithFeatures(_ point: CGPoint) -> [FeatureHitTestResult] {
        guard let features = session.currentFrame?.rawFeaturePoints, let ray = hitTestRayFromScreenPosition(point) else {
            return []
        }
        let possibleResults: [FeatureHitTestResult] = features.points.map { featurePosition in
            return FeatureHitTestResult(featurePoint: featurePosition, ray: ray)
        }
        let closestResult: FeatureHitTestResult? = possibleResults.min(by: { $0.featureDistanceToHitResult < $1.featureDistanceToHitResult })
        if let result = closestResult {
            return [result]
        }
        return []
    }
}
