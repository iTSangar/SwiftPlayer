//
//  SwiftPlayer.swift
//  Pods
//
//  Created by iTSangar on 1/14/16.
//
//

import Foundation
import MediaPlayer

// MARK: - SwiftPlayer Delegate -
public protocol SwiftPlayerDelegate: class {
  func playerDurationTime(time: Float)
  func playerCurrentTimeChanged(time: Float)
  func playerRateChanged(isPlaying: Bool)
  func playerCurrentTrackChanged(track: PlayerTrack?)
}

extension SwiftPlayerDelegate {
  func playerDurationTime(time: Float) {}
  func playerCurrentTimeChanged(time: Float) {}
  func playerRateChanged(isPlaying: Bool) {}
  func playerCurrentTrackChanged(track: PlayerTrack?) {}
}

// MARK: - SwiftPlayer Queue Delegate -
public protocol SwiftPlayerQueueDelegate: class {
  func queueUpdated()
}

extension SwiftPlayerQueueDelegate {
  func queueUpdated() {}
}


// MARK: - SwiftPlayer Struct -
/// Struct to access player actions 🎵
public struct SwiftPlayer {
  
  /// Set logs
  public static func logs(active: Bool) {
    HysteriaManager.sharedInstance.logs = active
  }
  
  /// Set delegate
  public static func delegate(delegate: SwiftPlayerDelegate) {
    HysteriaManager.sharedInstance.delegate = delegate
  }
  
  /// Set ViewController
  public static func controller(controller: UIViewController?) {
    HysteriaManager.sharedInstance.controller = controller
  }
  
  // Get ViewController
  public static func playerController() -> UIViewController? {
    return HysteriaManager.sharedInstance.controller
  }
  
  /// ▶️ Play music
  public static func play() {
    HysteriaManager.sharedInstance.play()
  }
  
  /// ▶️🔢 Play music by specified index
  public static func playAtIndex(index: Int) {
    HysteriaManager.sharedInstance.playAtIndex(index)
  }
  
  /// ▶️0️⃣ Play all tracks starting by 0
  public static func playAll() {
    HysteriaManager.sharedInstance.playAllTracks()
  }
  
  /// ⏸ Pause music if music is playing
  public static func pause() {
    HysteriaManager.sharedInstance.pause()
  }
  
  /// ⏩ Play next music
  public static func next() {
    HysteriaManager.sharedInstance.next()
  }
  
  /// ⏪ Play previous music
  public static func previous() {
    HysteriaManager.sharedInstance.previous()
  }
  
  /// Return true if sound is playing
  public static func isPlaying() -> Bool {
    return HysteriaManager.sharedInstance.hysteriaPlayer.isPlaying()
  }
  
  /// 🔀 Enable the player shuffle
  public static func enableShufle() {
    HysteriaManager.sharedInstance.enableShuffle()
  }
  
  /// Disable player shuffle
  public static func disableShuffle() {
    HysteriaManager.sharedInstance.disableShuffle()
  }
  
  /// Return true if 🔀 shuffle is enable
  public static func isShuffle() -> Bool {
    return HysteriaManager.sharedInstance.shuffleStatus()
  }
  
  /// 🔁 Enable repeat mode on music list
  public static func enableRepeat() {
    HysteriaManager.sharedInstance.enableRepeat()
  }
  
  /// 🔂 Enable repeat mode only in actual music
  public static func enableRepeatOne() {
    HysteriaManager.sharedInstance.enableRepeatOne()
  }
  
  /// Disable repeat mode
  public static func disableRepeat() {
    HysteriaManager.sharedInstance.disableRepeat()
  }
  
  /// Return true if 🔁 repeat or 🔂 repeatOne is enable
  public static func isRepeat() -> Bool {
    let (_, _, Off) = HysteriaManager.sharedInstance.repeatStatus()
    return !Off
  }
  
  /// Return true if 🔂 repeatOne is enable
  public static func isRepeatOne() -> Bool {
    let (_, One, _) = HysteriaManager.sharedInstance.repeatStatus()
    return One
  }
  
  /// 🔘 Set new seek value from UISlider
  public static func seekToWithSlider(slider: UISlider) {
    HysteriaManager.sharedInstance.seekTo(slider)
  }
  
  /// Get duration time of track
  public static func trackDurationTime() -> Float {
    return HysteriaManager.sharedInstance.playingItemDurationTime()
  }
  
  /// 🔊 Player volume view
  public static func volumeViewFrom(view: UIView) -> MPVolumeView {
    return HysteriaManager.sharedInstance.volumeViewFrom(view)
  }
  
  // MARK: QUEUE
 
  /// Set new playlist in player
  public static func newPlaylist(playlist: [PlayerTrack]) -> SwiftPlayer.Type {
    HysteriaManager.sharedInstance.setPlaylist(playlist)
    return self
  }
  
  /// Set queue delegate
  public static func queueDelegate(delegate: SwiftPlayerQueueDelegate) {
    HysteriaManager.sharedInstance.queueDelegate = delegate
  }
  
  /// Add new track in next queue
  public static func addNextTrack(track: PlayerTrack) {
    HysteriaManager.sharedInstance.addPlayNext(track)
  }
  
  /// Total tracks in playlists
  public static func totalTracks() -> Int {
    return HysteriaManager.sharedInstance.queue.totalTracks()
  }
  
  /// Tracks in main queue
  public static func mainTracks() -> [PlayerTrack] {
    return HysteriaManager.sharedInstance.queue.mainQueue
  }
  
  /// Tracks without playing track in next queue
  public static func nextTracks() -> [PlayerTrack] {
    if let index = SwiftPlayer.currentTrackIndex() {
      if SwiftPlayer.trackAtIndex(index).origin == TrackType.Next {
        var pop = HysteriaManager.sharedInstance.queue.nextQueue
        pop.removeAtIndex(0)
        return pop
      }
    }
    
    
    return HysteriaManager.sharedInstance.queue.nextQueue
  }
  
  /// All tracks by index 
  public static func trackAtIndex(index: Int) -> PlayerTrack {
    return HysteriaManager.sharedInstance.queue.trackAtIndex(index)
  }
  
  /// Current AVPlayerItem
  public static func currentItem() -> AVPlayerItem {
    return HysteriaManager.sharedInstance.currentItem()
  }
  
  /// Current index of playlist
  public static func currentTrackIndex() -> Int? {
    return HysteriaManager.sharedInstance.currentIndex()
  }
  
  /// Play music from main queue by specified index
  public static func playMainAtIndex(index: Int) {
    HysteriaManager.sharedInstance.playMainAtIndex(index)
  }
  
  /// Play music from next queue by specified index
  public static func playNextAtIndex(index: Int) {
    HysteriaManager.sharedInstance.playNextAtIndex(index)
  }
}
