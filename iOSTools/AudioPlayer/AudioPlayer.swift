//
//  AudioPlayer.swift
//  iOSTools
//
//  Created by Antoine Clop on 10/31/17.
//  Copyright © 2017 clop_a. All rights reserved.
//


import UIKit
import AVFoundation

open class AudioPlayer: NSObject {
  
  public enum PlayerState {
    case Playing // Audio is being played
    case Paused  // Audio is stopped but player is ready to play()
    case Stopped // Audio is stopped, player may be ready or not. Must call prepareCurrentSong()
  }
  
  public enum AudioUsage {
    case Foreground // Audio will be heard even in silent mode
    case Background // Audio will be heard only if silent mode is disabled. When possible, use it!
  }
  
  // MARK: - Variables
  internal var player: AVAudioPlayer?
  
  public weak var delegate: AudioPlayerDelegate?
  public var songQueue: AudioQueue = AudioQueue(audioSongs: [])
  public var autoPlay: Bool = true
  public var audioUsage: AudioUsage = .Foreground
  private(set) public var status: PlayerState = .Stopped
  private var canReplaySong: Bool = true
  private var volume: Float = 1
  
  // MARK: - Init Player
  
  override public init() {
    super.init()
    songQueue.delegate = self
  }
  
  convenience init(withSongs: [String] = [], autoPlay: Bool = true, audioUsage: AudioUsage = .Foreground) {
    self.init()
    songQueue.append(withSongs)
    songQueue.delegate = self
    self.autoPlay = autoPlay
    self.audioUsage = audioUsage
  }
  
  /**
   Create a new player that will play file given
   
   - parameter withContent: the path of song's file
   */
  internal func initPlayer(withContent: URL) {
    do {
      try AVAudioSession.sharedInstance().setCategory(audioUsage == .Foreground ? AVAudioSessionCategoryPlayback : AVAudioSessionCategorySoloAmbient)
      player = try AVAudioPlayer(contentsOf: withContent)
      player?.delegate = self
      player?.volume = volume
    }
    catch {
      debugPrint("[ERROR]: Cannot create player")
      fatalError()
    }
  }
  
  /**
   Load a new player with currently selected song in queue
   Note: calling this method will STOP audioPlayer and update its status
   */
  internal func prepareCurrentSong() {
    if let nextSongURL = songQueue.getCurrentSongURL() {
      initPlayer(withContent: nextSongURL)
      canReplaySong = true
      status = .Stopped
      if let filename = songQueue.getCurrentSongFile() {
        songLoaded(self, song: filename)
      }
    }
    else {
      player = nil
    }
  }
  
  // MARK: - Public API
  
  /**
   Play currently selected track
   */
  public func play() {
    guard !songQueue.internalSongs.isEmpty && status != .Playing else {
      debugPrint("[ERROR]: No songs in queue to be played")
      return
    }
    if status == .Stopped {
      prepareCurrentSong()
    }
    guard let player = player else {
      debugPrint("[ERROR]: Cannot play song")
      didStop(self)
      return
    }
    if let filename = songQueue.getCurrentSongFile() {
      willStartPlaying(self, song: filename)
    }
    player.play()
    status = .Playing
  }
  
  /**
   Replay currently selected track.
   */
  public func replay() {
    guard canReplaySong else {
      debugPrint("[ERROR]: Cannot replay song")
      return
    }
    prepareCurrentSong()
    play()
    if let filename = songQueue.getCurrentSongFile() {
      didReplay(self, song: filename)
    }
  }
  
  /**
   Stop currently selected track and selected first track in queue
   */
  public func stop() {
    guard status != .Stopped else {
      debugPrint("[ERROR]: Already stopped")
      return
    }
    if let player = player {
      player.stop()
    }
    songQueue.setCurrentSong(at: 0)
    status = .Stopped
    didStop(self)
  }
  
  /**
   Pause currently playing track
   */
  public func pause() {
    guard status == .Playing, let player = player else {
      debugPrint("[ERROR]: Cannot pause song")
      return
    }
    player.pause()
    status = .Paused
    if let filename = songQueue.getCurrentSongFile() {
      didPause(self, song: filename)
    }
  }
  
  /**
   Jump to the previous track (does nothing if already first track). If player status was Playing, start new track
   */
  public func fastRewind() {
    guard !songQueue.currentIsFirstSong() || songQueue.canLoop else {
      debugPrint("[ERROR]: Cannot rewind: already first song")
      return
    }
    let currentStatus: PlayerState = status
    songQueue.setCurrentSong(.Prev)
    prepareCurrentSong()
    if let filename = songQueue.getCurrentSongFile() {
      didMoveRewind(self, song: filename)
    }
    if currentStatus == .Playing {
      play()
    }
  }
  
  /**
   Jump to the next track (Stop player if already last track). If player status was Playing, start new track
   */
  public func fastFoward() {
    guard !songQueue.currentIsLastSong() || songQueue.canLoop else {
      debugPrint("[ERROR]: Cannot forward: already last song")
      return
    }
    let currentStatus: PlayerState = status
    if songQueue.setCurrentSong(.Next) {
      didMoveForward(self, song: songQueue.getCurrentSongFile())
      prepareCurrentSong()
      if currentStatus == .Playing {
        play()
      }
    }
    else {
      didReachEndOfQueue(self)
      stop()
    }
  }
  
  /**
   Set current volume coefficient
   
   - parameter volume: the coefficient of current device's volume
   */
  public func setVolume(_ volume: Float) {
    self.volume = volume
    didChangeVolume(self, newVolume: volume)
    if let player = player {
      player.volume = volume
    }
  }
}

extension AudioPlayer: AVAudioPlayerDelegate {
  
  public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    status = .Stopped
    if let filename = songQueue.getCurrentSongFile() {
      didFinishPlaying(self, song: filename)
    }
    if songQueue.currentIsLastSong() {
      didReachEndOfQueue(self)
    }
    if !autoPlay || songQueue.currentIsLastSong() {
      songQueue.setCurrentSong(.Next, allowLoop: true)
      didStop(self)
    }
    else {
      songQueue.setCurrentSong(.Next)
      play()
    }
  }
}

extension AudioPlayer: AudioPlayerQueueDelegate {
  
  public func queueUpdate(_ audioQueue: AudioQueue, queue: [String]) {
    queueUpdated(self, queue: queue)
  }
  
  public func currentSongRemoved(_ audioQueue: AudioQueue, song: String) {
    canReplaySong = false
  }
}

