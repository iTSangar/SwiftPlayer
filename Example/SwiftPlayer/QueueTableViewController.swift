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

enum SectionPlayer: Int {
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
      return
    case .Next:
      
      break
    case .Resume:
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
  
  var section = SectionPlayer.NowPlaying
  
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
    return self.section.sections
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    self.section = SectionPlayer.init(rawValue: section)!
    return self.section.rows
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    self.section = SectionPlayer.init(rawValue: section)!
    return self.section.title
  }
  
  override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let header = view as! UITableViewHeaderFooterView
    header.textLabel?.font = UIFont.systemFontOfSize(12, weight: UIFontWeightRegular)
    view.tintColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.7)
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("QueueTableViewCell", forIndexPath: indexPath) as! QueueTableViewCell
    return cell
  }
  
  // MARK: Table view delegate
  
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if cell.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:")) {
      cell.layoutMargins = UIEdgeInsetsZero
      cell.preservesSuperviewLayoutMargins = false
    }
    
    let cell = cell as! QueueTableViewCell
    self.section = SectionPlayer.init(rawValue: indexPath.section)!
    cell.track = self.section.value(indexPath.row)
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.section = SectionPlayer.init(rawValue: indexPath.section)!
    self.section.selected(indexPath.row)
  }
  
}


extension QueueTableViewController: SwiftPlayerQueueDelegate {
  
  func queueUpdated() {
    tableView.reloadData()
  }
}
