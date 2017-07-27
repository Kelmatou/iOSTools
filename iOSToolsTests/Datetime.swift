//
//  Datetime.swift
//  iOSTools
//
//  Created by Antoine Clop on 7/21/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import XCTest
@testable import iOSTools

class DatetimeTest: XCTestCase {

  // MARK: - Test setup
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  // MARK: - Init Test case
  
  func testInitWithDate() {
    let dateComponents: DateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
    let newDatetime: Datetime = Datetime(date: Date())
    XCTAssert(newDatetime.year == dateComponents.year)
    XCTAssert(newDatetime.month == dateComponents.month)
    XCTAssert(newDatetime.day == dateComponents.day)
    XCTAssert(newDatetime.hour == dateComponents.hour)
    XCTAssert(newDatetime.minute == dateComponents.minute)
    XCTAssert(newDatetime.second == dateComponents.second)
  }
  
  func testInitWithComponents() {
    let newDatetime: Datetime? = Datetime(year: 2017, month: 1, day: 30, hour: 9, minute: 0, second: 0)
    XCTAssert(newDatetime != nil)
    XCTAssert(newDatetime?.year == 2017)
    XCTAssert(newDatetime?.month == 1)
    XCTAssert(newDatetime?.day == 30)
    XCTAssert(newDatetime?.hour == 9)
    XCTAssert(newDatetime?.minute == 0)
    XCTAssert(newDatetime?.second == 0)
  }
  
  func testInitWithComponentsNow() {
    let dateComponents: DateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
    if let year = dateComponents.year, let month = dateComponents.month, let day = dateComponents.day, let hour = dateComponents.hour, let minute = dateComponents.minute, let second = dateComponents.second {
      let datetimeFromComponents: Datetime? = Datetime(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
      if let datetimeFromComponents = datetimeFromComponents {
        let datetimeFromDate: Datetime = Datetime(date: Date())
        XCTAssert(datetimeFromComponents == datetimeFromDate)
      }
      else {
        XCTAssert(false)
      }
    }
    else {
      XCTAssert(false)
    }
  }
  
  func testInitWithString() {
    XCTAssert(Datetime(string: "", format: "") == nil)
    XCTAssert(Datetime(string: "2001/09/11T09:10:00+0000", format: "") == nil)
    XCTAssert(Datetime(string: "", format: "yyyy/MM/ddThh:mm:ss+0000") == nil)
    let newDatetime: Datetime? = Datetime(string: "2001/09/11T09:10:00+0000", format: "yyyy/MM/ddThh:mm:ss+0000")
    XCTAssert(newDatetime != nil)
    XCTAssert(newDatetime?.year == 2001)
    XCTAssert(newDatetime?.month == 9)
    XCTAssert(newDatetime?.day == 11)
    XCTAssert(newDatetime?.hour == 9)
    XCTAssert(newDatetime?.minute == 10)
    XCTAssert(newDatetime?.second == 0)
    let newDatetimeSimple: Datetime? = Datetime(string: "2001-09-11", format: "yyyy-MM-dd")
    XCTAssert(newDatetimeSimple != nil)
    XCTAssert(newDatetimeSimple?.year == 2001)
    XCTAssert(newDatetimeSimple?.month == 9)
    XCTAssert(newDatetimeSimple?.day == 11)
    XCTAssert(newDatetimeSimple?.hour == 0)
    XCTAssert(newDatetimeSimple?.minute == 0)
    XCTAssert(newDatetimeSimple?.second == 0)
  }
  
  // MARK: - Comparable Test case
  
  func testEqualSameDatetime() {
    let date1: Datetime = Datetime()
    let date2: Datetime = Datetime()
    XCTAssert(date1 == date2)
  }
  
  func testEqualSameDatetimeObject() {
    let date1: Datetime = Datetime()
    let date2: Datetime = date1
    XCTAssert(date1 == date2)
  }
  
  func testEqualNilDatetime() {
    let date1: Datetime? = nil
    let date2: Datetime? = nil
    XCTAssert(date1 == date2)
  }
  
  func testNotEqualNilAndDatetime() {
    let date1: Datetime = Datetime()
    let date2: Datetime? = nil
    XCTAssert(date1 != date2)
  }
  
  // MARK: - Interval Test case
  
  func testInterval7s() {
    let firstDatetime: Datetime = Datetime(date: Date())
    let secondDateTime: Datetime? = firstDatetime.datetimeByAdding(second: 7)
    XCTAssert(secondDateTime != nil)
    XCTAssert(Datetime.interval(from: firstDatetime, to: secondDateTime!) == 7)
  }
  
  func testIntervalFrom1970To1970() {
    if let datetime = Datetime(year: 1970, month: 1, day: 1, hour: 0, minute: 0, second: 0) {
      XCTAssert(datetime.intervalFrom1970() == 0)
    }
  }
  
  // MARK: - ToString Test case
  
  func testToString() {
    if let date = Datetime(year: 1, month: 1, day: 1, hour: 1, minute: 1, second: 1) {
      XCTAssert(date.toString() == "0001/01/01 01:01:01")
    }
    if let date = Datetime(year: 1492, month: 6, day: 30, hour: 14, minute: 42, second: 10) {
      XCTAssert(date.toString() == "1492/06/30 14:42:10")
    }
    if let date = Datetime(year: -1492, month: 6, day: 30, hour: 14, minute: 42, second: 10) {
      XCTAssert(date.toString() == "-1492/06/30 14:42:10")
    }
    if let date = Datetime(year: -1, month: 12, day: 31, hour: 23, minute: 59, second: 59) {
      XCTAssert(date.toString() == "-0001/12/31 23:59:59")
    }
  }
}
