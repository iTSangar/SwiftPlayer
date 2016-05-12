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
  mutating func removeNextAtIndex(index: Int) {
    allTracks.removeAtIndex(index)
    nextQueue.removeAtIndex(0)
  }
  
  ///////////////////////////////////////////////
  mutating func queueAtIndex(index: Int) -> PlayerTrack? {
    if allTracks.contains({ $0.origin == TrackType.Next }) {
      if index > 0 && allTracks[index - 1].origin == TrackType.Next {
        allTracks.removeAtIndex(index - 1)
        nextQueue.removeAtIndex(0)
        return nil
      }
    }

    return allTracks[index]
  }
  
  ///////////////////////////////////////////////
  func indexForShuffle() -> Int? {
    for (index, track) in allTracks.enumerate() where track.origin == TrackType.Next {
      return index
    }
    return nil
  }

  ///////////////////////////////////////////////
  func indexToPlayAt(indexMain: Int) -> Int? {
    for (index, track) in allTracks.enumerate() where track.origin == TrackType.Normal && track.position == indexMain {
      return index
    }
    return nil
  }
  
  ///////////////////////////////////////////////
  mutating func indexToPlayNextAt(indexNext: Int, nowIndex: Int) -> Int? {
    var indexOnQueue = 0
    var firstFound = 0
    var totalFound = 0
    
    for (index, track) in allTracks.enumerate() where track.origin == TrackType.Next {
      firstFound = index
      indexOnQueue = index + indexNext
      break
    }
    
    for i in 0..<indexOnQueue {
      if allTracks[i].origin == TrackType.Next {
        totalFound += 1
      }
    }
    
    if allTracks[nowIndex].origin == TrackType.Next {
      firstFound += 1
      indexOnQueue += 1
    }
    
    allTracks.removeRange(firstFound...(indexOnQueue - 1))
    
    for _ in firstFound...(indexOnQueue - 1) {
      nextQueue.removeAtIndex(0)
    }
    
    return indexOnQueue - totalFound
  }
  
  ///////////////////////////////////////////////
  mutating func reorderQueuePrevious(nowIndex: Int, reorderHysteria: (from: Int, to: Int) -> Void) {
    if nowIndex <= 0 { return }
    
    var totalNext = 0
    for nTrack in allTracks where nTrack.origin == TrackType.Next {
      totalNext += 1
    }
    
    while totalNext != 0 {
      for (index, track) in allTracks.reverse().enumerate() where track.origin == TrackType.Next {
        allTracks.moveItem(fromIndex: ((allTracks.count - 1) - index), toIndex: nowIndex + 1)
        reorderHysteria(from: ((allTracks.count - 1) - index), to: nowIndex + 1)
        totalNext -= 1
        break
      }
    }
  }
  
  ///////////////////////////////////////////////
  func trackAtIndex(index: Int) -> PlayerTrack {
    return allTracks[index]
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
