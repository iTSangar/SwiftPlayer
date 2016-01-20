//
//  SwiftPlayer.swift
//  Pods
//
//  Created by iTSangar on 1/14/16.
//
//

import Foundation
import MediaPlayer

// MARK: - SwiftPlayer Protocol
protocol SwiftPlayerDelegate: class {
  func playerDurationTime(time: Float)
  func playerCurrentTimeChanged(time: Float)
  func playerRateChanged(isPlaying: Bool)
  func playerCurrentTrackChanged(track: TrackProtocol?)
}

extension SwiftPlayerDelegate {
  func playerDurationTime(time: Float) {}
  func playerCurrentTimeChanged(time: Float) {}
  func playerRateChanged(isPlaying: Bool) {}
  func playerCurrentTrackChanged(track: TrackProtocol?) {}
}


// MARK: - SwiftPlayer Struct
/// Struct to access player actions 🎵
public struct SwiftPlayer {
  
  /// Set delegate
  static func delegate(delegate: SwiftPlayerDelegate) {
    HysteriaManager.sharedInstance.delegate = delegate
  }
  
  /// ▶️ Play music
  static func play() {
    HysteriaManager.sharedInstance.play()
  }
  
  /// ▶️🔢 Play music by specified index
  static func playAtIndex(index: Int) {
    HysteriaManager.sharedInstance.playAtIndex(index)
  }
  
  /// ▶️0️⃣ Play all tracks starting by 0
  static func playAll() {
    HysteriaManager.sharedInstance.playAllTracks()
  }
  
  /// ⏸ Pause music if music is playing
  static func pause() {
    HysteriaManager.sharedInstance.pause()
  }
  
  /// ⏩ Play next music
  static func next() {
    HysteriaManager.sharedInstance.next()
  }
  
  /// ⏪ Play previous music
  static func previous() {
    HysteriaManager.sharedInstance.previous()
  }
  
  /// Return true if sound is playing
  static func isPlaying() -> Bool {
    return HysteriaManager.sharedInstance.hysteriaPlayer.isPlaying()
  }
  
  /// 🔀 Enable the player shuffle
  static func enableShufle() {
    HysteriaManager.sharedInstance.enableShuffle()
  }
  
  /// Disable player shuffle
  static func disableShuffle() {
    HysteriaManager.sharedInstance.disableShuffle()
  }
  
  /// Return true if 🔀 shuffle is enable
  static func isShuffle() -> Bool {
    return HysteriaManager.sharedInstance.shuffleStatus()
  }
  
  /// 🔁 Enable repeat mode on music list
  static func enableRepeat() {
    HysteriaManager.sharedInstance.enableRepeat()
  }
  
  /// 🔂 Enable repeat mode only in actual music
  static func enableRepeatOne() {
    HysteriaManager.sharedInstance.enableRepeatOne()
  }
  
  /// Disable repeat mode
  static func disableRepeat() {
    HysteriaManager.sharedInstance.disableRepeat()
  }
  
  /// Return true if 🔁 repeat or 🔂 repeatOne is enable
  static func isRepeat() -> Bool {
    let (_, _, Off) = HysteriaManager.sharedInstance.repeatStatus()
    return !Off
  }
  
  /// Return true if 🔂 repeatOne is enable
  static func isRepeatOne() -> Bool {
    let (_, One, _) = HysteriaManager.sharedInstance.repeatStatus()
    return One
  }
  
  /// 🔘 Set new seek value from UISlider
  static func seekToWithSlider(slider: UISlider) {
    HysteriaManager.sharedInstance.seekTo(slider)
  }
  
  /// Get duration time of track
  static func trackDurationTime() -> Float {
    return HysteriaManager.sharedInstance.playingItemDurationTime()
  }
  
  /// Set new playlist in player
  static func newPlaylist(playlist: PlaylistProtocol) -> SwiftPlayer.Type {
    HysteriaManager.sharedInstance.setPlaylist(playlist)
    return self
  }
  
}
