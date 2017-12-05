//
//  AudioPlayerQueue.swift
//  iOSTools
//
//  Created by Antoine Clop on 10/31/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import Foundation

open class AudioQueue {
  
  // Ways to move currentSong index
  public enum IndexMove {
    case Prev
    case Next
  }
  
  // MARK: - Properties
  
  internal weak var delegate: AudioPlayerQueueDelegate?
  public var songs: [AudioSong] {
    var songs: [AudioSong] = []
    for song in internalSongs {
      if !song.removed {
        songs.append(song)
      }
    }
    return songs
  }
  public var internalSongs: [AudioSong] = []
  private(set) public var currentSong: Int = 0
  
  public var canLoop: Bool = false
  
  // MARK: - Song Selection
  
  /**
   Get current song's name
   
   - returns: the name of the song at currently selected to be played. Return nil if songQueue is empty.
   */
  public func getCurrentSongName() -> String? {
    guard !internalSongs.isEmpty else {
      return nil
    }
    return internalSongs[currentSong].name
  }
  
  /**
   Get current song's filename
   
   - returns: the file's name of the song at currently selected to be played. Return nil if songQueue is empty.
   */
  public func getCurrentSongFile() -> String? {
    guard !internalSongs.isEmpty else {
      return nil
    }
    return internalSongs[currentSong].filename
  }
  
  /**
   Get next song file path
   
   - returns: the path of the song, nil if file was not found
   */
  public func getCurrentSongURL() -> URL? {
    guard internalSongs.count > 0 else {
      return nil
    }
    var nextSongURL: URL?
    var attempsAvailable: Int = internalSongs.count // Prevent infinite loop if canLoop option is enabled
    while (nextSongURL == nil) {
      let nextSong = internalSongs[currentSong]
      if !nextSong.removed, let path = Bundle.main.path(forResource: nextSong.filename, ofType: nil) {
        nextSongURL = URL(fileURLWithPath: path)
      }
      else {
        attempsAvailable -= 1
        if !nextSong.removed {
          debugPrint("[ERROR]: Cannot find file " + nextSong.filename)
        }
        if !setCurrentSong(.Next) || attempsAvailable == 0 {
          return nil
        }
      }
    }
    return nextSongURL
  }
  
  /**
   Change currentSong index in queue
   
   - parameter move: the way index should move
   - parameter allowLoop: override canLoop for this call only. If nil, keep canLoop behavior
   
   - returns: true if index changed
   */
  @discardableResult public func setCurrentSong(_ move: IndexMove, allowLoop: Bool? = nil) -> Bool {
    let startIndex: Int = currentSong
    let loopAllowed: Bool = allowLoop == nil ? canLoop : allowLoop!
    switch move {
    case .Prev:
      currentSong = currentSong == 0 ? loopAllowed && internalSongs.count > 0 ? internalSongs.count - 1 : 0 : currentSong - 1
    case .Next:
      currentSong = currentSong + 1 >= internalSongs.count ? loopAllowed ? 0 : currentSong : currentSong + 1
    }
    let indexChanged: Bool = startIndex != currentSong
    if (indexChanged || internalSongs.count == 1) && internalSongs[startIndex].removed {
      internalSongs.remove(at: startIndex)
      if startIndex < currentSong {
        currentSong -= 1
      }
    }
    return indexChanged
  }
  
  /**
   Change currentSong index in queue
   
   - parameter index: the way index should move. If index is out of range, does nothing
   */
  public func setCurrentSong(at index: Int) {
    let currentSongIsRemoved: Bool = currentSong < internalSongs.count && internalSongs[currentSong].removed
    if index >= 0 && index < internalSongs.count - (currentSongIsRemoved ? 1 : 0) {
      if currentSongIsRemoved {
        internalSongs.remove(at: currentSong)
      }
      currentSong = index
    }
  }
  
  // MARK: - Song Queue Manipulation
  
  /**
   Initialize queue with songs file's name
   
   - parameter songs: the list of songs file's name
   */
  public init(songs: [String] = []) {
    currentSong = 0
    self.internalSongs = []
    for song in songs {
      self.internalSongs.append(AudioSong(song))
    }
    queueUpdate(self, queue: AudioSong.toStringArray(internalSongs))
  }
  
  /**
   Initialize queue with songs
   
   - parameter songs: the list of songs
   */
  public init(audioSongs: [AudioSong]) {
    currentSong = 0
    self.internalSongs = []
    for song in audioSongs {
      self.internalSongs.append(song)
    }
    queueUpdate(self, queue: AudioSong.toStringArray(internalSongs))
  }
  
  /**
   Add a song to the queue
   
   - parameter song: the song to append to songQueue
   */
  public func append(_ song: String) {
    internalSongs.append(AudioSong(song))
    queueUpdate(self, queue: AudioSong.toStringArray(internalSongs))
  }
  
  /**
   Add a song to the queue
   
   - parameter song: the song to append to songQueue
   */
  public func append(_ song: AudioSong) {
    internalSongs.append(song)
    queueUpdate(self, queue: AudioSong.toStringArray(internalSongs))
  }
  
  /**
   Add a songs to the queue
   
   - parameter songs: the songs to append to songQueue
   */
  public func append(_ songs: [String]) {
    for song in songs {
      internalSongs.append(AudioSong(song))
    }
    queueUpdate(self, queue: AudioSong.toStringArray(internalSongs))
  }
  
  /**
   Add a songs to the queue
   
   - parameter songs: the songs to append to songQueue
   */
  public func append(_ songs: [AudioSong]) {
    for song in songs {
      internalSongs.append(song)
    }
    queueUpdate(self, queue: AudioSong.toStringArray(internalSongs))
  }
  
  /**
   Add a song to the queue at a specified position
   
   - parameter song: the song to add into songQueue
   - parameter index: the position of sound. If lower than 0, index = 0, if greater than songQueue.count, has the same behavior as append(song:)
   */
  public func insert(_ song: String, at index: Int) {
    if index <= currentSong {
      currentSong += 1
    }
    if index < internalSongs.count {
      internalSongs.insert(AudioSong(song), at: index < 0 ? 0 : currentSong < index ? index + 1 : index)
    }
    else {
      internalSongs.append(AudioSong(song))
    }
    queueUpdate(self, queue: AudioSong.toStringArray(internalSongs))
  }
  
  /**
   Add a song to the queue at a specified position
   
   - parameter song: the song to add into songQueue
   - parameter index: the position of sound. If lower than 0, index = 0, if greater than songQueue.count, has the same behavior as append(song:)
   */
  public func insert(_ song: AudioSong, at index: Int) {
    if index <= currentSong {
      currentSong += 1
    }
    if index < internalSongs.count {
      internalSongs.insert(song, at: index < 0 ? 0 : currentSong < index ? index + 1 : index)
    }
    else {
      internalSongs.append(song)
    }
    queueUpdate(self, queue: AudioSong.toStringArray(internalSongs))
  }
  
  /**
   Remove all songs from queue
   */
  public func removeAll() {
    guard !isEmpty() else { return }
    let currentSongName: String = internalSongs[currentSong].name
    currentSong = 0
    internalSongs.removeAll()
    currentSongRemoved(self, song: currentSongName)
    queueUpdate(self, queue: AudioSong.toStringArray(internalSongs))
  }
  
  /**
   Remove song at a specified position. If no song are found at index, does nothing.
   
   - parameter index: the index of song to remove
   */
  public func remove(at index: Int) {
    let currentSongIsRemoved: Bool = currentSong < internalSongs.count && internalSongs[currentSong].removed
    let maxIndex: Int = internalSongs.count - (currentSongIsRemoved ? 1 : 0)
    guard index >= 0 && index < maxIndex else {
      return
    }
    if index == currentSong && !currentSongIsRemoved {
      let currentSongName: String = internalSongs[currentSong].name
      internalSongs[index].removed = true
      currentSongRemoved(self, song: currentSongName)
    }
    else {
      let removingIndex: Int = index + (currentSongIsRemoved ? 1 : 0)
      internalSongs.remove(at: removingIndex)
      if removingIndex < currentSong {
        currentSong -= 1
      }
    }
    queueUpdate(self, queue: AudioSong.toStringArray(internalSongs))
  }
  
  /**
   Remove songs by name. Can also specify if it should remove first match only
   
   - parameter named: the name of songs to remove
   - parameter firstOnly: if true, will only remove first match. Default is false
   */
  public func remove(named: String, firstOnly: Bool = false) {
    var songsRemoved: Int = 0
    for (index, song) in internalSongs.enumerated() {
      let indexAdjusted: Int = index - songsRemoved
      if song.name == named && !song.removed {
        remove(at: indexAdjusted)
        songsRemoved += 1
        if firstOnly {
          break
        }
      }
      else if song.removed {
        songsRemoved += 1
      }
    }
    queueUpdate(self, queue: AudioSong.toStringArray(internalSongs))
  }
  
  /**
   Move a song from a position to another. Even when moved, current song remains selected
   
   - parameter src: the current index of the song if out of range, does nothing
   - parameter dst: the destination index, if out of range, does nothing
   */
  public func moveSong(at src: Int, to dst: Int) {
    let currentSongIsRemoved: Bool = currentSong < internalSongs.count && internalSongs[currentSong].removed
    let maxIndex: Int = internalSongs.count - (currentSongIsRemoved ? 1 : 0)
    guard src >= 0 && src < maxIndex && dst >= 0 && dst < maxIndex else {
      return
    }
    let srcAdjusted: Int = currentSongIsRemoved && currentSong <= src ? src + 1 : src
    let dstAdjusted: Int = currentSongIsRemoved && currentSong <= dst ? dst + 1 : dst
    let songMoved: AudioSong = internalSongs[srcAdjusted]
    internalSongs.remove(at: srcAdjusted)
    internalSongs.insert(songMoved, at: dstAdjusted)
    if currentSong == srcAdjusted {
      currentSong = dstAdjusted
    }
    else if currentSong > srcAdjusted && dstAdjusted >= currentSong {
      currentSong -= 1
    }
    else if currentSong < srcAdjusted && dstAdjusted <= currentSong {
      currentSong += 1
    }
    queueUpdate(self, queue: AudioSong.toStringArray(internalSongs))
  }
  
  /**
   Randomly shuffle queue songs
   */
  public func shuffle() {
    var newQueue: [AudioSong] = []
    for _ in 0 ..< internalSongs.count {
      let randomIndex: Int = Int(arc4random_uniform(UInt32(internalSongs.count)))
      let randomSong: AudioSong = internalSongs[randomIndex]
      if randomIndex == currentSong {
        currentSong = newQueue.count
      }
      newQueue.append(randomSong)
      internalSongs.remove(at: randomIndex)
    }
    internalSongs = newQueue
    queueUpdate(self, queue: AudioSong.toStringArray(internalSongs))
  }
  
  /**
   Determines if currentSong is first in songQueue
   
   returns: true if currentSong is first in songQueue or queue is empty
   */
  public func currentIsFirstSong() -> Bool {
    return internalSongs.isEmpty || currentSong == 0
  }
  
  /**
   Determines if currentSong is last in songQueue
   
   returns: true if currentSong is last in songQueue or queue is empty
   */
  public func currentIsLastSong() -> Bool {
    return internalSongs.isEmpty || currentSong + 1 >= internalSongs.count
  }
  
  /**
   Determines if queue is empty or not
   
   returns: true if songQueue is empty
   */
  public func isEmpty() -> Bool {
    return internalSongs.isEmpty || (internalSongs.count == 1 && internalSongs[0].removed)
  }
}

