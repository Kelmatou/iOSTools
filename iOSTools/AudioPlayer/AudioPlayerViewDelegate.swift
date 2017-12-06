//
//  AudioPlayerViewDelegate.swift
//  iOSTools
//
//  Created by Antoine Clop on 11/7/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import Foundation

extension AudioPlayerView: AudioPlayerDelegate {
  
  public func queueUpdated(_ player: AudioPlayer, queue: [String]) {
    if let delegate = self.delegate, let queueUpdated = delegate.queueUpdated {
      queueUpdated(player, queue)
    }
  }
  
  public func songLoaded(_ player: AudioPlayer, song: String) {
    playingNow.text = player.songQueue.getCurrentSongName()
    if let delegate = self.delegate, let songLoaded = delegate.songLoaded {
      songLoaded(player, song)
    }
  }
  
  public func willStartPlaying(_ player: AudioPlayer, song: String) {
    timerUpdate(running: true)
    playButtonUpdate(playing: true)
    if let delegate = self.delegate, let willStartPlaying = delegate.willStartPlaying {
      willStartPlaying(player, song)
    }
  }
  
  public func didFinishPlaying(_ player: AudioPlayer, song: String) {
    progressBar.setProgress(0, animated: false)
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
    playButtonUpdate(playing: false)
    timerUpdate(running: false)
    if let delegate = self.delegate, let didPause = delegate.didPause {
      didPause(player, song)
    }
  }
  
  public func didStop(_ player: AudioPlayer) {
    playingNow.text = noSongTitle
    timerUpdate(running: false)
    progressBar.setProgress(0, animated: false)
    playButtonUpdate(playing: false)
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
    progressBar.setProgress(0, animated: false)
    if let delegate = self.delegate, let didMoveForward = delegate.didMoveForward {
      didMoveForward(player, song)
    }
  }
  
  public func didMoveRewind(_ player: AudioPlayer, song: String) {
    progressBar.setProgress(0, animated: false)
    if let delegate = self.delegate, let didMoveRewind = delegate.didMoveRewind {
      didMoveRewind(player, song)
    }
  }
}
