//
//  StringExtension.swift
//  iOSTools
//
//  Created by Antoine Clop on 7/21/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import XCTest
@testable import iOSTools

class StringExtensionTest: XCTestCase {
  
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
  
  func testLength() {
    XCTAssert("".length == 0)
    XCTAssert(" ".length == 1)
    XCTAssert("\"".length == 1)
    XCTAssert("Hello World!".length == 12)
  }
  
  func testStringByInt() {
    XCTAssert("" * 5 == "")
    XCTAssert("Hello World!" * 0 == "")
    XCTAssert("Hello World!" * -5 == "")
    XCTAssert("Hello World!" * 5 == "Hello World!Hello World!Hello World!Hello World!Hello World!")
  }
  
  func testSubstringStartIndex() {
    XCTAssert("".substring(startIndex: 0) == "")
    XCTAssert("".substring(startIndex: 1) == nil)
    XCTAssert("".substring(startIndex: -1) == nil)
    XCTAssert(" ".substring(startIndex: 0) == " ")
    XCTAssert(" ".substring(startIndex: 1) == "")
    XCTAssert("Hello World!".substring(startIndex: 6) == "World!")
  }
  
  func testSubstringStartIndexLength() {
    XCTAssert("".substring(startIndex: 0, length: 0) == "")
    XCTAssert("".substring(startIndex: 1, length: 0) == nil)
    XCTAssert("".substring(startIndex: -1, length: 0) == nil)
    XCTAssert(" ".substring(startIndex: 0, length: 1) == " ")
    XCTAssert(" ".substring(startIndex: 0, length: 0) == "")
    XCTAssert(" ".substring(startIndex: 1, length: 0) == "")
    XCTAssert("Hello World!".substring(startIndex: 6, length: 6) == "World!")
    XCTAssert("Hello World!".substring(startIndex: 0, length: 5) == "Hello")
    XCTAssert("Hello World!".substring(startIndex: 0, length: -5) == nil)
    XCTAssert("Hello World!".substring(startIndex: 6, length: 50) == "World!")
  }
  
  func testNumberOccurence() {
    XCTAssert("".numberOccurence(of: "hello") == 0)
    XCTAssert("".numberOccurence(of: "") == 0)
    XCTAssert("hello".numberOccurence(of: "") == 0)
    XCTAssert("hello".numberOccurence(of: "hello") == 1)
    XCTAssert("hello".numberOccurence(of: "l") == 2)
    XCTAssert("bonbon".numberOccurence(of: "bon") == 2)
  }
  
  func testFirstOccurencePosition() {
    XCTAssert("".firstOccurencePosition(of: "hello") == nil)
    XCTAssert("".firstOccurencePosition(of: "") == nil)
    XCTAssert("hello".firstOccurencePosition(of: "") == nil)
    XCTAssert("hello".firstOccurencePosition(of: "hello") == 0)
    XCTAssert("hello".firstOccurencePosition(of: "l") == 2)
    XCTAssert("bonbon".firstOccurencePosition(of: "bon") == 0)
  }
  
  func testCapitalizeFirstLetter() {
    XCTAssert("".capitalizeFirstLetter() == "")
    XCTAssert("i".capitalizeFirstLetter() == "I")
    XCTAssert("I".capitalizeFirstLetter() == "I")
    XCTAssert("@".capitalizeFirstLetter() == "@")
    XCTAssert("1".capitalizeFirstLetter() == "1")
    XCTAssert("@hello world".capitalizeFirstLetter() == "@hello world")
    XCTAssert("hello world".capitalizeFirstLetter() == "Hello world")
    XCTAssert("Hello world".capitalizeFirstLetter() == "Hello world")
    XCTAssert("hELLO WORLD".capitalizeFirstLetter() == "HELLO WORLD")
  }
}
