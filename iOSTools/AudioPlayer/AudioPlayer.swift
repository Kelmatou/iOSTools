//
//  AudioPlayer.swift
//  iOSTools
//
//  Created by Antoine Clop on 10/31/17.
//  Copyright © 2017 clop_a. All rights reserved.
//


import UIKit
import AVFoundation

@IBDesignable open class AudioPlayer: UIView {
  
  @IBOutlet var audioPlayerView: UIView!
  
  // MARK: - IBOutlet
  @IBOutlet weak var playingNow: UILabel!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var stopButton: UIButton!
  @IBOutlet weak var replayButton: UIButton!
  @IBOutlet weak var rewindButton: UIButton!
  @IBOutlet weak var forwardButton: UIButton!
  @IBOutlet weak var volumeSlider: UISlider!
  
  // MARK: - Variables
  internal var player: AVAudioPlayer?
  
  public weak var delegate: AudioPlayerDelegate?
  public var songQueue: AudioQueue = AudioQueue()
  private var canReplaySong: Bool = true
  
  @IBInspectable public var autoPlay: Bool = true
  
  // MARK: - UIView
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    initView()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    initView()
  }
  
  private func initView() {
    songQueue.delegate = self
    if let frameworkBundle: Bundle = Bundle(identifier: "com.clop-a.iOSTools") {
      frameworkBundle.loadNibNamed("AudioPlayer", owner: self, options: nil)
      addSubview(audioPlayerView)
      audioPlayerView.frame = self.bounds
      audioPlayerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
  }
  
  // MARK: - IBAction
  
  @IBAction func replaySong(_ sender: Any) {
    guard !songQueue.songQueue.isEmpty && canReplaySong else {
      debugPrint("[ERROR]: Cannot replay song")
      return
    }
    play(starting: true)
    didReplay(self, song: songQueue.getCurrentSongName() ?? "No track")
  }
  
  @IBAction func playSong(_ sender: Any) {
    if let player = player, player.isPlaying {
      player.pause()
      playButtonUpdate(playing: false)
      didPause(self, song: songQueue.getCurrentSongName() ?? "No track")
    }
    else {
      play()
    }
  }
  
  @IBAction func stopSong(_ sender: Any) {
    if let player = player {
      player.stop()
    }
    songQueue.setCurrentSong(at: 0)
    player = nil
    playingNow.text = "AudioPlayer"
    playButtonUpdate(playing: false)
    didStop(self)
  }
  
  @IBAction func fastRewindSong(_ sender: Any) {
    songQueue.setCurrentSong(.Prev)
    play(starting: true)
    didMoveRewind(self, song: songQueue.getCurrentSongName() ?? "No track")
  }
  
  @IBAction func fastForwardSong(_ sender: Any) {
    if songQueue.setCurrentSong(.Next) {
      didMoveForward(self, song: songQueue.getCurrentSongName() ?? "No track")
      play(starting: true)
    }
    else {
      didMoveForward(self, song: nil)
      didReachEndOfQueue(self)
      stopSong(sender)
    }
  }
  
  @IBAction func volumeSliding(_ sender: Any) {
    if let volumeSlider = sender as? UISlider {
      if let player = player {
        player.volume = volumeSlider.value
      }
      didChangeVolume(self, newVolume: volumeSlider.value)
    }
  }

  // MARK: - Init Player
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
  
  // MARK: - Songs

  /**
   Play song at currentSong index in songQueue
   
   - parameter starting: if true, start song from the begining, if false resume playing song
   */
  internal func play(starting: Bool = false) {
    if let nextSongURL = songQueue.getCurrentSongURL() {
      if player == nil || starting {
        initPlayer(withContent: nextSongURL)
      }
      willStartPlaying(self, song: songQueue.getCurrentSongName() ?? "No track")
      player?.play()
      playButtonUpdate(playing: true)
      playingNow.text = songQueue.getCurrentSongName()
      canReplaySong = true
    }
    else {
      debugPrint("[WARNING]: No song to be played")
    }
  }
  
  // MARK: - UIView
  /**
   Update icon of play button
   
   - parameter playing: if true, set pause icone else play icone
   */
  internal func playButtonUpdate(playing: Bool) {
    let imageToUse: String = playing ? "pause" : "play"
    let image: UIImage? = UIImage(named: imageToUse, in: Bundle(for: AudioPlayer.self), compatibleWith: nil)
    DispatchQueue.main.async {
      self.playButton.setImage(image, for: .normal)
    }
  }
}

extension AudioPlayer: AVAudioPlayerDelegate {
  
  public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    didFinishPlaying(self, song: songQueue.getCurrentSongName() ?? "No track")
    if songQueue.currentIsLastSong() {
      didReachEndOfQueue(self)
    }
    if !autoPlay || songQueue.currentIsLastSong() {
      songQueue.setCurrentSong(.Next, allowLoop: true)
      self.player = nil
      playingNow.text = "AudioPlayer"
      playButtonUpdate(playing: false)
    }
    else {
      songQueue.setCurrentSong(.Next)
      play(starting: true)
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
