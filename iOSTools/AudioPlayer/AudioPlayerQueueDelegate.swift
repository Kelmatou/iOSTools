//
//  AudioPlayerQueueDelegate.swift
//  iOSTools
//
//  Created by Antoine Clop on 11/3/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import Foundation

public protocol AudioPlayerQueueDelegate: class {
  
  func queueUpdate(_ audioQueue: AudioQueue, queue: [String])
  func currentSongRemoved(_ audioQueue: AudioQueue, song: String)
}

extension AudioQueue: AudioPlayerQueueDelegate {
  
  public func queueUpdate(_ audioQueue: AudioQueue, queue: [String]) {
    if let delegate = delegate {
      delegate.queueUpdate(audioQueue, queue: queue)
    }
  }
  
  public func currentSongRemoved(_ audioQueue: AudioQueue, song: String) {
    if let delegate = delegate {
      delegate.currentSongRemoved(audioQueue, song: song)
    }
  }
}
