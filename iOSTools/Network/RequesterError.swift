//
//  RequesterError.swift
//  iOSTools
//
//  Created by Antoine Clop on 10/5/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import Foundation

class RequesterError: GenericError {
  
  override init(_ msg: String) {
    super.init(description: msg, failure: msg, recovery: "Try to replace special characters", help: "Some characters have special translation '(' = %28, ')' = %29...")
  }
}
