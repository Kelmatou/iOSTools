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
  
  // MARK: - Queue
  
  func testGetCurrentSong() {
    let queue: AudioQueue = AudioQueue()
    XCTAssert(queue.getCurrentSongName() == nil)
    queue.append("single.mp3")
    queue.append("tube.mp3")
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
  
  func testAppend() {
    let queue: AudioQueue = AudioQueue()
    queue.append(["single.mp3", "tube.mp3", "ending.mp3"])
    XCTAssert(queue.songQueue.count == 3 && queue.songQueue[0].name == "single.mp3")
    queue.append(["ending.mp3", "tube.mp3", "single.mp3"])
    XCTAssert(queue.songQueue.count == 6 && queue.songQueue[3].name == "ending.mp3")
  }
  
  func testInsert() {
    let queue: AudioQueue = AudioQueue()
    queue.insert("single.mp3", at: 42)
    XCTAssert(queue.songQueue.count == 1 && queue.songQueue[0].name == "single.mp3")
    queue.insert("tube.mp3", at: -1)
    XCTAssert(queue.songQueue.count == 2 && queue.songQueue[0].name == "tube.mp3")
    queue.insert("middle.mp3", at: 1)
    XCTAssert(queue.songQueue.count == 3 && queue.songQueue[1].name == "middle.mp3")
  }
  
  func testRemoveAll() {
    let queue: AudioQueue = AudioQueue()
    queue.removeAll()
    queue.append("single.mp3")
    queue.append("tube.mp3")
    queue.append("ending.mp3")
    XCTAssert(queue.songQueue.count == 3)
    queue.removeAll()
    XCTAssert(queue.songQueue.count == 0)
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
    XCTAssert(queue.songQueue.count == 4)
    queue.remove(at: 1)
    XCTAssert(queue.songQueue.count == 3 && queue.songQueue[0].name == "single.mp3" && queue.songQueue[1].name == "tube.mp3")
    queue.remove(at: 1)
    XCTAssert(queue.songQueue.count == 2 && queue.songQueue[0].name == "single.mp3" && queue.songQueue[1].name == "ending.mp3")
    queue.remove(at: 0)
    XCTAssert(queue.songQueue.count == 2 && queue.songQueue[0].removed)
    queue.remove(at: 0)
    XCTAssert(queue.songQueue.count == 1 && queue.songQueue[0].removed && queue.songQueue[0].name == "single.mp3")
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
    XCTAssert(queue.songQueue.count == 5 && queue.songQueue[1].name == "tube.mp3")
    queue.remove(named: "ending.mp3")
    XCTAssert(queue.songQueue.count == 3)
    queue.remove(named: "404NotFound.mp3")
    XCTAssert(queue.songQueue.count == 3)
    queue.remove(named: "single.mp3")
    XCTAssert(queue.songQueue.count == 2 && queue.songQueue[0].removed)
    queue.remove(named: "tube.mp3")
    XCTAssert(queue.songQueue.count == 1 && queue.songQueue[0].removed)
  }
  
  func testMove() {
    let queue: AudioQueue = AudioQueue()
    queue.moveSong(at: 0, to: 0)
    queue.append("single.mp3")
    queue.append("tube.mp3")
    queue.append("ending.mp3")
    queue.moveSong(at: 0, to: 0)
    XCTAssert(queue.songQueue.count == 3 && queue.songQueue[0].name == "single.mp3" && queue.songQueue[1].name == "tube.mp3" && queue.songQueue[2].name == "ending.mp3")
    queue.moveSong(at: 0, to: 1)
    XCTAssert(queue.songQueue.count == 3 && queue.songQueue[0].name == "tube.mp3" && queue.songQueue[1].name == "single.mp3" && queue.songQueue[2].name == "ending.mp3" && queue.currentSong == 1)
    queue.moveSong(at: 1, to: -1)
    XCTAssert(queue.songQueue.count == 3 && queue.songQueue[0].name == "tube.mp3" && queue.songQueue[1].name == "single.mp3" && queue.songQueue[2].name == "ending.mp3" && queue.currentSong == 1)
    queue.moveSong(at: -1, to: 0)
    XCTAssert(queue.songQueue.count == 3 && queue.songQueue[0].name == "tube.mp3" && queue.songQueue[1].name == "single.mp3" && queue.songQueue[2].name == "ending.mp3" && queue.currentSong == 1)
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
