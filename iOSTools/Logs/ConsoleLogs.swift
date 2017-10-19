//
//  ConsoleLogs.swift
//  iOSTools
//
//  Created by Antoine Clop on 9/21/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import Foundation

open class Logs {
  
  public static let iOSToolsVersion: String = "iOSTools - Version \(Bundle(identifier: "com.clop-a.iOSTools")?.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown")"

  public static var alwaysPrintTime: Bool = false
  public static var printAsDebug: Bool = false
  
  /**
   Pring a message
   
   - parameter message: the message to display
   - parameter tag: an optional tag to display before message
   - parameter time: print time before tag and message (overrides alwaysPrintTime value)
   
   - returns: the output String
   */
  @discardableResult public static func print(message: String?, tag: String? = nil, time: Bool? = nil) -> String {
    let output: String = outputMessage(message: message, tag: tag, time: (time ?? Logs.alwaysPrintTime))
    outputMessage(output)
    return output
  }
  
  /**
   Pring a message with [INFO] tag
   
   - parameter message: the message to display
   - parameter time: print time before tag and message (overrides alwaysPrintTime value)
   
   - returns: the output String
   */
  @discardableResult public static func info(message: String?, time: Bool? = nil) -> String {
    let output: String = outputMessage(message: message, tag: "INFO", time: (time ?? Logs.alwaysPrintTime))
    outputMessage(output)
    return output
  }
  
  /**
   Pring a message with [DEBUG] tag
   
   - parameter message: the message to display
   - parameter time: print time before tag and message (overrides alwaysPrintTime value)
   
   - returns: the output String
   */
  @discardableResult public static func debug(message: String?, time: Bool? = nil) -> String  {
    let output: String = outputMessage(message: message, tag: "DEBUG", time: (time ?? Logs.alwaysPrintTime))
    outputMessage(output)
    return output
  }
  
  /**
   Pring a message with [WARNING] tag
   
   - parameter message: the message to display
   - parameter time: print time before tag and message (overrides alwaysPrintTime value)
   
   - returns: the output String
   */
  @discardableResult public static func warning(message: String?, time: Bool? = nil) -> String  {
    let output: String = outputMessage(message: message, tag: "WARNING", time: (time ?? Logs.alwaysPrintTime))
    outputMessage(output)
    return output
  }
  
  /**
   Pring a message with [ERROR] tag
   
   - parameter message: the message to display
   - parameter time: print time before tag and message (overrides alwaysPrintTime value)
   
   - returns: the output String
   */
  @discardableResult public static func error(message: String?, time: Bool? = nil) -> String  {
    let output: String = outputMessage(message: message, tag: "ERROR", time: (time ?? Logs.alwaysPrintTime))
    outputMessage(output)
    return output
  }
  
  /**
   Generate the output String
   
   - parameter message: the String message to display
   - parameter tag: the String to use as tag
   - parameter time: a Bool that determines if time will be displayed or not
   
   - returns: a String with format: "[TIME][TAG]: MESSAGE"
   */
  public static func outputMessage(message: String?, tag: String? = nil, time: Bool = false) -> String {
    var timeString: String {
      if time {
        let now: Datetime = Datetime()
        return "[\(now.toString())]"
      }
      else {
        return ""
      }
    }
    let tagFormat: String = tag == nil ? "" : "[\(tag!)]"
    let outputHeader: String = timeString + tagFormat
    return "\(outputHeader)\(outputHeader.length == 0 ? "" : ": ")\(message ?? "")"
  }
  
  /**
   Print a message as debug or default. This output flux depends on property 'printAsDebug'
   
   - parameter message: the String to print
   */
  private static func outputMessage(_ message: String) {
    if printAsDebug {
      debugPrint(message)
    }
    else {
      Swift.print(message)
    }
  }
}
