//
//  AudioSong.swift
//  iOSTools
//
//  Created by Antoine Clop on 11/3/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import Foundation

open class AudioSong {
  
  // MARK: - Properties
  
  public var name: String
  public var filename: String
  
  // MARK: - Initializer
  
  public init(_ filename: String, named: String? = nil) {
    self.filename = filename
    if let name = named {
      self.name = name
    }
    else if let lastComponent = filename.split(separator: "/").last {
      self.name = String(describing: lastComponent)
    }
    else {
      self.name = filename
    }
  }
}

