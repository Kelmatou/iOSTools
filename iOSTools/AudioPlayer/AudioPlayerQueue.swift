//
//  AudioPlayerQueue.swift
//  iOSTools
//
//  Created by Antoine Clop on 10/31/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import Foundation

public class AudioQueue {
  
  // Ways to move currentSong index
  public enum IndexMove {
    case Prev
    case Next
  }
  
  // MARK: - Properties
  
  private(set) public var songQueue: [String] = []
  private(set) public var currentSong: Int = 0 {
    didSet {
      currentSongRemoved = false
    }
  }
  private var currentSongRemoved: Bool = false
  
  public var canLoop: Bool = false
  
  // MARK: - Song Selection
  
  /**
   Get current song's name
   
   - returns: the name of the song at currentSong index. Return nil if songQueue is empty. NOTE: If currentSong was removed, then name might not correspond!
   */
  public func getCurrentSongName() -> String? {
    guard !songQueue.isEmpty else {
      return nil
    }
    return songQueue[currentSong]
  }
  
  /**
   Get next song file path
   
   - returns: the path of the song, nil if file was not found
   */
  public func getNextSongURL() -> URL? {
    var nextSongURL: URL?
    let startIndex: Int = currentSong // Prevent infinite loop if canLoop option is enabled
    while (nextSongURL == nil) {
      let nextSongFile = songQueue[currentSong]
      if let path = Bundle.main.path(forResource: nextSongFile, ofType: nil) {
        nextSongURL = URL(fileURLWithPath: path)
      }
      else {
        debugPrint("[ERROR]: Cannot find file " + nextSongFile)
        if !setCurrentSong(.Next) || startIndex == currentSong {
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
      currentSong = currentSong == 0 ? loopAllowed && songQueue.count > 0 ? songQueue.count - 1 : 0 : currentSong - 1
    case .Next:
      if currentSongRemoved {
        // if current song was removed, then next song is at current index
        currentSongRemoved = false
      }
      else {
        currentSong = currentSong + 1 >= songQueue.count ? loopAllowed ? 0 : currentSong : currentSong + 1
      }
    }
    return startIndex != currentSong
  }
  
  /**
   Change currentSong index in queue
   
   - parameter index: the way index should move. If index is out of range, does nothing
   */
  public func setCurrentSong(at index: Int) {
    if index >= 0 && index < songQueue.count {
      currentSong = index
    }
  }
  
  /**
   Indicates if current song can be replay or has been deleted
   
   - returns: true if song is still in queue
   */
  public func canReplaySong() -> Bool {
    return !currentSongRemoved
  }
  
  // MARK: - Song Queue Manipulation
  
  /**
   Initialize queue with songs file's name
   
   - parameter songs: the list of songs file's name
   */
  public init(songs: [String] = []) {
    currentSong = 0
    self.songQueue = songs
  }
  
  /**
   Add a song to the queue
   
   - parameter song: the song to append to songQueue
   */
  public func append(_ song: String) {
    songQueue.append(song)
  }
  
  /**
   Add a songs to the queue
   
   - parameter songs: the songs to append to songQueue
   */
  public func append(_ songs: [String]) {
    for song in songs {
      songQueue.append(song)
    }
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
    if index < songQueue.count {
      songQueue.insert(song, at: index < 0 ? 0 : index)
    }
    else {
      songQueue.append(song)
    }
  }
  
  /**
   Remove all songs from queue
   */
  public func removeAll() {
    currentSong = 0
    currentSongRemoved = true
    songQueue.removeAll()
  }
  
  /**
   Remove song at a specified position. If no song are found at index, does nothing
   
   - parameter index: the index of song to remove
   */
  public func remove(at index: Int) {
    guard index >= 0 && index < songQueue.count else {
      return
    }
    currentSongRemoved = currentSongRemoved || currentSong == index
    if index < currentSong {
      currentSong -= 1
    }
    songQueue.remove(at: index)
  }
  
  /**
   Remove songs by name. Can also specify if it should remove first match only
   
   - parameter named: the name of songs to remove
   - parameter firstOnly: if true, will only remove first match
   */
  public func remove(named: String, firstOnly: Bool = false) {
    for (index, song) in songQueue.enumerated() {
      if song == named {
        remove(at: index)
        if firstOnly {
          break
        }
      }
    }
  }
  
  /**
   Move a song from a position to another
   
   - parameter src: the current index of the song
   - parameter dst: the destination index
   */
  public func moveSong(at src: Int, to dst: Int) {
    guard src >= 0 && src < songQueue.count && dst >= 0 && dst < songQueue.count else {
      return
    }
    insert(songQueue[src], at: dst)
    remove(at: src == dst ? src + 1 : src)
    currentSong = dst
  }
  
  /**
   Randomly shuffle queue songs
   */
  public func shuffle() {
    var newQueue: [String] = []
    for _ in 0 ..< songQueue.count {
      let randomIndex: Int = Int(arc4random_uniform(UInt32(songQueue.count)))
      let randomSong: String = songQueue[randomIndex]
      if randomIndex == currentSong {
        currentSong = newQueue.count
      }
      newQueue.append(randomSong)
      songQueue.remove(at: randomIndex)
    }
    songQueue = newQueue
  }
  
  /**
   Determines if currentSong is first in songQueue
   
   returns: true if currentSong is first in songQueue (must not be empty)
   */
  public func currentIsFirstSong() -> Bool {
    return !songQueue.isEmpty && currentSong == 0
  }
  
  /**
   Determines if currentSong is last in songQueue
   
   returns: true if currentSong is last in songQueue (must not be empty)
   */
  public func currentIsLastSong() -> Bool {
    return !songQueue.isEmpty && currentSong + 1 >= songQueue.count
  }
}
