//
//  AudioPlayer.swift
//  iOSToolsTests
//
//  Created by Antoine Clop on 11/23/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import XCTest
@testable import iOSTools

class AudioPlayerTest: XCTestCase {
  
  // MARK: - Test setup
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  let audioSongs: [AudioSong] = [AudioSong("1.mp3"), AudioSong("2.mp3"), AudioSong("3.mp3"), AudioSong("4.mp3")]
  
  // MARK: - Queue
  
  func testAccessQueue() {
    let queue: AudioQueue = AudioQueue()
    XCTAssert(queue.songs.count == 0)
    queue.append("single.mp3")
    queue.append("tube.mp3")
    queue.append("ending.mp3")
    XCTAssert(queue.songs.count == 3)
    XCTAssert(queue.songs.first!.name == "single.mp3")
    XCTAssert(queue.songs[0].name == "single.mp3")
    XCTAssert(queue.songs[1].name == "tube.mp3")
    XCTAssert(queue.songs[2].name == "ending.mp3")
  }
  
  func testGetCurrentSong() {
    let queue: AudioQueue = AudioQueue()
    XCTAssert(queue.getCurrentSongName() == nil)
    queue.append("single.mp3")
    queue.append("tube.mp3")
    XCTAssert(queue.getCurrentSongName() == "single.mp3")
    queue.setCurrentSong(.Next)
    XCTAssert(queue.getCurrentSongName() == "tube.mp3")
  }
  
  func testGetCurrentSongRemove() {
    let queue: AudioQueue = AudioQueue()
    queue.append("single.mp3")
    queue.append("tube.mp3")
    queue.remove(at: 0)
    XCTAssert(queue.getCurrentSongName() == "single.mp3")
    queue.setCurrentSong(.Next)
    XCTAssert(queue.getCurrentSongName() == "tube.mp3")
  }
  
  func testSetCurrentSong() {
    let queue: AudioQueue = AudioQueue()
    XCTAssert(!queue.setCurrentSong(.Next))
    XCTAssert(!queue.setCurrentSong(.Prev))
    queue.setCurrentSong(at: 0)
    queue.setCurrentSong(at: 1)
    queue.append("single.mp3")
    queue.append("tube.mp3")
    queue.append("ending.mp3")
    XCTAssert(!queue.setCurrentSong(.Prev) && queue.currentSong == 0)
    XCTAssert(queue.setCurrentSong(.Next) && queue.currentSong == 1)
    XCTAssert(queue.setCurrentSong(.Next) && queue.currentSong == 2)
    XCTAssert(!queue.setCurrentSong(.Next) && queue.currentSong == 2)
    XCTAssert(queue.setCurrentSong(.Next, allowLoop: true) && queue.currentSong == 0)
    XCTAssert(queue.setCurrentSong(.Prev, allowLoop: true) && queue.currentSong == 2)
    queue.setCurrentSong(at: 1)
    XCTAssert(queue.currentSong == 1)
    queue.setCurrentSong(at: -1)
    XCTAssert(queue.currentSong == 1)
    queue.setCurrentSong(at: 3)
    XCTAssert(queue.currentSong == 1)
  }
  
  func testSetCurrentSongRemove() {
    let queue: AudioQueue = AudioQueue()
    queue.append("single.mp3")
    queue.append("tube.mp3")
    queue.append("ending.mp3")
    queue.remove(at: 0)
    XCTAssert(!queue.setCurrentSong(.Prev) && queue.currentSong == 0)
    XCTAssert(queue.setCurrentSong(.Next) && queue.currentSong == 0)
    XCTAssert(queue.setCurrentSong(.Next) && queue.currentSong == 1)
    XCTAssert(!queue.setCurrentSong(.Next) && queue.currentSong == 1)
    XCTAssert(queue.setCurrentSong(.Next, allowLoop: true) && queue.currentSong == 0)
    XCTAssert(queue.setCurrentSong(.Prev, allowLoop: true) && queue.currentSong == 1)
    queue.insert("single.mp3", at: 0)
    XCTAssert(queue.currentSong == 2)
    queue.setCurrentSong(at: -1)
    XCTAssert(queue.currentSong == 2)
    queue.setCurrentSong(at: 3)
    XCTAssert(queue.currentSong == 2)
    queue.remove(at: 2)
    XCTAssert(queue.currentSong == 2 && queue.internalSongs.count == 3)
    XCTAssert(queue.setCurrentSong(.Prev) && queue.currentSong == 1 && queue.internalSongs.count == 2)
    queue.remove(at: 1)
    XCTAssert(queue.currentSong == 1 && queue.internalSongs.count == 2)
    XCTAssert(queue.setCurrentSong(.Prev) && queue.currentSong == 0 && queue.internalSongs.count == 1)
    queue.remove(at: 0)
    XCTAssert(!queue.setCurrentSong(.Prev) && queue.currentSong == 0 && queue.internalSongs.count == 0)
  }
  
  func testAppend() {
    let queue: AudioQueue = AudioQueue()
    queue.append(["single.mp3", "tube.mp3", "ending.mp3"])
    XCTAssert(queue.songs.count == 3 && queue.songs[0].name == "single.mp3")
    queue.append(["ending.mp3", "tube.mp3", "single.mp3"])
    XCTAssert(queue.songs.count == 6 && queue.songs[3].name == "ending.mp3")
  }
  
  func testAppendAudioSong() {
    let queue: AudioQueue = AudioQueue()
    queue.append(audioSongs)
    XCTAssert(queue.songs.count == 4 && queue.songs[0].name == "1.mp3" && queue.songs[3].name == "4.mp3")
    queue.append(audioSongs.reversed())
    XCTAssert(queue.songs.count == 8 && queue.songs[4].name == "4.mp3" && queue.songs[7].name == "1.mp3")
  }
  
  func testAppendRemove() {
    let queue: AudioQueue = AudioQueue()
    queue.append("single.mp3")
    XCTAssert(queue.songs.count == 1 && queue.songs[0].name == "single.mp3")
    queue.remove(at: 0)
    XCTAssert(queue.songs.count == 0 && queue.internalSongs.count == 1 && queue.internalSongs[0].removed)
    queue.append(["ending.mp3", "tube.mp3", "single.mp3"])
    XCTAssert(queue.songs.count == 3 && queue.songs[2].name == "single.mp3")
    queue.removeAll()
    XCTAssert(queue.songs.count == 0 && queue.internalSongs.count == 0)
    queue.append("ending.mp3")
    XCTAssert(queue.songs.count == 1 && queue.songs[0].name == "ending.mp3")
  }
  
  func testAppendAudioSongsRemove() {
    let queue: AudioQueue = AudioQueue()
    queue.append(audioSongs[0])
    XCTAssert(queue.songs.count == 1 && queue.songs[0].name == "1.mp3")
    queue.remove(at: 0)
    XCTAssert(queue.songs.count == 0 && queue.internalSongs.count == 1 && queue.internalSongs[0].removed && audioSongs.count == 4)
    queue.append(audioSongs)
    XCTAssert(queue.songs.count == 4 && queue.songs[3].name == "4.mp3")
    queue.removeAll()
    XCTAssert(queue.songs.count == 0 && queue.internalSongs.count == 0 && audioSongs.count == 4)
    queue.append(audioSongs[1])
    XCTAssert(queue.songs.count == 1 && queue.songs[0].name == "2.mp3")
  }
  
  func testInsert() {
    let queue: AudioQueue = AudioQueue()
    queue.insert("single.mp3", at: 42)
    XCTAssert(queue.songs.count == 1 && queue.songs[0].name == "single.mp3")
    queue.insert("tube.mp3", at: -1)
    XCTAssert(queue.songs.count == 2 && queue.songs[0].name == "tube.mp3")
    queue.insert("middle.mp3", at: 1)
    XCTAssert(queue.songs.count == 3 && queue.songs[1].name == "middle.mp3")
  }
  
  func testInsertRemove() {
    let queue: AudioQueue = AudioQueue()
    queue.insert("single.mp3", at: 42)
    XCTAssert(queue.songs.count == 1 && queue.songs[0].name == "single.mp3")
    queue.insert("tube.mp3", at: -1)
    XCTAssert(queue.songs.count == 2 && queue.songs[0].name == "tube.mp3")
    queue.insert("middle.mp3", at: 1)
    XCTAssert(queue.songs.count == 3 && queue.songs[1].name == "middle.mp3")
    queue.setCurrentSong(at: 1)
    queue.remove(at: 1)
    queue.insert("open.mp3", at: 0)
    XCTAssert(queue.internalSongs.count == 4 && queue.internalSongs[0].name == "open.mp3" && queue.internalSongs[1].name == "tube.mp3" && queue.internalSongs[2].name == "middle.mp3")
    XCTAssert(queue.songs.count == 3 && queue.songs[0].name == "open.mp3" && queue.songs[1].name == "tube.mp3" && queue.songs[2].name == "single.mp3")
    queue.insert("hit.mp3", at: 2)
    XCTAssert(queue.internalSongs.count == 5 && queue.internalSongs[1].name == "tube.mp3" && queue.internalSongs[2].name == "hit.mp3" && queue.internalSongs[3].name == "middle.mp3")
    XCTAssert(queue.songs.count == 4 && queue.songs[1].name == "tube.mp3" && queue.songs[2].name == "hit.mp3" && queue.songs[3].name == "single.mp3")
  }
  
  func testRemoveAll() {
    let queue: AudioQueue = AudioQueue()
    queue.removeAll()
    queue.append("single.mp3")
    queue.append("tube.mp3")
    queue.append("ending.mp3")
    XCTAssert(queue.songs.count == 3)
    queue.removeAll()
    XCTAssert(queue.internalSongs.count == 0)
    XCTAssert(queue.songs.count == 0)
  }
  
  func testRemoveAt() {
    let queue: AudioQueue = AudioQueue()
    queue.remove(at: 0)
    queue.append("single.mp3")
    queue.append("single2.mp3")
    queue.append("tube.mp3")
    queue.append("ending.mp3")
    queue.remove(at: 42)
    queue.remove(at: -1)
    XCTAssert(queue.songs.count == 4)
    queue.remove(at: 1)
    XCTAssert(queue.songs.count == 3 && queue.songs[0].name == "single.mp3" && queue.songs[1].name == "tube.mp3")
    queue.remove(at: 1)
    XCTAssert(queue.songs.count == 2 && queue.songs[0].name == "single.mp3" && queue.songs[1].name == "ending.mp3")
    queue.remove(at: 0)
    XCTAssert(queue.internalSongs.count == 2 && queue.internalSongs[0].removed)
    XCTAssert(queue.songs.count == 1 && queue.songs[0].name == "ending.mp3")
    queue.remove(at: 0)
    XCTAssert(queue.internalSongs.count == 1 && queue.internalSongs[0].removed && queue.internalSongs[0].name == "single.mp3")
    XCTAssert(queue.songs.count == 0)
  }
  
  func testRemoveName() {
    let queue: AudioQueue = AudioQueue()
    queue.remove(named: "single.mp3")
    queue.append("single.mp3")
    queue.append("ending.mp3")
    queue.append("tube.mp3")
    queue.append("single.mp3")
    queue.append("ending.mp3")
    queue.append("ending.mp3")
    queue.remove(named: "ending.mp3", firstOnly: true)
    XCTAssert(queue.songs.count == 5 && queue.songs[1].name == "tube.mp3")
    queue.remove(named: "ending.mp3")
    XCTAssert(queue.songs.count == 3)
    queue.remove(named: "404NotFound.mp3")
    XCTAssert(queue.songs.count == 3)
    queue.remove(named: "single.mp3")
    XCTAssert(queue.internalSongs.count == 2 && queue.internalSongs[0].removed)
    XCTAssert(queue.songs.count == 1 && queue.songs[0].name == "tube.mp3")
    queue.remove(named: "tube.mp3")
    XCTAssert(queue.internalSongs.count == 1 && queue.internalSongs[0].removed)
    XCTAssert(queue.songs.count == 0)
  }
  
  func testMove() {
    let queue: AudioQueue = AudioQueue()
    queue.moveSong(at: 0, to: 0)
    queue.append("single.mp3")
    queue.append("tube.mp3")
    queue.append("ending.mp3")
    queue.moveSong(at: 0, to: 0)
    XCTAssert(queue.songs.count == 3 && queue.songs[0].name == "single.mp3" && queue.songs[1].name == "tube.mp3" && queue.songs[2].name == "ending.mp3")
    queue.moveSong(at: 0, to: 1)
    XCTAssert(queue.songs.count == 3 && queue.songs[0].name == "tube.mp3" && queue.songs[1].name == "single.mp3" && queue.songs[2].name == "ending.mp3" && queue.currentSong == 1)
    queue.moveSong(at: 1, to: -1)
    XCTAssert(queue.songs.count == 3 && queue.songs[0].name == "tube.mp3" && queue.songs[1].name == "single.mp3" && queue.songs[2].name == "ending.mp3" && queue.currentSong == 1)
    queue.moveSong(at: -1, to: 0)
    XCTAssert(queue.songs.count == 3 && queue.songs[0].name == "tube.mp3" && queue.songs[1].name == "single.mp3" && queue.songs[2].name == "ending.mp3" && queue.currentSong == 1)
  }
  
  func testMoveRemove() {
    let queue: AudioQueue = AudioQueue()
    queue.append("single.mp3")
    queue.append("hit.mp3")
    queue.append("tube.mp3")
    queue.append("ending.mp3")
    queue.setCurrentSong(at: 1)
    queue.remove(at: 1)
    queue.moveSong(at: 0, to: 0)
    XCTAssert(queue.internalSongs.count == 4 && queue.internalSongs[0].name == "single.mp3" && queue.internalSongs[1].name == "hit.mp3" && queue.internalSongs[2].name == "tube.mp3")
    XCTAssert(queue.songs.count == 3 && queue.songs[0].name == "single.mp3" && queue.songs[1].name == "tube.mp3" && queue.songs[2].name == "ending.mp3")
    queue.moveSong(at: 0, to: 1)
    XCTAssert(queue.internalSongs.count == 4 && queue.internalSongs[0].name == "hit.mp3" && queue.internalSongs[1].name == "tube.mp3" && queue.internalSongs[2].name == "single.mp3")
    XCTAssert(queue.songs.count == 3 && queue.songs[0].name == "tube.mp3" && queue.songs[1].name == "single.mp3" && queue.songs[2].name == "ending.mp3" && queue.currentSong == 0)
    queue.moveSong(at: 1, to: 0)
    XCTAssert(queue.internalSongs.count == 4 && queue.internalSongs[0].name == "hit.mp3" && queue.internalSongs[1].name == "single.mp3" && queue.internalSongs[2].name == "tube.mp3")
    XCTAssert(queue.songs.count == 3 && queue.songs[0].name == "single.mp3" && queue.songs[1].name == "tube.mp3" && queue.songs[2].name == "ending.mp3")
    queue.moveSong(at: 1, to: 2)
    XCTAssert(queue.internalSongs.count == 4 && queue.internalSongs[0].name == "hit.mp3" && queue.internalSongs[2].name == "ending.mp3" && queue.internalSongs[3].name == "tube.mp3")
    XCTAssert(queue.songs.count == 3 && queue.songs[0].name == "single.mp3" && queue.songs[1].name == "ending.mp3" && queue.songs[2].name == "tube.mp3")
  }
  
  func testFirstLastEmptySong() {
    let queue: AudioQueue = AudioQueue()
    XCTAssert(queue.isEmpty())
    queue.append("single.mp3")
    XCTAssert(!queue.isEmpty())
    XCTAssert(queue.currentIsFirstSong() && queue.currentIsLastSong())
    queue.append("tube.mp3")
    queue.append("ending.mp3")
    XCTAssert(queue.currentIsFirstSong() && !queue.currentIsLastSong())
    queue.setCurrentSong(.Next)
    XCTAssert(!queue.currentIsFirstSong() && !queue.currentIsLastSong())
    queue.setCurrentSong(.Next)
    XCTAssert(!queue.currentIsFirstSong() && queue.currentIsLastSong())
    XCTAssert(!queue.isEmpty())
  }
}
