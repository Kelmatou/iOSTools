//
//  DatetimeEnums.swift
//  iOSTools
//
//  Created by Antoine Clop on 10/18/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import Foundation

extension Datetime {
  
  public enum Month: String {
    case January = "January"
    case February = "February"
    case March = "March"
    case April = "April"
    case May = "May"
    case June = "June"
    case July = "July"
    case August = "August"
    case September = "September"
    case October = "October"
    case November = "November"
    case December = "December"
  }
  
  public enum WeekDay: String {
    case Monday = "Monday"
    case Tuesday = "Tuesday"
    case Wednesday = "Wednesday"
    case Thursday = "Thursday"
    case Friday = "Friday"
    case Saturday = "Saturday"
    case Sunday = "Sunday"
  }

  /**
   Returns the name of month in year
   
   - parameter val: the index of the month in year (0 = Monday, 6 = Sunday)
   
   - returns: a Month representing month's name or nil if 1 > val or 12 < val
   */
  public static func monthFromInt(_ val: Int) -> Month? {
    switch val {
    case 1:  return .January
    case 2:  return .February
    case 3:  return .March
    case 4:  return .April
    case 5:  return .May
    case 6:  return .June
    case 7:  return .July
    case 8:  return .August
    case 9:  return .September
    case 10: return .October
    case 11: return .November
    case 12: return .December
    default: return nil
    }
  }
  
  /**
   Returns the name of day in week

   - parameter val: the index of the day in week (0 = Monday, 6 = Sunday)
   
   - returns: a WeekDay representing day's name or nil if 0 > val or 6 < val
   */
  public static func weekDayFromInt(_ val: Int) -> WeekDay? {
    switch val {
    case 0:  return .Monday
    case 1:  return .Tuesday
    case 2:  return .Wednesday
    case 3:  return .Thursday
    case 4:  return .Friday
    case 5:  return .Saturday
    case 6:  return .Sunday
    default: return nil
    }
  }
}
