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
struct TrackModel {
  static func localSampleData(withSize size: Int = 15) -> [PlayerTrack] {
    var tracks = [PlayerTrack]()
    let url = NSBundle.mainBundle().URLForResource("hiphop_playlist_full", withExtension: "json")
    let data = NSData(contentsOfURL: url!)
    
    do {
      let object = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
      if let dictionary = object as? [String: AnyObject] {
        guard let playlist = Mapper<PlaylistJSONParse>().map(dictionary)
          else { return tracks }
        
        for (index, item) in playlist.data!.enumerate() {
          if size < index { continue }
          let track = PlayerTrack(url: item.preview, name: item.title, image: item.album.coverBig, album: item.album.title, artist: item.artist.name)
          tracks.append(track)
        }
      }
    } catch {
      // Handle Error
    }
    
    
    return tracks
  }
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
