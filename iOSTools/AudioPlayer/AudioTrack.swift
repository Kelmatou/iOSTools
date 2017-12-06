//
//  AudioTrack.swift
//  iOSTools
//
//  Created by Antoine Clop on 12/6/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import Foundation

open class AudioTrack {
  
  // MARK: - Properties
  
  public var name: String {
    return title.name
  }
  public var filename: String {
    return title.filename
  }
  
  internal var title: AudioSong
  internal var removed: Bool = false

  // MARK: - Initializer
  
  internal init(_ song: AudioSong) {
    self.title = song
  }
  
  internal convenience init(_ songfile: String) {
    let audioSong: AudioSong = AudioSong(songfile)
    self.init(audioSong)
  }
  
  // MARK: - Static
  
  internal static func toStringArray(_ songs: [AudioTrack]) -> [String] {
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
