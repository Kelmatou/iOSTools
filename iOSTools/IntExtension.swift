//
//  IntExtension.swift
//  iOSTools
//
//  Created by Antoine Clop on 7/21/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import Foundation

public extension Int {
  
  /**
   Indicates if an Int is in range [min, max]
   
   - parameter min: lowest Int value in valid range. If nil -> -infinite
   - parameter max: greatest Int value in valid range. If nil -> +infinite
   
   - returns: true if value is in range [min, max]
   */
  public func isBetween(min: Int?, max: Int?) -> Bool {
    if let min = min {
      if let max = max  {
        return self >= min && self <= max
      }
      else {
        return self >= min
      }
    }
    else if let max = max {
      return self <= max
    }
    return true
  }

  /**
   Generates a random number in range [min, max]
   
   - parameter min: lowest Int value in valid range. If nil -> Int32.min
   - parameter max: greatest Int value in valid range. If nil -> UInt32.max
   
   - returns: a random number in range [min, max]. 0 is returned if an error occured or min > max
   */
  public static func random(min: Int?, max: Int?) -> Int {
    if let min = min {
      if let max = max {
        guard min <= max else {
          return 0
        }
        return Int(arc4random_uniform(UInt32(max - min + Int(1)))) + min
      }
      else {
        return Int(arc4random_uniform(UInt32(Int.max - min + Int(1)))) + min
      }
    }
    else if let max = max {
      return Int(arc4random_uniform(UInt32(max - Int.min + Int(1)))) + Int.min
    }
    return Int(arc4random_uniform(UInt32.max) - arc4random_uniform(UInt32.max) - arc4random_uniform(UInt32.min))
  }
}
