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
   Convert an Int value into hexadecimal format
   
   - returns: a String representing the hexadecimal value
   */
  public func toHexadecimal() -> String {
    return Int.toHexadecimal(self)
  }
  
  /**
   Convert an Int value into binary format
   
   - parameter value: the value to convert
   
   - returns: a String representing the binary value
   */
  public func toBinary() -> String {
    return Int.toBinary(self)
  }
  
  /**
   Convert an Int value into base format

   - parameter base: the base to use
   
   - returns: a String representing the value encoded in base
   */
  public func toBase(_ base: Int) -> String {
    return Int.toBase(self, base: base)
  }
  
  /**
   Convert an Int value into hexadecimal format
   
   - parameter value: the value to convert
   
   - returns: a String representing the hexadecimal value
   */
  public static func toHexadecimal(_ value: Int) -> String {
    return String(value, radix: 16)
  }
  
  /**
   Convert an Int value into binary format
   
   - parameter value: the value to convert
   
   - returns: a String representing the binary value
   */
  public static func toBinary(_ value: Int) -> String {
    return String(value, radix: 2)
  }
  
  /**
   Convert an Int value into base format
   
   - parameter value: the value to convert
   - parameter base: the base to use
   
   - returns: a String representing the value encoded in base
   */
  public static func toBase(_ value: Int, base: Int) -> String {
    return String(value, radix: base)
  }
  
  /**
   Convert a String representing the hexadecimal value into Int
   
   - parameter value: the value to convert
   
   - returns: an Int representing the hexadecimal value, nil if parameter was not a hexadecimal number
   */
  public static func fromHexadecimal(_ value: String) -> Int? {
    return Int(value, radix: 16)
  }
  
  /**
   Convert a String representing the binary value into Int
   
   - parameter value: the value to convert
   
   - returns: an Int representing the binary value, nil if parameter was not a binary number
   */
  public static func fromBinary(_ value: String) -> Int? {
    return Int(value, radix: 2)
  }
  
  /**
   Convert a String representing the value encoded in a base into Int
   
   - parameter value: the value to convert
   - parameter base: the base to use
   
   - returns: an Int representing the value encoded in a base, nil if parameter was not a valid number in specified base
   */
  public static func fromBase(_ value: String, base: Int) -> Int? {
    return Int(value, radix: base)
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
