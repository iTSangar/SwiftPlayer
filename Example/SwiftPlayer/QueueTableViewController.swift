//
//  QueueTableViewController.swift
//  SwiftPlayer
//
//  Created by Ítalo Sangar on 4/18/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import SwiftPlayer
import AlamofireImage

// MARK: - Section Enum

enum TrackSection: Int {
  case NowPlaying = 0
  case Next = 1
  case Resume = 2
  
  var sections: Int {
    return isNext ? 3 : 2
  }
  
  var rows: Int {
    switch self {
    case .NowPlaying:
      return 1
    case .Next:
      return isNext ? SwiftPlayer.nextTracks().count : SwiftPlayer.mainTracks().count
    case .Resume:
      return SwiftPlayer.mainTracks().count
    }
  }
  
  var title: String {
    switch self {
    case .NowPlaying:
      return "  NOW PLAYING"
    case .Next:
      let songs = SwiftPlayer.nextTracks().count > 1 ? "SONGS" : "SONG"
      return isNext ? "  UP NEXT: \(SwiftPlayer.nextTracks().count) \(songs)" : "  UP NEXT: FROM \(albumName)"
    case .Resume:
      return "  RESUME: \(albumName)"
    }
  }
  
  func value(row: Int) -> PlayerTrack {
    switch self {
    case .NowPlaying:
      return SwiftPlayer.trackAtIndex(SwiftPlayer.currentTrackIndex())
    case .Next:
      return isNext ? SwiftPlayer.nextTracks()[row] : SwiftPlayer.mainTracks()[row]
    case .Resume:
      return SwiftPlayer.mainTracks()[row]
    }
  }
  
  func selected(row: Int) {
    switch self {
    case .NowPlaying:
      break
    case .Next:
      if isNext {
        SwiftPlayer.playNextAtIndex(row)
      } else {
        SwiftPlayer.playMainAtIndex(row)
      }
      break
    case .Resume:
      SwiftPlayer.playMainAtIndex(row)
      break
    }
  }
  
  private var albumName: String {
    if let name = SwiftPlayer.mainTracks()[0].album?.name {
      return name.uppercaseString
    } else {
      return "Any Album".uppercaseString
    }
  }
  
  private var isNext: Bool {
    return SwiftPlayer.nextTracks().count > 0
  }

}

// MARK: - ViewController

class QueueTableViewController: UITableViewController {
  
  var sectionStatus = TrackSection.NowPlaying
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.reloadData()
    SwiftPlayer.queueDelegate(self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return sectionStatus.sections
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    sectionStatus = TrackSection.init(rawValue: section)!
    return sectionStatus.rows
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    sectionStatus = TrackSection.init(rawValue: section)!
    return sectionStatus.title
  }
  
  override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let header = view as! UITableViewHeaderFooterView
    header.textLabel?.font = UIFont.systemFontOfSize(12, weight: UIFontWeightRegular)
    view.tintColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.7)
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCellWithIdentifier("QueueTableViewCell", forIndexPath: indexPath) as! QueueTableViewCell
  }
  
  // MARK: Table view delegate
  
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if cell.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:")) {
      cell.layoutMargins = UIEdgeInsetsZero
      cell.preservesSuperviewLayoutMargins = false
    }
    
    let cell = cell as! QueueTableViewCell
    sectionStatus = TrackSection.init(rawValue: indexPath.section)!
    cell.track = sectionStatus.value(indexPath.row)
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    sectionStatus = TrackSection.init(rawValue: indexPath.section)!
    sectionStatus.selected(indexPath.row)
  }
  
}


extension QueueTableViewController: SwiftPlayerQueueDelegate {
  func queueUpdated() {
    tableView.reloadData()
  }
}
