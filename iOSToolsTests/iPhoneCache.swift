//
//  iPhoneCache.swift
//  iOSTools
//
//  Created by Antoine Clop on 7/27/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import XCTest
@testable import iOSTools

class iPhoneCacheTest: XCTestCase {
  
  // MARK: - Test setup
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  class A: SavableObject {
    
    var a: Int?
    var b: String?
    static let aKey: String = "intKey"
    static let bKey: String = "stringKey"
    public static let filename: String = "AObject"
    
    init(a: Int) {
      super.init(filename: A.filename)
      self.a = a
      self.b = "\(a)"
    }
    init(a: Int?, b: String?) {
      super.init(filename: A.filename)
      self.a = a
      self.b = b
    }
    
    override func encode(with aCoder: NSCoder) {
      aCoder.encode(a, forKey: A.aKey)
      aCoder.encode(b, forKey: A.bKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
      let a = aDecoder.decodeObject(forKey: A.aKey) as? Int
      let b = aDecoder.decodeObject(forKey: A.bKey) as? String
      guard let aUnwrapped = a, let bUnwrapped = b else {
        return nil
      }
      self.init(a: aUnwrapped, b: bUnwrapped)
    }
  }
  
  // MARK: - Test case
  
  func testSaveInt() {
    SavableObject.saveBasicObject(42, withKey: "numberSaved")
    let int: Int? = SavableObject.loadBasicObject(withKey: "numberSaved") as? Int
    XCTAssert(int != nil)
    XCTAssert(int == 42)
  }

  func testSaveString() {
    SavableObject.saveBasicObject("42", withKey: "stringSaved")
    let str: String? = SavableObject.loadBasicObject(withKey: "stringSaved") as? String
    XCTAssert(str != nil)
    XCTAssert(str == "42")
  }
  
  func testSaveCustomObject() {
    let object: A = A(a: 42)
    XCTAssert(object.saveObject())
    let object2: A? = A.loadObject(from: A.filename)
    XCTAssert(object2 != nil)
    XCTAssert(object2?.a == 42)
    XCTAssert(object2?.b == "42")
  }
  
  func testSave2Items() {
    let object: A = A(a: 23, b: "Hello")
    XCTAssert(object.saveObject())
    let object2: A? = A.loadObject(from: A.filename)
    XCTAssert(object2 != nil)
    XCTAssert(object2?.a == 23)
    XCTAssert(object2?.b == "Hello")
  }
  
  func testSaveNil() {
    let nilObject: A = A(a: 23, b: nil)
    XCTAssert(nilObject.saveObject())
    let nilObject2: A? = A.loadObject(from: A.filename)
    XCTAssert(nilObject2 == nil)
  }
}
