//
//  Datetime.swift
//  iOSTools
//
//  Created by Antoine Clop on 7/21/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import Foundation

public class Datetime: Comparable, Equatable {
  
  // MARK: - Variable
  
  private var date: Date
  
  private var negativeYear: Bool = false
  
  public var year: Int {
    let yearDate: Int = Calendar.current.component(.year, from: date)
    return negativeYear ? -yearDate + 1 : yearDate
  }
  
  public var month: Int {
    return Calendar.current.component(.month, from: date)
  }
  
  public var day: Int {
    return Calendar.current.component(.day, from: date)
  }
  
  public var hour: Int {
    return Calendar.current.component(.hour, from: date)
  }
  
  public var minute: Int {
    return Calendar.current.component(.minute, from: date)
  }
  
  public var second: Int {
    return Calendar.current.component(.second, from: date)
  }
  
  public var monthName: String {
    return Datetime.monthFromInt(month)?.rawValue ?? ""
  }
  
  public var weekday: String {
    return Datetime.weekDayFromInt(weekdayIndex)?.rawValue ??  ""
  }
  
  public var weekdayIndex: Int {
    return getDayIndexInWeek()
  }
  
  // MARK: - Init
  
  public init() {
    self.date = Date()
  }
  
  public init(date: Date) {
    self.date = date
  }
  
  public init?(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0, timeZone: TimeZone? = nil) {
    negativeYear = year < 0
    let dateComponents: DateComponents = DateComponents(calendar: nil, timeZone: timeZone , era: nil, year: year, month: month, day: day, hour: hour, minute: minute, second: second, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
    let newDate: Date? = Calendar.current.date(from: dateComponents)
    guard let unwrappedNewDate = newDate else {
      return nil
    }
    self.date = unwrappedNewDate
  }
  
  public convenience init?(dateTime: Datetime, timeZone: TimeZone) {
    self.init(year: dateTime.year, month: dateTime.month, day: dateTime.day, hour: dateTime.hour, minute: dateTime.minute, second: dateTime.second, timeZone: timeZone)
  }
  
  public convenience init?(string: String, format: String) {
    guard Datetime.isValidCreationDateFormat(format) && string.length == format.length else {
      return nil
    }
    let indexYear: Int? = format.firstOccurencePosition(of: "yyyy")
    let indexMonth: Int? = format.firstOccurencePosition(of: "MM")
    let indexDay: Int? = format.firstOccurencePosition(of: "dd")
    let indexHour: Int? = format.firstOccurencePosition(of: "hh")
    let indexMinute: Int? = format.firstOccurencePosition(of: "mm")
    let indexSecond: Int? = format.firstOccurencePosition(of: "ss")
    var year: Int = 0
    var month: Int = 0
    var day: Int = 0
    var hour: Int = 0
    var minute: Int = 0
    var second: Int = 0
    if let indexYear = indexYear, let yearStr = string.substring(startIndex: indexYear, length: 4) {
      year = Int(yearStr) ?? 1
    }
    if let indexMonth = indexMonth, let monthStr = string.substring(startIndex: indexMonth, length: 2) {
      month = Int(monthStr) ?? 1
    }
    if let indexDay = indexDay, let dayStr = string.substring(startIndex: indexDay, length: 2) {
      day = Int(dayStr) ?? 1
    }
    if let indexHour = indexHour, let hourStr = string.substring(startIndex: indexHour, length: 2) {
      hour = Int(hourStr) ?? 0
    }
    if let indexMinute = indexMinute, let minuteStr = string.substring(startIndex: indexMinute, length: 2) {
      minute = Int(minuteStr) ?? 0
    }
    if let indexSecond = indexSecond, let secondStr = string.substring(startIndex: indexSecond, length: 2) {
      second = Int(secondStr) ?? 0
    }
    self.init(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
  }
  
  // MARK: - Public methods
  
  /**
   Operator == for Datetime.
   
   - parameter date1: a Datetime object
   - parameter date2: a Datetime object
   
   - returns: true if (year, month, day, hour, minute and second) are the same.
  */
  public static func ==(date1: Datetime, date2: Datetime) -> Bool {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day
        && date1.hour == date2.hour && date1.minute == date2.minute && date1.second == date2.second
  }
  
  /**
   Operator < for Datetime.
   
   - parameter date1: a Datetime object
   - parameter date2: a Datetime object
   
   - returns: true if (year, month, day, hour, minute and second) are the same.
   */
  public static func <(date1: Datetime, date2: Datetime) -> Bool {
    return date1.year < date2.year || (date1.year == date2.year
        && date1.month < date2.month || (date1.month == date2.month
        && date1.day < date2.day || (date1.day == date2.day
        && date1.hour < date2.hour || (date1.hour == date2.hour
        && date1.minute < date2.minute || (date1.minute == date2.minute
        && date1.second < date2.second)))))
  }
  
  /**
   Create a new Datetime object by adding any amount of time
   
   - parameter year: the amount of year to add
   - parameter month: the amount of month to add
   - parameter day: the amount of day to add
   - parameter hour: the amount of hour to add
   - parameter minute: the amount of minute to add
   - parameter second: the amount of second to add

   - returns: a new datetime with time added. nil is returned if date couldn't be calculated
  */
  public func datetimeByAdding(year: Int = 0, month: Int = 0, day: Int = 0, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Datetime? {
    let date1: Date? = Calendar.current.date(byAdding: .year, value: year, to: date)
    guard let date1Unwrapped = date1 else { return nil }
    let date2: Date?  = Calendar.current.date(byAdding: .month, value: month, to: date1Unwrapped)
    guard let date2Unwrapped = date2 else { return nil }
    let date3: Date?  = Calendar.current.date(byAdding: .day, value: day, to: date2Unwrapped)
    guard let date3Unwrapped = date3 else { return nil }
    let date4: Date?  = Calendar.current.date(byAdding: .hour, value: hour, to: date3Unwrapped)
    guard let date4Unwrapped = date4 else { return nil }
    let date5: Date?  = Calendar.current.date(byAdding: .minute, value: minute, to: date4Unwrapped)
    guard let date5Unwrapped = date5 else { return nil }
    let date6: Date?  = Calendar.current.date(byAdding: .second, value: second, to: date5Unwrapped)
    guard let date6Unwrapped = date6 else { return nil }
    return Datetime(date: date6Unwrapped)
  }
  
  /**
   Get number of seconds from now in seconds
   
   - parameter date1: a Datetime object
   - parameter date2: a Datetime object
   
   - returns: number of second from date1 to date2
  */
  public static func interval(from date1: Datetime, to date2: Datetime) -> Double? {
    if let interval1 = date1.intervalFrom1970(), let interval2 = date2.intervalFrom1970() {
      return interval2 - interval1
    }
    return nil
  }
  
  /**
   Get number of seconds from 1st January 1970 in seconds

   
   - returns: number of second from 1st January 1970 in seconds
   */
  public func intervalFrom1970() -> Double? {
    let datetimeUTC = Datetime(dateTime: self, timeZone: TimeZone(identifier: "UTC")!)
    if let datetimeUTC = datetimeUTC {
      return datetimeUTC.date.timeIntervalSince1970
    }
    return nil
  }
  
  /**
   Get current Datetime as String (default format is yyyy/MM/dd hh:mm:ss)
   
   - parameter format: the format of the String output
   
   - returns: a String representing Datetime object
   */
  public func toString(format: String = "yyyy/MM/dd hh:mm:ss") -> String {
    let year4Format: String = (year < 0 ? "-" : "") + (year.isBetween(min: -999, max: 999) ? year.isBetween(min: -99, max: 99) ? year.isBetween(min: -9, max: 9) ? "000" : "00" : "0" : "") + "\(year < 0 ? -year : year)"
    let year2Format: String = (year < 0 ? "-" : "") + (year4Format.substring(startIndex: year4Format.length - 2 < 0 ? 0 : year4Format.length - 2) ?? "")
    let monthFormat: String = (month < 10 ? "0" : "") + "\(month)"
    let dayFormat: String = (day < 10 ? "0" : "") + "\(day)"
    let hourFormat: String = (hour < 10 ? "0" : "") + "\(hour)"
    let minuteFormat: String = (minute < 10 ? "0" : "") + "\(minute)"
    let secondFormat: String = (second < 10 ? "0" : "") + "\(second)"
    var index: Int = 0
    var output: String = ""
    while (index < format.length) {
      if let token = Datetime.recognizeToken(format, at: index) {
        switch token {
        case "yyyy":
          output += year4Format
        case "yy":
          output += year2Format
        case "MM":
          output += monthFormat
        case "dd":
          output += dayFormat
        case "hh":
          output += hourFormat
        case "mm":
          output += minuteFormat
        case "ss":
          output += secondFormat
        default:
          continue
        }
        index += token.length
      }
      else {
        output.append(format[format.index(format.startIndex, offsetBy: index)])
        index += 1
      }
    }
    return output
  }
  
  // MARK: - Private methods
  
  private static func isValidCreationDateFormat(_ dateStr: String) -> Bool {
    return dateStr.numberOccurence(of: "yyyy") == 1
        && dateStr.numberOccurence(of: "MM") == 1
        && dateStr.numberOccurence(of: "dd") == 1
        && dateStr.numberOccurence(of: "hh") <= 1
        && dateStr.numberOccurence(of: "mm") <= 1
        && dateStr.numberOccurence(of: "ss") <= 1
  }
  
  private static func recognizeToken(_ str: String, at index: Int) -> String? {
    if let next4bytes = str.substring(startIndex: index, length: 4) {
      if next4bytes == "yyyy" { return "yyyy" }
    }
    if let next2bytes = str.substring(startIndex: index, length: 2) {
      if next2bytes == "yy" { return "yy" }
      if next2bytes == "MM" { return "MM" }
      if next2bytes == "dd" { return "dd" }
      if next2bytes == "hh" { return "hh" }
      if next2bytes == "mm" { return "mm" }
      if next2bytes == "ss" { return "ss" }
    }
    return nil
  }
  
  /**
   Returns the index of a day in week
   0 = Monday
   6 = Sunday
   
   - parameter date: the day
   
   - returns: Int representing the index of the day
   */
  private func getDayIndexInWeek() -> Int {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone(identifier: "UTC")!
    let firstWeekDay = calendar.component(.weekday, from: date)
    if firstWeekDay == 1 {
      return 6
    }
    else if firstWeekDay == 2 {
      return 0
    }
    else {
      return firstWeekDay - 2
    }
  }
}
