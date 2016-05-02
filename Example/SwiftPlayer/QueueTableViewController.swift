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
    return SwiftPlayer.nextTracks().count > 0 ? 3 : 2
  }
  
  var rows: Int {
    switch self {
    case .NowPlaying:
      return 1
    case .Next:
      return SwiftPlayer.nextTracks().count > 0 ? SwiftPlayer.nextTracks().count : SwiftPlayer.mainTracks().count
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
      return SwiftPlayer.nextTracks().count > 0 ? "  UP NEXT: \(SwiftPlayer.nextTracks().count) \(songs)" : "  UP NEXT: FROM \(albumName)"
    case .Resume:
      return "  RESUME: \(albumName)"
    }
  }
  
  private var albumName: String {
    if let name = SwiftPlayer.mainTracks()[0].album?.name {
      return name.uppercaseString
    } else {
      return "Any Album".uppercaseString
    }
  }
  
  func value(row: Int) -> PlayerTrack {
    switch self {
    case .NowPlaying:
      return SwiftPlayer.trackAtIndex(SwiftPlayer.currentTrackIndex())
    case .Next:
      return SwiftPlayer.nextTracks().count > 0 ? SwiftPlayer.nextTracks()[row] : SwiftPlayer.mainTracks()[row]
    case .Resume:
      return SwiftPlayer.mainTracks()[row]
    }
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
    // Dispose of any resources that can be recreated.
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
  
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if (cell.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:"))){
      cell.layoutMargins = UIEdgeInsetsZero
      cell.preservesSuperviewLayoutMargins = false
    }
    
    let cell = cell as! QueueTableViewCell
    self.section = SectionPlayer.init(rawValue: indexPath.section)!
    cell.track = self.section.value(indexPath.row)
  }
  
  /*
   // Override to support conditional editing of the table view.
   override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */
  
  /*
   // Override to support editing the table view.
   override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
   if editingStyle == .Delete {
   // Delete the row from the data source
   tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
   } else if editingStyle == .Insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */
  
  /*
   // Override to support rearranging the table view.
   override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}

extension QueueTableViewController: SwiftPlayerQueueDelegate {
  func queueUpdated() {
    tableView.reloadData()
  }
}
