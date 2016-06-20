//
//  SwiftPlayerModel.swift
//  Pods
//
//  Created by iTSangar on 1/20/16.
//
//

import Foundation

enum TrackType {
  case Normal
  case Next
}

public struct PlayerTrack {
  public let url: String!
  public let name: String?
  public let image: String?
  public let album: Album?
  public let artist: Artist?
  
  public var modelObjectSupport: AnyObject?
  
  var origin: TrackType! = TrackType.Normal
  var position: Int?
  
  public struct Album {
    public var name: String?
    
    public init() { }
    
    public init(name: String?) {
      self.name = name
    }
  }
  
  public struct Artist {
    public var name: String?
    
    public init() { }
    
    public init(name: String?) {
      self.name = name
    }
  }
  
  public init(url: String, name: String? = nil, image: String? = nil, album: String? = nil, artist: String? = nil) {
    self.url = url
    self.name = name
    self.image = image
    self.album = Album(name: album)
    self.artist = Artist(name: artist)
  }
}