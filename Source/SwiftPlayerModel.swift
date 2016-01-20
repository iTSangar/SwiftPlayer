//
//  SwiftPlayerModel.swift
//  Pods
//
//  Created by iTSangar on 1/20/16.
//
//

import Foundation

/// SwiftPlayer playlist protocol
protocol TrackProtocol {
  var id: String { get }
  var url: String { get }
  var name: String { get }
  var album: AlbumProtocol { get }
  var artist: ArtistProtocol { get }
}

/// SwiftPlayer playlist protocol
protocol AlbumProtocol {
  var name: String { get }
  var image: String { get }
}

/// SwiftPlayer playlist protocol
protocol ArtistProtocol {
  var name: String { get }
}

/// SwiftPlayer playlist protocol
protocol PlaylistProtocol {
  var tracks: [TrackProtocol] { get set }
}