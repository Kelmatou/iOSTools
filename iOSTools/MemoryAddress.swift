//
//  MemoryAddress.swift
//  iOSTools
//
//  Created by Antoine Clop on 10/12/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import Foundation

public func address<T>(of object: T) -> String {
  let objectAsObject = object as AnyObject
  let mutablePointer: UnsafeMutableRawPointer = Unmanaged.passUnretained(objectAsObject).toOpaque()
  return String(describing: mutablePointer)
}
