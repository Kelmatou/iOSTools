//
//  AudioPlayerDelegate.swift
//  iOSTools
//
//  Created by Antoine Clop on 10/31/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import Foundation

@objc public protocol AudioPlayerDelegate: class {
  
  @objc optional func queueUpdated(_ player: AudioPlayer, queue: [String])
  @objc optional func willStartPlaying(_ player: AudioPlayer, song: String)
  @objc optional func didFinishPlaying(_ player: AudioPlayer, song: String)
  @objc optional func didReachEndOfQueue(_ player: AudioPlayer)
  @objc optional func didChangeVolume(_ player: AudioPlayer, newVolume: Float)
  @objc optional func didPause(_ player: AudioPlayer, song: String)
  @objc optional func didStop(_ player: AudioPlayer)
  @objc optional func didReplay(_ player: AudioPlayer, song: String)
  @objc optional func didMoveForward(_ player: AudioPlayer, song: String?)
  @objc optional func didMoveRewind(_ player: AudioPlayer, song: String)
}

extension AudioPlayer: AudioPlayerDelegate {
  
  public func queueUpdated(_ player: AudioPlayer, queue: [String]) {
    if let delegate = self.delegate, let queueUpdated = delegate.queueUpdated {
      queueUpdated(player, queue)
    }
  }
  
  public func willStartPlaying(_ player: AudioPlayer, song: String) {
    if let delegate = self.delegate, let willStartPlaying = delegate.willStartPlaying {
      willStartPlaying(player, song)
    }
  }
  
  public func didFinishPlaying(_ player: AudioPlayer, song: String) {
    if let delegate = self.delegate, let didFinishPlaying = delegate.didFinishPlaying {
      didFinishPlaying(player, song)
    }
  }
  
  public func didReachEndOfQueue(_ player: AudioPlayer) {
    if let delegate = self.delegate, let didReachEndOfQueue = delegate.didReachEndOfQueue {
      didReachEndOfQueue(player)
    }
  }
  
  public func didChangeVolume(_ player: AudioPlayer, newVolume: Float) {
    if let delegate = self.delegate, let didChangeVolume = delegate.didChangeVolume {
      didChangeVolume(player, newVolume)
    }
  }
  
  public func didPause(_ player: AudioPlayer, song: String) {
    if let delegate = self.delegate, let didPause = delegate.didPause {
      didPause(player, song)
    }
  }
  
  public func didStop(_ player: AudioPlayer) {
    if let delegate = self.delegate, let didStop = delegate.didStop {
      didStop(player)
    }
  }
  
  public func didReplay(_ player: AudioPlayer, song: String) {
    if let delegate = self.delegate, let didReplay = delegate.didReplay {
      didReplay(player, song)
    }
  }
  
  public func didMoveForward(_ player: AudioPlayer, song: String?) {
    if let delegate = self.delegate, let didMoveForward = delegate.didMoveForward {
      didMoveForward(player, song)
    }
  }
  
  public func didMoveRewind(_ player: AudioPlayer, song: String) {
    if let delegate = self.delegate, let didMoveRewind = delegate.didMoveRewind {
      didMoveRewind(player, song)
    }
  }
}
