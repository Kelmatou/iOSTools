//
//  ConsoleLogs.swift
//  iOSTools
//
//  Created by Antoine Clop on 9/21/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import Foundation

public class Logs {
  
  public static let iOSToolsVersion: String = "iOSTools - Version \(Bundle(identifier: "com.clop-a.iOSTools")?.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown")"

  public static var alwaysPrintTime: Bool = false
  
  @discardableResult public static func print(message: String?, tag: String? = nil, time: Bool? = nil) -> String {
    let output: String = outputMessage(message: message, tag: tag, time: (time ?? Logs.alwaysPrintTime))
    debugPrint(output)
    return output
  }
  
  @discardableResult public static func info(message: String?, time: Bool? = nil) -> String {
    let output: String = outputMessage(message: message, tag: "INFO", time: (time ?? Logs.alwaysPrintTime))
    debugPrint(output)
    return output
  }
  
  @discardableResult public static func debug(message: String?, time: Bool? = nil) -> String  {
    let output: String = outputMessage(message: message, tag: "DEBUG", time: (time ?? Logs.alwaysPrintTime))
    debugPrint(output)
    return output
  }
  
  @discardableResult public static func warning(message: String?, time: Bool? = nil) -> String  {
    let output: String = outputMessage(message: message, tag: "WARNING", time: (time ?? Logs.alwaysPrintTime))
    debugPrint(output)
    return output
  }
  
  @discardableResult public static func error(message: String?, time: Bool? = nil) -> String  {
    let output: String = outputMessage(message: message, tag: "ERROR", time: (time ?? Logs.alwaysPrintTime))
    debugPrint(output)
    return output
  }
  
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
}
