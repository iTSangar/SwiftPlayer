//
//  HysteriaManager.swift
//  Pods
//
//  Created by iTSangar on 1/15/16.
//
//

import UIKit
import Foundation
import MediaPlayer
import HysteriaPlayer


import Foundation
import MediaPlayer
import HysteriaPlayer

// MARK: - HysteriaManager
/// Layer to interact with Hysteria instance and delegate methods.
class HysteriaManager: NSObject {
  static let sharedInstance = HysteriaManager()
  var queue: PlaylistProtocol?
  var delegate: SwiftPlayerDelegate?
  lazy var hysteriaPlayer = HysteriaPlayer.sharedInstance()
  let commandCenter = MPRemoteCommandCenter.sharedCommandCenter()
  private let logs = true
  
  private override init() {
    super.init()
    initHysteriaPlayer()
  }
  
  private func initHysteriaPlayer() {
    hysteriaPlayer.delegate = self;
    hysteriaPlayer.datasource = self;
    enableCommandCenter()
  }
  
  func setPlaylist(playlist: PlaylistProtocol) {
    queue = playlist
  }
  
}


// MARK: - HysteriaManager - UI
extension HysteriaManager {
  private func currentTime() {
    hysteriaPlayer.addPeriodicTimeObserverForInterval(CMTimeMake(100, 1000), queue: nil, usingBlock: {
      time in
      let totalSeconds = CMTimeGetSeconds(time)
      self.delegate?.playerCurrentTimeChanged(Float(totalSeconds))
    })
  }
  
  private func updateCurrentItem() {
    infoCenterWithTrack(currentItem())
    
    let duration = hysteriaPlayer.getPlayingItemDurationTime()
    if duration > 0 {
      delegate?.playerDurationTime(duration)
    }
  }
  
}


// MARK: - HysteriaManager - MPNowPlayingInfoCenter
extension HysteriaManager {
  private func infoCenterWithTrack(track: TrackProtocol?) {
    guard let track = track else { return }
    MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [
      MPMediaItemPropertyAlbumTitle: track.album.name,
      MPMediaItemPropertyArtist: track.artist.name,
      MPMediaItemPropertyArtwork: MPMediaItemArtwork(image: UIImage(named: "kcamp")!),
      MPMediaItemPropertyPlaybackDuration: NSTimeInterval(hysteriaPlayer.getPlayingItemDurationTime()),
      MPMediaItemPropertyTitle: track.name]
  }
}


// MARK: - HysteriaManager - Remote Control Events
extension HysteriaManager {
  private func enableCommandCenter() {
    commandCenter.playCommand.addTargetWithHandler({_ in
      self.play()
      return MPRemoteCommandHandlerStatus.Success
    })
    
    commandCenter.pauseCommand.addTargetWithHandler({_ in
      self.pause()
      return MPRemoteCommandHandlerStatus.Success
    })
    
    commandCenter.nextTrackCommand.addTargetWithHandler({_ in
      self.next()
      return MPRemoteCommandHandlerStatus.Success
    })
    
    commandCenter.previousTrackCommand.addTargetWithHandler({_ in
      self.previous()
      return MPRemoteCommandHandlerStatus.Success
    })
  }
}


// MARK: - HysteriaManager - Actions
extension HysteriaManager {
  
  // Play Methods
  func play() {
    if !hysteriaPlayer.isPlaying() {
      hysteriaPlayer.pausePlayerForcibly(false)
      hysteriaPlayer.play()
    }
  }
  
  func playAtIndex(index: Int) {
    fetchAndPlayAtIndex(index)
  }
  
  func playAllTracks() {
    fetchAndPlayAtIndex(0)
  }
  
  func pause() {
    if hysteriaPlayer.isPlaying() {
      hysteriaPlayer.pausePlayerForcibly(true)
      hysteriaPlayer.pause()
    }
  }
  
  func next() {
    hysteriaPlayer.playNext()
    play()
  }
  
  func previous() {
    hysteriaPlayer.playPrevious()
  }
  
  // Shuffle Methods
  func shuffleStatus() -> Bool {
    switch hysteriaPlayer.getPlayerShuffleMode() {
    case .On:
      return true
    case .Off:
      return false
    }
  }
  
  func enableShuffle() {
    hysteriaPlayer.setPlayerShuffleMode(.On)
  }
  
  func disableShuffle() {
    hysteriaPlayer.setPlayerShuffleMode(.Off)
  }
  
  // Repeat Methods
  func repeatStatus() -> (Bool, Bool, Bool) {
    switch hysteriaPlayer.getPlayerRepeatMode() {
    case .On:
      return (true, false, false)
    case .Once:
      return (false, true, false)
    case .Off:
      return (false, false, true)
    }
  }
  
  func enableRepeat() {
    hysteriaPlayer.setPlayerRepeatMode(.On)
  }
  
  func enableRepeatOne() {
    hysteriaPlayer.setPlayerRepeatMode(.Once)
  }
  
  func disableRepeat() {
    hysteriaPlayer.setPlayerRepeatMode(.Off)
  }
  
  func seekTo(slider: UISlider) {
    let duration = hysteriaPlayer.getPlayingItemDurationTime()
    if isfinite(duration) {
      let minValue = slider.minimumValue
      let maxValue = slider.maximumValue
      let value = slider.value
      
      let time = duration * (value - minValue) / (maxValue - minValue)
      hysteriaPlayer.seekToTime(Double(time))
    }
  }
  
}


// MARK: - Hysteria Utils
extension HysteriaManager {
  private func updateCount() {
    hysteriaPlayer.itemsCount = hysteriaPlayerNumberOfItems()
  }
  
  private func currentItem() -> TrackProtocol? {
    if let index: NSNumber = hysteriaPlayer.getHysteriaIndex(hysteriaPlayer.getCurrentItem()) {
      return queue?.tracks[Int(index)]
    }
    return nil
  }
  
  private func fetchAndPlayAtIndex(index: Int) {
    hysteriaPlayer.fetchAndPlayPlayerItem(index)
  }
  
  func playingItemDurationTime() -> Float {
    return hysteriaPlayer.getPlayingItemDurationTime()
  }
}


// MARK: - HysteriaPlayerDataSource
extension HysteriaManager: HysteriaPlayerDataSource {
  func hysteriaPlayerNumberOfItems() -> Int {
    return queue != nil ? (queue?.tracks.count)! : 0
  }
  
  func hysteriaPlayerURLForItemAtIndex(index: Int, preBuffer: Bool) -> NSURL! {
    return NSURL(string: queue!.tracks[index].url)!
  }
  
}


// MARK: - HysteriaPlayerDelegate
extension HysteriaManager: HysteriaPlayerDelegate {
  
  func hysteriaPlayerWillChangedAtIndex(index: Int) {
    if logs {print("• player will changed :atindex >> \(index)")}
  }
  
  func hysteriaPlayerCurrentItemChanged(item: AVPlayerItem!) {
    if logs {print("• current item changed :item >> \(item)")}
    delegate?.playerCurrentTrackChanged(currentItem())
    updateCurrentItem()
  }
  
  func hysteriaPlayerRateChanged(isPlaying: Bool) {
    if logs {print("• player rate changed :isplaying >> \(isPlaying)")}
    delegate?.playerRateChanged(isPlaying)
  }
  
  func hysteriaPlayerDidReachEnd() {
    if logs {print("• player did reach end")}
  }
  
  func hysteriaPlayerCurrentItemPreloaded(time: CMTime) {
    if logs {print("• current item preloaded :time >> \(CMTimeGetSeconds(time))")}
  }
  
  func hysteriaPlayerDidFailed(identifier: HysteriaPlayerFailed, error: NSError!) {
    if logs {print("• player did failed :error >> \(error.description)")}
    switch identifier {
    case .CurrentItem: next()
      break
    case .Player:
      break
    }
  }
  
  func hysteriaPlayerReadyToPlay(identifier: HysteriaPlayerReadyToPlay) {
    if logs {print("• player ready to play")}
    switch identifier {
    case .CurrentItem: updateCurrentItem()
      break
    case .Player: currentTime()
      break
    }
  }
  
  func hysteriaPlayerItemFailedToPlayEndTime(item: AVPlayerItem!, error: NSError!) {
    if logs {print("• item failed to play end time :error >> \(error.description)")}
  }
  
  func hysteriaPlayerItemPlaybackStall(item: AVPlayerItem!) {
    if logs {print("• item playback stall :item >> \(item)")}
  }
  
}