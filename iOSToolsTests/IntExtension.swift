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
  
  func testIntToHex() {
    let value: Int = 61
    XCTAssert(value.toHexadecimal() == "3d")
    XCTAssert(60.toHexadecimal() == "3c")
    XCTAssert(Int.toHexadecimal(59) == "3b")
    XCTAssert(Int.toHexadecimal(value) == "3d")
    XCTAssert(0.toHexadecimal() == "0")
    XCTAssert(10.toHexadecimal() == "a")
  }
  
  func testHexToInt() {
    let value: String = "3d"
    let valueMaj: String = "3D"
    XCTAssert(Int.fromHexadecimal(value) == 61)
    XCTAssert(Int.fromHexadecimal(valueMaj) == 61)
    XCTAssert(Int.fromHexadecimal("3c") == 60)
    XCTAssert(Int.fromHexadecimal("0") == 0)
    XCTAssert(Int.fromHexadecimal("") == nil)
    XCTAssert(Int.fromHexadecimal("Hello World!") == nil)
  }
  
  func testIntToBinary() {
    let value: Int = 61
    XCTAssert(value.toBinary() == "111101")
    XCTAssert(60.toBinary() == "111100")
    XCTAssert(Int.toBinary(59) == "111011")
    XCTAssert(Int.toBinary(value) == "111101")
    XCTAssert(0.toBinary() == "0")
    XCTAssert(10.toBinary() == "1010")
  }
  
  func testBinaryToInt() {
    let value: String = "111101"
    XCTAssert(Int.fromBinary(value) == 61)
    XCTAssert(Int.fromBinary("111100") == 60)
    XCTAssert(Int.fromBinary("0") == 0)
    XCTAssert(Int.fromBinary("") == nil)
    XCTAssert(Int.fromBinary("Hello World!") == nil)
  }
  
  func testIntToBase() {
    let value: Int = 61
    XCTAssert(value.toBase(8) == "75")
    XCTAssert(value.toBase(9) == "67")
    XCTAssert(60.toBase(8) == "74")
    XCTAssert(Int.toBase(59, base: 8) == "73")
    XCTAssert(Int.toBase(value, base: 10) == "61")
    XCTAssert(0.toBase(20) == "0")
    XCTAssert(10.toBase(2) == "1010")
  }
  
  func testBaseToInt() {
    let value: String = "75"
    XCTAssert(Int.fromBase(value, base: 8) == 61)
    XCTAssert(Int.fromBase(value, base: 9) == 68)
    XCTAssert(Int.fromBase("0", base: 8) == 0)
    XCTAssert(Int.fromBase("", base: 8) == nil)
    XCTAssert(Int.fromBase("Hello World!", base: 8) == nil)
  }
}
