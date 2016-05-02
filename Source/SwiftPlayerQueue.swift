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
      temporary = mainQueue
    }
  }
  
  private var temporary = [PlayerTrack]()
  private var tempShift = [PlayerTrack]()
  
  private var nextIndexes = [Int]()
  private var nextPlayedIndexes = [Int]()
  
  ///////////////////////////////////////////////
  func totalTracks() -> Int {
    return nextQueue.count + mainQueue.count
  }
  
  ///////////////////////////////////////////////
  mutating func newNextTrack(track: PlayerTrack, nowIndex: Int) {
    let last = nextIndexes.last
    if last != nil && last > nowIndex {
      nextIndexes.append(last! + 1)
    } else {
      nextIndexes.append(nowIndex + 1)
    }
    
    nextQueue.insert(track, atIndex: 0)
    temporary.insert(track, atIndex: nowIndex + 1)
  }
  
  ///////////////////////////////////////////////
  mutating func queueAtIndex(index: Int) -> PlayerTrack? {
    if nextIndexes.contains(index) {
      if nextPlayedIndexes.contains(index) {
        return nil
      }
      nextPlayedIndexes.append(index)
      return temporary[index]
    }
    return temporary[index]
  }
  
  ///////////////////////////////////////////////
  func trackAtIndex(index: Int) -> PlayerTrack {
    return temporary[index]
  }

  ///////////////////////////////////////////////
  func nextQueueToShow() -> [PlayerTrack] {
    var notPlayed = [PlayerTrack]()
    
    for index in nextIndexes {
      if !nextPlayedIndexes.contains(index) {
        notPlayed.append(temporary[index])
      }
    }
    return notPlayed
  }
  
  ///////////////////////////////////////////////
  mutating func mainQueueToShow() -> [PlayerTrack] {
    tempShift = mainQueue.shift(withDistance:1)
    return tempShift
  }
  
  mutating func clearQueues() {
    temporary = mainQueue
    nextQueue.removeAll()
    nextIndexes.removeAll()
    nextPlayedIndexes.removeAll()
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
}
