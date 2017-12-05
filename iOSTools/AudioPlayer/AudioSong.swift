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
  internal var filename: String
  internal var removed: Bool = false
  
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
  
  // MARK: - Static
  
  public static func toStringArray(_ songs: [AudioSong]) -> [String] {
    var songsString: [String] = []
    if songs.count > 0 {
      for song in songs {
        if !song.removed {
          songsString.append(song.filename)
        }
      }
    }
    return songsString
  }
}

