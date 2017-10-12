//
//  Error.swift
//  iOSToolsTests
//
//  Created by Antoine Clop on 10/5/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import XCTest
@testable import iOSTools

class ErrorTest: XCTestCase {
  
  // MARK: - Test setup
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testEmptyError() {
    let nilError: GenericError = GenericError("")
    XCTAssert(nilError.internalError.errorDescription == "")
    XCTAssert(nilError.internalError.failureReason == "")
    XCTAssert(nilError.internalError.recoverySuggestion == "No recovery available")
    XCTAssert(nilError.internalError.helpAnchor == "No help available")
  }
  
  func testNilError2() {
    let nilError: GenericError = GenericError(description: nil, failure: nil, recovery: nil, help: nil)
    XCTAssert(nilError.internalError.errorDescription == "")
    XCTAssert(nilError.internalError.failureReason == "")
    XCTAssert(nilError.internalError.recoverySuggestion == "")
    XCTAssert(nilError.internalError.helpAnchor == "")
  }
  
  func testError() {
    let nilError: GenericError = GenericError(description: "Description", failure: "Failure", recovery: "Recovery", help: "Help")
    XCTAssert(nilError.internalError.errorDescription == "Description")
    XCTAssert(nilError.internalError.failureReason == "Failure")
    XCTAssert(nilError.internalError.recoverySuggestion == "Recovery")
    XCTAssert(nilError.internalError.helpAnchor == "Help")
  }
  
  func testEmptyErrorModification() {
    let nilError: GenericError = GenericError("")
    nilError.internalError.recovery = "Take a pill"
    nilError.internalError.help = "There is your pill"
    XCTAssert(nilError.internalError.errorDescription == "")
    XCTAssert(nilError.internalError.failureReason == "")
    XCTAssert(nilError.internalError.recoverySuggestion == "Take a pill")
    XCTAssert(nilError.internalError.helpAnchor == "There is your pill")
  }
}
