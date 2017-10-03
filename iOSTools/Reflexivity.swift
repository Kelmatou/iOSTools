//
//  Reflexivity.swift
//  iOSTools
//
//  Created by Antoine Clop on 7/24/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import Foundation

public class Reflexivity {
  
  // MARK: - Private attributes
  
  private var mirror: Mirror?
  
  // MARK: - Public methods

  public init<T>(_ instance: T) {
    self.mirror = Mirror(reflecting: instance)
  }
  
  /**
   Get the name of an instance's type

   - returns: A string representing the type of the instance. Nil is returned if an error occured
   */
  public func typeName() -> String? {
    guard let mirror = self.mirror else {
      return nil
    }
    var type: String = "\(mirror.subjectType)"
    if type.length() > 10 && type.substring(startIndex: 0, length: 9) == "Optional<" {
      let typeLength: Int = type.length() - 10
      if let newType = type.substring(startIndex: 9, length: typeLength) {
        type = newType + "?"
      }
    }
    return type
  }
  
  /**
   Get the Reflexivity object of an instance's parent type.

   - returns: A string representing the type of instance's parent. Nil is return if a error occured or if 'instance' is an optional (due to limits for now)
   */
  public func parent() -> Reflexivity? {
    guard let mirror = self.mirror else {
      return nil
    }
    let parentMirror: Mirror? = mirror.superclassMirror
    if let parentMirror = parentMirror {
      let newReflexivity: Reflexivity = Reflexivity(())
      newReflexivity.mirror = parentMirror
      return newReflexivity
    }
    else {
      return nil
    }
  }
  
  // MARK: - Static Methods
  
  /**
   Get the name of instance's type
   
   - parameter instance: an object
   
   - returns: A string representing the type of the instance
  */
  public static func typeName<T>(_ instance: T) -> String {
    let mirror: Mirror = Mirror(reflecting: instance)
    var type: String = "\(mirror.subjectType)"
    if type.length() > 10 && type.substring(startIndex: 0, length: 9) == "Optional<" {
      let typeLength: Int = type.length() - 10
      if let newType = type.substring(startIndex: 9, length: typeLength) {
        type = newType + "?"
      }
    }
    return type
  }
  
  /**
   Get the name of instance's parent type.
   
   - parameter instance: an object
   
   - returns: A string representing the type of instance's parent. Nil is return if a error occured or if 'instance' is an optional (due to limits for now)
  */
  public static func parentType<T>(_ instance: T) -> String? {
    let mirror: Mirror = Mirror(reflecting: instance)
    let parentMirror: Mirror? = mirror.superclassMirror
    if let parentMirror = parentMirror {
      return "\(parentMirror.subjectType)"
    }
    else {
      return nil
    }
  }
}
