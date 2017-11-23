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
    case Paused  // Audio is stoped but player is ready to play()
    case Stoped  // Audio is stoped, player may be ready or not. Must call prepareCurrentSong()
  }
  
  // MARK: - Variables
  internal var player: AVAudioPlayer?
  
  public weak var delegate: AudioPlayerDelegate?
  public var songQueue: AudioQueue = AudioQueue()
  public var autoPlay: Bool = true
  private(set) public var status: PlayerState = .Stoped
  private var canReplaySong: Bool = true
  
  // MARK: - Init Player
  
  override public init() {
    super.init()
    songQueue.delegate = self
  }
  
  convenience init(withSongs: [String] = [], autoPlay: Bool = true) {
    self.init()
    songQueue.append(withSongs)
    songQueue.delegate = self
    self.autoPlay = autoPlay
  }
  
  /**
   Create a new player that will play file given
   
   - parameter withContent: the path of song's file
   */
  internal func initPlayer(withContent: URL) {
    do {
      player = try AVAudioPlayer(contentsOf: withContent)
      player?.delegate = self
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
      status = .Stoped
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
    guard !songQueue.songQueue.isEmpty && status != .Playing else {
      return
    }
    debugPrint("Current track: \(songQueue.currentSong)")
    for song in songQueue.songQueue {
      debugPrint("Song: \(song.name)")
    }
    if status == .Stoped {
      prepareCurrentSong()
    }
    guard let player = player else {
      debugPrint("[ERROR]: Cannot play song")
      return
    }
    if let song = songQueue.getCurrentSongName() {
      willStartPlaying(self, song: song)
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
    if let song = songQueue.getCurrentSongName() {
      didReplay(self, song: song)
    }
  }
  
  /**
   Stop currently selected track and selected first track in queue
   */
  public func stop() {
    guard status != .Stoped else {
      return
    }
    if let player = player {
      player.stop()
    }
    songQueue.setCurrentSong(at: 0)
    status = .Stoped
    didStop(self)
  }
  
  /**
   Pause currently playing track
   */
  public func pause() {
    guard status == .Playing else {
      debugPrint("[ERROR]: Cannot pause song")
      return
    }
    if let player = player {
      player.pause()
      status = .Paused
      if let song = songQueue.getCurrentSongName() {
        didPause(self, song: song)
      }
    }
  }
  
  /**
   Jump to the previous track (does nothing if already first track). If player status was Playing, start new track
   */
  public func fastRewind() {
    let currentStatus: PlayerState = status
    songQueue.setCurrentSong(.Prev)
    prepareCurrentSong()
    if let song = songQueue.getCurrentSongName() {
      didMoveRewind(self, song: song)
    }
    if currentStatus == .Playing {
      play()
    }
  }
  
  /**
   Jump to the next track (Stop player if already last track). If player status was Playing, start new track
   */
  public func fastFoward() {
    let currentStatus: PlayerState = status
    if songQueue.setCurrentSong(.Next) {
      didMoveForward(self, song: songQueue.getCurrentSongName())
      prepareCurrentSong()
      if currentStatus == .Playing {
        play()
      }
    }
    else {
      didMoveForward(self, song: nil)
      didReachEndOfQueue(self)
      stop()
    }
  }
  
  /**
   Set current volume coefficient
   
   - parameter volume: the coefficient of current device's volume
   */
  public func setVolume(_ volume: Float) {
    if let player = player {
      player.volume = volume
      didChangeVolume(self, newVolume: volume)
    }
  }
}

extension AudioPlayer: AVAudioPlayerDelegate {
  
  public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    status = .Stoped
    if let song = songQueue.getCurrentSongName() {
      didFinishPlaying(self, song: song)
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
