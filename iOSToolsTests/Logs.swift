//
//  Logs.swift
//  iOSTools
//
//  Created by Antoine Clop on 9/21/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import XCTest
@testable import iOSTools

class LogsTest: XCTestCase {
  
  // MARK: - Test setup
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testVersion() {
    Logs.print(message: Logs.iOSToolsVersion)
    XCTAssert(Logs.iOSToolsVersion != "Version Unknown")
  }
  
  func testPrint() {
    let emptyMessage = Logs.outputMessage(message: nil)
    XCTAssert(emptyMessage == "")
    let emptyMessageWithTag = Logs.outputMessage(message: nil, tag: "MISC")
    XCTAssert(emptyMessageWithTag == "[MISC]: ")
    let emptyMessageNoTime = Logs.outputMessage(message: nil, time: false)
    XCTAssert(emptyMessageNoTime == "")
    let emptyMessageWithTime = Logs.outputMessage(message: nil, time: true)
    XCTAssert(emptyMessageWithTime == "[\(Datetime().toString())]: ")
    let messageNoTime = Logs.outputMessage(message: "This is a test", time: false)
    XCTAssert(messageNoTime == "This is a test")
    let messageTagNoTime = Logs.outputMessage(message: "This is a test", tag: "MISC", time: false)
    XCTAssert(messageTagNoTime == "[MISC]: This is a test")
    let messageTagWithTime = Logs.outputMessage(message: "This is a test", tag: "MISC", time: true)
    XCTAssert(messageTagWithTime == "[\(Datetime().toString())][MISC]: This is a test")
    Logs.alwaysPrintTime = true
    let alwaysTimeNoTime = Logs.outputMessage(message: "This is a test", tag: "MISC", time: false)
    XCTAssert(alwaysTimeNoTime == "[MISC]: This is a test")
    let alwaysTimeWithTime = Logs.outputMessage(message: "This is a test", tag: "MISC", time: true)
    XCTAssert(alwaysTimeWithTime == "[\(Datetime().toString())][MISC]: This is a test")
    Logs.alwaysPrintTime = false
  }
  
  func testInfo() {
    let info = Logs.info(message: "This is an INFO test")
    XCTAssert(info == "[INFO]: This is an INFO test")
    let infoWithTime = Logs.info(message: "This is an INFO test with time set", time: true)
    XCTAssert(infoWithTime == "[\(Datetime().toString())][INFO]: This is an INFO test with time set")
    Logs.alwaysPrintTime = true
    let alwaysTimeInfo = Logs.info(message: "This is an INFO test with alwaysPrintTime = true")
    XCTAssert(alwaysTimeInfo == "[\(Datetime().toString())][INFO]: This is an INFO test with alwaysPrintTime = true")
    let alwaysTimeWithTimeSetFalse = Logs.info(message: "This is an INFO test with alwaysPrintTime = true but set to false here", time: false)
    XCTAssert(alwaysTimeWithTimeSetFalse == "[INFO]: This is an INFO test with alwaysPrintTime = true but set to false here")
    Logs.alwaysPrintTime = false
  }
  
  func testDebug() {
    let debug = Logs.debug(message: "This is a DEBUG test")
    XCTAssert(debug == "[DEBUG]: This is a DEBUG test")
    let debugWithTime = Logs.debug(message: "This is a DEBUG test with time set", time: true)
    XCTAssert(debugWithTime == "[\(Datetime().toString())][DEBUG]: This is a DEBUG test with time set")
    Logs.alwaysPrintTime = true
    let alwaysTimeDebug = Logs.debug(message: "This is a DEBUG test with alwaysPrintTime = true")
    XCTAssert(alwaysTimeDebug == "[\(Datetime().toString())][DEBUG]: This is a DEBUG test with alwaysPrintTime = true")
    let alwaysTimeWithTimeSetFalse = Logs.debug(message: "This is a DEBUG test with alwaysPrintTime = true but set to false here", time: false)
    XCTAssert(alwaysTimeWithTimeSetFalse == "[DEBUG]: This is a DEBUG test with alwaysPrintTime = true but set to false here")
    
    Logs.alwaysPrintTime = false
  }
  
  func testWarning() {
    let warning = Logs.warning(message: "This is a WARNING test")
    XCTAssert(warning == "[WARNING]: This is a WARNING test")
    let warningWithTime = Logs.warning(message: "This is a WARNING test with time set", time: true)
    XCTAssert(warningWithTime == "[\(Datetime().toString())][WARNING]: This is a WARNING test with time set")
    Logs.alwaysPrintTime = true
    let alwaysTimeWarning = Logs.warning(message: "This is a WARNING test with alwaysPrintTime = true")
    XCTAssert(alwaysTimeWarning == "[\(Datetime().toString())][WARNING]: This is a WARNING test with alwaysPrintTime = true")
    let alwaysTimeWithTimeSetFalse = Logs.warning(message: "This is a WARNING test with alwaysPrintTime = true but set to false here", time: false)
    XCTAssert(alwaysTimeWithTimeSetFalse == "[WARNING]: This is a WARNING test with alwaysPrintTime = true but set to false here")

    Logs.alwaysPrintTime = false
  }
  
  func testError() {
    let error = Logs.error(message: "This is an ERROR test")
    XCTAssert(error == "[ERROR]: This is an ERROR test")
    let errorWithTime = Logs.error(message: "This is an ERROR test with time set", time: true)
    XCTAssert(errorWithTime == "[\(Datetime().toString())][ERROR]: This is an ERROR test with time set")
    Logs.alwaysPrintTime = true
    let alwaysTimeError = Logs.error(message: "This is an ERROR test with alwaysPrintTime = true")
    XCTAssert(alwaysTimeError == "[\(Datetime().toString())][ERROR]: This is an ERROR test with alwaysPrintTime = true")
    let alwaysTimeWithTimeSetFalse = Logs.error(message: "This is an ERROR test with alwaysPrintTime = true but set to false here", time: false)
    XCTAssert(alwaysTimeWithTimeSetFalse == "[ERROR]: This is an ERROR test with alwaysPrintTime = true but set to false here")
    Logs.alwaysPrintTime = false
  }
}
