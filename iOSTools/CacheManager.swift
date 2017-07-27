//
//  CacheManager.swift
//  iOSTools
//
//  Created by Antoine Clop on 7/26/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import Foundation

public class SavableObject: NSObject, NSCoding {
  
  //MARK: - Archiving Paths
  
  internal static let DocumentsDirectory: URL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
  public var ArchiveURL: URL?
  
  // MARK: - Init
  
  public init(filename: String) {
    self.ArchiveURL = SavableObject.DocumentsDirectory.appendingPathComponent(filename)
  }
  
  //MARK: - NSCoding
  
  //aCoder.encode(rawValue, forKey: keyName)  // Where rawValue can be an Int, String... and keyName is a string
  public func encode(with aCoder: NSCoder) {
  }
  
  /**
   Override this method to rebuild your object. Usually, you want to do something like:
   
   let field1: Int = aDecoder.decodeObject(forKey: PropertyKey.id) as? Int
   let field2: String = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
   self.init(field1, field2)
   */
  //
  required public init?(coder aDecoder: NSCoder) {
  }
  
  /**
   Save Object in files
   
   - returns: true if file has been saved, false in any other case
   */
  @discardableResult public func saveObject() -> Bool {
    guard let ArchiveURL = ArchiveURL else {
      return false
    }
    let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self, toFile: ArchiveURL.path)
    return isSuccessfulSave
  }
  
  /**
   Load Object array from files
   
   - returns: an Object array
   */
  public static func loadObject<T>(from file: String) -> T?  {
    return NSKeyedUnarchiver.unarchiveObject(withFile: SavableObject.DocumentsDirectory.appendingPathComponent(file).path) as? T
  }
  
  /**
   Save a 'basic' value (String, Int, Bool...)
   
   - parameter object: the object to save
   - parameter withKey: the key to use to save object
   */
  public static func saveBasicObject(_ object: Any?, withKey: String) {
    UserDefaults.standard.set(object, forKey: withKey)
  }
  
  /**
   Load Object saved with SavableObject.saveBasicObject method
   
   - parameter withKey: the key used to save object
   
   - returns: the object passed to saveBasicObject previously
   */
  public static func loadBasicObject(withKey: String) -> Any? {
    return UserDefaults.standard.object(forKey: withKey)
  }
}
