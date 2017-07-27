//
//  IntExtensionTest.swift
//  iOSTools
//
//  Created by Antoine Clop on 7/21/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import XCTest
@testable import iOSTools

class IntExtensionTest: XCTestCase {

  // MARK: - Test setup
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  // MARK: - Test case
  
  func testInfiniteRange() {
    let pos: Int = 3
    let neg: Int = -3
    XCTAssert(pos.isBetween(min: nil, max: nil))
    XCTAssert(neg.isBetween(min: nil, max: nil))
  }
  
  func testPositiveRange() {
    let pos: Int = 3
    let neg: Int = -3
    let zero: Int = 0
    XCTAssert(pos.isBetween(min: 0, max: nil))
    XCTAssert(!neg.isBetween(min: 0, max: nil))
    XCTAssert(zero.isBetween(min: 0, max: nil))
  }
  
  func testNegativeRange() {
    let pos: Int = 3
    let neg: Int = -3
    let zero: Int = 0
    XCTAssert(!pos.isBetween(min: nil, max: 0))
    XCTAssert(neg.isBetween(min: nil, max: 0))
    XCTAssert(zero.isBetween(min: nil, max: 0))
  }
  
  func testSizedRange() {
    let pos: Int = 3
    let neg: Int = -3
    let zero: Int = 0
    XCTAssert(pos.isBetween(min: -3, max: 3))
    XCTAssert(neg.isBetween(min: -3, max: 3))
    XCTAssert(zero.isBetween(min: -3, max: 3))
  }
  
  func testNanoRange() {
    let pos: Int = 3
    let neg: Int = -3
    let zero: Int = 0
    XCTAssert(!pos.isBetween(min: 0, max: 0))
    XCTAssert(!neg.isBetween(min: 0, max: 0))
    XCTAssert(zero.isBetween(min: 0, max: 0))
  }
  
  func testWrongRange() {
    let pos: Int = 3
    let neg: Int = -3
    let zero: Int = 0
    XCTAssert(!pos.isBetween(min: 3, max: -3))
    XCTAssert(!neg.isBetween(min: 3, max: -3))
    XCTAssert(!zero.isBetween(min: 3, max: -3))
  }
  
  func testRandom() {
    for _ in 0...1000 {
      let rnd: Int = Int.random(min: 0, max: 10)
      XCTAssert(rnd.isBetween(min: 0, max: 10))
    }
    for _ in 0...1000 {
      let rnd: Int = Int.random(min: -10, max: 10)
      XCTAssert(rnd.isBetween(min: -10, max: 10))
    }
    for _ in 0...1000 {
      let rnd: Int = Int.random(min: -1, max: -1)
      XCTAssert(rnd == -1)
    }
    XCTAssert(Int.random(min: 3, max: -3) == 0)
  }
}
