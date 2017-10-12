//
//  Network.swift
//  iOSTools
//
//  Created by Antoine Clop on 7/25/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import XCTest
@testable import iOSTools

class NetworkTest: XCTestCase {
  
  // MARK: - Test setup
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  // MARK: - Get Test case
  
  func testValidGetRequestText() {
    let asyncRequest = expectation(description: "Request Succeeded")
    Requester.requestText(.GET, url: "http://yugiohprices.com/api/card_data/Dark%20Magician%20(Arkana)") {
      (data, error) in
      XCTAssert(error == nil)
      XCTAssert(data == "{\"status\":\"success\",\"data\":{\"name\":\"Dark Magician (Arkana)\",\"text\":\"The ultimate wizard in terms of attack and defense.\",\"card_type\":\"monster\",\"type\":\"Spellcaster\",\"family\":\"dark\",\"atk\":2500,\"def\":2100,\"level\":7,\"property\":null}}")
      asyncRequest.fulfill()
    }
    waitForExpectations(timeout: 10.0) { (_) -> Void in }
  }
  
  func testValidGetRequestImage() {
    let asyncRequest = expectation(description: "Request Succeeded")
    Requester.requestImage(.GET, url: "http://yugiohprices.com/api/card_image/Dark%20Magician%20(Arkana)") {
      (data, error) in
      XCTAssert(error == nil)
      XCTAssert(data != nil)
      asyncRequest.fulfill()
    }
    waitForExpectations(timeout: 10.0) { (_) -> Void in }
  }
  
  func testInvalidGetRequest() {
    let asyncRequest = expectation(description: "Request Succeeded")
    Requester.requestText(.GET, url: "http://yugiNOPEohprices.com/api/card_data/Dark%20Magician%20(Arkana)") {
      (data, error) in
      XCTAssert(error != nil)
      XCTAssert(data == nil)
      asyncRequest.fulfill()
    }
    waitForExpectations(timeout: 10.0) { (_) -> Void in }
  }
  
  func testEmptyGetRequest() {
    let asyncRequest = expectation(description: "Request Succeeded")
    Requester.requestText(.GET, url: "") {
      (data, error) in
      XCTAssert(error != nil)
      XCTAssert(data == nil)
      asyncRequest.fulfill()
    }
    waitForExpectations(timeout: 10.0) { (_) -> Void in }
  }
}
