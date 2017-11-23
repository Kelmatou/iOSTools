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
  @IBOutlet weak var volumeSlider: UISlider!
  
  // MARK: - Property
  private(set) public var player: AudioPlayer = AudioPlayer()
  public weak var delegate: AudioPlayerDelegate?
  public var noSongTitle: String = "AudioPlayer"
  
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
  
  @IBAction func volumeSliding(_ sender: Any) {
    if let volumeSlider = sender as? UISlider {
      player.setVolume(volumeSlider.value)
    }
  }
}
