//
//  SwiftPlayerQueue.swift
//  Pods
//
//  Created by Ítalo Sangar on 4/8/16.
//
//

import Foundation

struct PlayerQueue {
  
  var history = [PlayerTrack]()
  var nextQueue = [PlayerTrack]()
  var mainQueue = [PlayerTrack]() {
    didSet {
      allTracks = mainQueue
    }
  }
  
  private var allTracks = [PlayerTrack]()
  private var tempShift = [PlayerTrack]()
  
  private var nextIndexes = [Int]()
  private var nextPlayedIndexes = [Int]()
  
  ///////////////////////////////////////////////
  func totalTracks() -> Int {
    return nextQueue.count + mainQueue.count
  }
  
  ///////////////////////////////////////////////
  mutating func newNextTrack(track: PlayerTrack, nowIndex: Int) {
    nextQueue.insert(track, atIndex: 0)
    allTracks.insert(track, atIndex: nowIndex + 1)
  }
  
  ///////////////////////////////////////////////
  mutating func queueAtIndex(index: Int) -> PlayerTrack? {
    if allTracks.contains( { $0.origin == TrackType.Next }) {
      if allTracks[index - 1].origin == TrackType.Next {
        allTracks.removeAtIndex(index - 1)
        nextQueue.removeAtIndex(0)
        return nil
      }
    }

    return allTracks[index]
  }
  
  ///////////////////////////////////////////////
  mutating func reorderQueuePrevious(nowIndex: Int, reorderHysteria: (from: Int, to: Int) -> Void) {
    
    var totalNext = 0
    for nTrack in allTracks where nTrack.origin == TrackType.Next {
      totalNext += 1
    }
    
    while totalNext != 0 {
      for (index, track) in allTracks.reverse().enumerate() {
        if track.origin == TrackType.Next {
          allTracks.moveItem(fromIndex: ((allTracks.count - 1) - index), toIndex: nowIndex + 1)
          reorderHysteria(from: ((allTracks.count - 1) - index), to: nowIndex + 1)
          totalNext -= 1
          break
        }
      }
    }
  }
  
  ///////////////////////////////////////////////
  func trackAtIndex(index: Int) -> PlayerTrack {
    return allTracks[index]
  }

  ///////////////////////////////////////////////
  func nextQueueToShow() -> [PlayerTrack] {
    var notPlayed = [PlayerTrack]()
    
    for index in nextIndexes {
      if !nextPlayedIndexes.contains(index) {
        notPlayed.append(allTracks[index])
      }
    }
    return notPlayed
  }
}


extension Array {
  
  func shift(withDistance distance: Index.Distance = 1) -> Array<Element> {
    let index = distance >= 0 ?
      startIndex.advancedBy(distance, limit: endIndex) :
      endIndex.advancedBy(distance, limit: startIndex)
    return Array(self[index ..< endIndex] + self[startIndex ..< index])
  }
  
  mutating func shiftInPlace(withDistance distance: Index.Distance = 1) {
    self = shift(withDistance: distance)
  }
  
  mutating func moveItem(fromIndex oldIndex: Index, toIndex newIndex: Index) {
    insert(removeAtIndex(oldIndex), atIndex: newIndex)
  }
}
