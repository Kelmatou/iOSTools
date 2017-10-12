//
//  MemoryAddress.swift
//  iOSToolsTests
//
//  Created by Antoine Clop on 10/12/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import XCTest
@testable import iOSTools

class MemoryAddressTest: XCTestCase {
  
  // MARK: - Test setup
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testBasicType() {
    let int: Int = 42
    let str: String = "42"
    let cart: (Int, String) = (int, str)
    let address1: String = address(of: int)
    let address2: String = address(of: str)
    let address3: String = address(of: cart)
    XCTAssert(address1.length() > 0)
    XCTAssert(address2.length() > 0)
    XCTAssert(address3.length() > 0)
  }
  
  func testArray() {
    let array: [Int] = [42, 26, 3, 12, 103, 2]
    let address1: String = address(of: array)
    let address2: String = address(of: array[0])
    XCTAssert(address1.length() > 0)
    XCTAssert(address2.length() > 0)
  }
  
  class A {}
  func testClassObject() {
    let instance: A = A()
    let address1: String = address(of: instance)
    XCTAssert(address1.length() > 0)
  }
  
  struct B {}
  func testStructInstance() {
    let instance: B = B()
    let address1: String = address(of: instance)
    XCTAssert(address1.length() > 0)
  }
  
  func testSelf() {
    let address1: String = address(of: self)
    XCTAssert(address1.length() > 0)
  }
  
  func testRawValue() {
    let address1: String = address(of: 42)
    let address2: String = address(of: "42")
    XCTAssert(address1.length() > 0)
    XCTAssert(address2.length() > 0)
  }
  
  func testNilObject() {
    let instance: A? = nil
    let address1: String = address(of: instance)
    XCTAssert(address1.length() > 0)
  }
}
