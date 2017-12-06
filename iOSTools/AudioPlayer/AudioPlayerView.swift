//
//  AudioPlayerView.swift
//  iOSTools
//
//  Created by Antoine Clop on 11/6/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import UIKit

public class AudioPlayerView: UIView {
  
  // MARK: IBOutlet
  
  @IBOutlet var audioPlayerView: UIView!
  @IBOutlet weak var playingNow: UILabel!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var stopButton: UIButton!
  @IBOutlet weak var replayButton: UIButton!
  @IBOutlet weak var rewindButton: UIButton!
  @IBOutlet weak var forwardButton: UIButton!
  @IBOutlet weak var speakerButton: UIButton!
  @IBOutlet weak var progressBar: UIProgressView!
  
  // MARK: - Property
  
  private(set) public var player: AudioPlayer = AudioPlayer()
  public weak var delegate: AudioPlayerDelegate?
  public var noSongTitle: String = "AudioPlayer"
  
  private var muted: Bool = false
  private var timerRunning: Bool = false
  internal let timer: DispatchSourceTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
  
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
    player.delegate = self
    if let frameworkBundle: Bundle = Bundle(identifier: "com.clop-a.iOSTools") {
      frameworkBundle.loadNibNamed("AudioPlayerView", owner: self, options: nil)
      addSubview(audioPlayerView)
      audioPlayerView.frame = self.bounds
      audioPlayerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
      setupProgressBar()
      setupUpdater()
    }
  }
  
  // MARK: - Setup
  
  internal func setupProgressBar() {
    progressBar.transform = CGAffineTransform(scaleX: 1, y: 4)
    progressBar.setProgress(0, animated: false)
  }
  
  func setupUpdater() {
    timer.schedule(deadline: .now(), repeating: .milliseconds(100))
    timer.setEventHandler {
      if let player = self.player.player {
        let percentageProgression: Float = Float(player.currentTime / player.duration)
        self.progressBar.setProgress(percentageProgression, animated: true)
      }
    }
  }
  
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
  
  /**
   Update icon of speaker button
   */
  internal func speakerButtonUpdate() {
    let imageToUse: String = muted ? "mute" : "speaker"
    let image: UIImage? = UIImage(named: imageToUse, in: Bundle(for: AudioPlayer.self), compatibleWith: nil)
    DispatchQueue.main.async {
      self.speakerButton.setImage(image, for: .normal)
    }
  }
  
  /**
   Update timer status
   
   - parameter running: if true, resume timer, if false suspend it
   */
  internal func timerUpdate(running: Bool) {
    guard running != timerRunning else {
      return
    }
    timerRunning = running
    if timerRunning {
      timer.resume()
    }
    else {
      timer.suspend()
    }
  }
  
  // MARK: - IBAction
  
  @IBAction func replaySong(_ sender: Any) {
    player.replay()
  }
  
  @IBAction func playSong(_ sender: Any) {
    if player.status == .Playing {
      player.pause()
    }
    else {
      player.play()
    }
  }
  
  @IBAction func stopSong(_ sender: Any) {
    player.stop()
  }
  
  @IBAction func fastRewindSong(_ sender: Any) {
    player.fastRewind()
  }
  
  @IBAction func fastForwardSong(_ sender: Any) {
    player.fastFoward()
  }
  
  @IBAction func muteSong(_ sender: Any) {
    muted = !muted
    speakerButtonUpdate()
    player.setVolume(muted ? 0 : 1)
  }
}
