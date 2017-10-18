//
//  MemoryAddress.swift
//  iOSTools
//
//  Created by Antoine Clop on 10/12/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import Foundation

extension Reflexivity {
  /**
   Get the address of any object
   
   - parameter object: the object to get address from
   
   - returns: a String containing the address (like: "0xb000000000000123")
   */
  public static func address<T>(of object: T) -> String {
    let objectAsObject = object as AnyObject
    let mutablePointer: UnsafeMutableRawPointer = Unmanaged.passUnretained(objectAsObject).toOpaque()
    return String(describing: mutablePointer)
  }
}
