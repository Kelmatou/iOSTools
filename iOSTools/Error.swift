//
//  File.swift
//  iOSTools
//
//  Created by Antoine Clop on 10/5/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import Foundation

struct GenericErrorStruct: LocalizedError
{
  var errorDescription: String? {
    return description
  }
  var failureReason: String? {
    return failure
  }
  var recoverySuggestion: String? {
    return recovery
  }
  var helpAnchor: String? {
    return help
  }
  
  internal var description : String
  internal var failure: String
  internal var recovery: String
  internal var help: String
  
  init(description: String?, failure: String? = nil, recovery: String? = nil, help: String? = nil) {
    self.description = description ?? ""
    self.failure = failure ?? ""
    self.recovery = recovery ?? ""
    self.help = help ?? ""
  }
}

public class GenericError {
  
  internal var internalError: GenericErrorStruct
  
  init(_ msg: String) {
    internalError = GenericErrorStruct(description: msg, failure: msg, recovery: "No recovery available", help: "No help available")
  }
  
  init(description: String?, failure: String? = nil, recovery: String? = nil, help: String? = nil) {
    internalError = GenericErrorStruct(description: description, failure: failure, recovery: recovery, help: help)
  }
}
