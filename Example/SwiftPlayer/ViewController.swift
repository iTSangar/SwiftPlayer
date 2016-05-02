//
//  ViewController.swift
//  SwiftPlayer
//
//  Created by iTSangar on 04/07/2016.
//  Copyright (c) 2016 iTSangar. All rights reserved.
//

import UIKit
import SwiftPlayer
import AlamofireImage

class ViewController: UIViewController {
  
  @IBOutlet var skub: Skuby!
  @IBOutlet var labelDuration: UILabel!
  @IBOutlet var labelCurrent: UILabel!
  @IBOutlet var labelOtherInfo: UILabel!
  @IBOutlet var labelTrack: UILabel!
  @IBOutlet var buttonPlay: UIButton!
  @IBOutlet var buttonShuffle: UIButton!
  @IBOutlet var coverAlbum: UIImageView!
  @IBOutlet var coverBackground: UIImageView!
  
  private let logs = false
  
  let playlist = TrackModel.localSampleData()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUI()
    
    SwiftPlayer.delegate(self)
    SwiftPlayer.newPlaylist(playlist).playAll()
  }
  
}


//MARK: - Adjust initial UI
extension ViewController {
  func prepareUI() {
    skub.setThumbImage(UIImage(named: "skubidu")!, forState: .Normal)
    buttonShuffle.selected = SwiftPlayer.isShuffle() ? true : false
    buttonShuffle.alpha = SwiftPlayer.isShuffle() ? 1.0 : 0.33
  }
}


//MARK: - Sync UI
extension ViewController {
  func syncSkubyWithTime(time: Float) {
    let minValue = skub.minimumValue
    let maxValue = skub.maximumValue
    skub.setValue(((maxValue - minValue) * time / SwiftPlayer.trackDurationTime() + minValue), animated: true)
  }
  
  func syncDurationTime(time: Float) {
    labelDuration.text = time.toTimerString()
  }
  
  func syncCurrentTime(time: Float) {
    labelCurrent.text = time.toTimerString()
  }
  
  func syncPlayButton(isPlaying: Bool) {
    buttonPlay.selected = isPlaying ? true : false
  }
  
  func syncLabelsInfoWithTrack(track: PlayerTrack) {
    if let name = track.name {
      labelTrack.text = name
    }
    
    if let artistName = track.artist?.name {
      if let albumName = track.album?.name {
        labelOtherInfo.text = artistName + " — " + albumName
        return
      }
      labelOtherInfo.text = artistName
    }
  }
  
  func updateAlbumCoverWithURL(url: String) {
    coverAlbum.af_setImageWithURL(NSURL(string: url)!)
    coverBackground.af_setImageWithURL(NSURL(string: url)!)
  }
  
}


//MARK: - Actions
extension ViewController {
  @IBAction func playPause() {
    SwiftPlayer.isPlaying() ? SwiftPlayer.pause() : SwiftPlayer.play()
  }
  
  @IBAction func seekSkuby(sender: UISlider) {
    SwiftPlayer.seekToWithSlider(sender)
  }
  
  @IBAction func beginScrubbing() {
    SwiftPlayer.pause()
  }
  
  @IBAction func endScrubbing() {
    SwiftPlayer.play()
  }
  
  @IBAction func nextTrack() {
    SwiftPlayer.next()
  }
  
  @IBAction func previousTrack() {
    SwiftPlayer.previous()
  }
  
  @IBAction func shuffle() {
    SwiftPlayer.isShuffle() ? SwiftPlayer.disableShuffle() : SwiftPlayer.enableShufle()
    buttonShuffle.selected = SwiftPlayer.isShuffle() ? true : false
    buttonShuffle.alpha = SwiftPlayer.isShuffle() ? 1.0 : 0.33
  }
  
  @IBAction func unwindToPlayer(segue: UIStoryboardSegue) {}
  
  @IBAction func addNext() {
    let randomIndex = Int(arc4random_uniform(UInt32(playlist.count)))
    SwiftPlayer.addNextTrack(playlist[randomIndex])
  }
}

extension ViewController: SwiftPlayerDelegate {
  // Update View Info with track
  func playerCurrentTrackChanged(track: PlayerTrack?) {
    guard let track = track else { return }
    if logs {print("••• 📻 New Track 📻")}
    if logs {print("    Song - \(track.name)")}
    if logs {print("    Artist - \(track.artist?.name)")}
    if logs {print("    Album - \(track.album?.name)")}
    syncLabelsInfoWithTrack(track)
    if let image = track.image {
      updateAlbumCoverWithURL(image)
    }
  }
  
  // Update button play
  func playerRateChanged(isPlaying: Bool) {
    let status = isPlaying ? "⏸" : "▶️"
    if logs {print("••• \(status) Status Button \(status)")}
    syncPlayButton(isPlaying)
  }
  
  // Update duration time
  func playerDurationTime(time: Float) {
    if logs {print("••• ⌛️ \(time.toTimerString())")}
    syncDurationTime(time)
  }
  
  // Update current time
  func playerCurrentTimeChanged(time: Float) {
    if logs {print("••• ⏱ \(time.toTimerString())")}
    syncSkubyWithTime(time)
    syncCurrentTime(time)
  }
  
}


extension Float {
  /// Convert float seconds to string formatted timer
  func toTimerString() -> String {
    let minute = Int(self / 60)
    let second = Int(self % 60)
    return String(format: "%01d:%02d", minute, second)
  }
}


class Skuby: UISlider {
  override func trackRectForBounds(bounds: CGRect) -> CGRect {
    var result = super.trackRectForBounds(bounds)
    result.origin.x = -1
    result.size.height = 3
    result.size.width = bounds.size.width + 2
    return result
  }
}

