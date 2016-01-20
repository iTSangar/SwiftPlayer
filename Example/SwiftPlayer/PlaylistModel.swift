//
//  PlaylistModel.swift
//  SwiftPlayer
//
//  Created by Ítalo Sangar on 1/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import SwiftPlayer
import ObjectMapper

//MARK: - Protocol Adoption -
struct Track: TrackProtocol {
  var id: String
  var name: String
  var link: String
  var duration: Int
  var rank: Int
  var url: String
  var album: AlbumProtocol
  var artist: ArtistProtocol
  
  static func localSampleData(withSize size: Int = 15) -> [TrackProtocol] {
    var tracks = [TrackProtocol]()
    let url = NSBundle.mainBundle().URLForResource("hiphop_playlist_full", withExtension: "json")
    let data = NSData(contentsOfURL: url!)
    
    do {
      let object = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
      if let dictionary = object as? [String: AnyObject] {
        guard let playlist = Mapper<PlaylistJSONParse>().map(dictionary)
          else { return tracks }
        
        for (index, item) in playlist.data!.enumerate() {
          if size < index { continue }
          let artist = Artist(id: item.artist.id, name: item.artist.name, link: item.artist.link, tracklist: item.artist.tracklist)
          let album = Album(id: item.album.id, name: item.album.title, image: item.album.coverBig, tracklist: item.album.tracklist)
          let track = Track(id: String(item.id), name: item.title, link: item.link, duration: item.duration, rank: item.rank, url: item.preview, album: album, artist: artist)
          tracks.append(track)
        }
      }
    } catch {
      // Handle Error
    }
    
    return tracks
  }
  
}

struct Album: AlbumProtocol {
  var id: Int
  var name: String
  var image: String
  var tracklist: String
}

struct Artist: ArtistProtocol {
  var id: Int
  var name: String
  var link: String
  var tracklist: String
}

struct Playlist: PlaylistProtocol {
  var tracks: [TrackProtocol]
}


//MARK: - JSON Parser -
struct PlaylistJSONParse: Mappable {
  var data: [TrackJSONParse]?
  
  init?(_ map: Map) {}
  
  mutating func mapping(map: Map) {
    data <- map["tracks.data"]
  }
}

struct TrackJSONParse: Mappable {
  var id: Int!
  var readable: Bool!
  var title: String!
  var link: String!
  var duration: Int!
  var rank: Int!
  var preview: String!
  var album: AlbumJSONParse!
  var artist: ArtistJSONParse!
  
  init?(_ map: Map) {}
  
  mutating func mapping(map: Map) {
    id        <- map["id"]
    readable  <- map["readable"]
    title     <- map["title"]
    link      <- map["link"]
    duration  <- map["duration"]
    rank      <- map["rank"]
    preview   <- map["preview"]
    album     <- map["album"]
    artist    <- map["artist"]
  }
}

struct AlbumJSONParse: Mappable {
  var id: Int!
  var title: String!
  var cover: String!
  var coverSmall: String!
  var coverMedium: String!
  var coverBig: String!
  var tracklist: String!
  
  init?(_ map: Map) {}
  
  mutating func mapping(map: Map) {
    id           <- map["id"]
    title        <- map["title"]
    cover        <- map["cover"]
    coverSmall   <- map["cover_small"]
    coverMedium  <- map["cover_medium"]
    coverBig     <- map["cover_big"]
    tracklist    <- map["tracklist"]
  }
}

struct ArtistJSONParse: Mappable {
  var id: Int!
  var name: String!
  var link: String!
  var tracklist: String!
  
  init?(_ map: Map) {}
  
  mutating func mapping(map: Map) {
    id        <- map["id"]
    name      <- map["name"]
    link      <- map["link"]
    tracklist <- map["tracklist"]
  }
}
