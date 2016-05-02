//
//  SwiftPlayerModel.swift
//  Pods
//
//  Created by iTSangar on 1/20/16.
//
//

import Foundation

public struct PlayerTrack {
  public let url: String!
  public let name: String?
  public let image: String?
  public let album: Album?
  public let artist: Artist?
  
  public struct Album {
    public let name: String?
  }
  
  public struct Artist {
    public let name: String?
  }
  
  public init(url: String, name: String? = nil, image: String? = nil, album: String? = nil, artist: String? = nil) {
    self.url = url
    self.name = name
    self.image = image
    self.album = Album(name: album)
    self.artist = Artist(name: artist)
  }
}