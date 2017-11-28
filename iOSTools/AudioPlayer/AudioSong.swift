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
  internal var removed: Bool = false
  
  // MARK: - Initializer
  
  public init(_ name: String) {
    self.name = name
  }
  
  // MARK: - Static
  
  public static func toStringArray(_ songs: [AudioSong]) -> [String] {
    var songsString: [String] = []
    if songs.count > 0 {
      for song in songs {
        if !song.removed {
          songsString.append(song.name)
        }
      }
    }
    return songsString
  }
}
