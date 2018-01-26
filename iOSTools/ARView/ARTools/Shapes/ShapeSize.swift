//
//  ShapeSize.swift
//  RealIT
//
//  Created by Antoine Clop on 1/9/18.
//  Copyright © 2018 3ie. All rights reserved.
//

import UIKit

open class ShapeSize {
    
    // MARK: - Properties
    
    public var width: CGFloat
    public var height: CGFloat
    public var length: CGFloat
    public var round: CGFloat
    
    // MARK: - Init
    
    init(width: Float, height: Float, length: Float, round: Float) {
        self.width = CGFloat(width)
        self.height = CGFloat(height)
        self.length = CGFloat(length)
        self.round = CGFloat(round)
    }
}
