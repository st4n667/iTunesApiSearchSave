//
//  JsonSong.swift
//  iTunesApiSearchSave
//
//  Created by Stanisław Stryjewski on 22.05.2018.
//  Copyright © 2018 Stanisław Stryjewski. All rights reserved.
//

import Foundation

struct JsonResponse: Decodable {
    var resultCount: Int
    var results: [JsonSong]?
}

struct JsonSong: Decodable {
    var artistName: String
    var imageFilename: String {
        return String(trackId)
            .appending(trackName.prefix(20))
    }
    var collectionName: String?
    var country: String
    var artworkUrl: String
    var primaryGenreName: String
    var trackId: Int64
    var trackName: String
 
    private enum CodingKeys: String, CodingKey {
        case artistName, collectionName, country, primaryGenreName, trackId, trackName
        case artworkUrl = "artworkUrl100"
    }
}

extension JsonSong {
    struct Diffable: Hashable {
        let uuid = UUID()
        var artistName: String
        var imageFilename: String
        var collectionName: String?
        var artworkUrl: String
        var primaryGenreName: String
        var trackId: Int64
        var trackName: String
        init(song: JsonSong) {
            self.artistName = song.artistName
            self.imageFilename = song.imageFilename
            self.collectionName = song.collectionName
            self.artworkUrl = song.artworkUrl
            self.primaryGenreName = song.primaryGenreName
            self.trackId = song.trackId
            self.trackName = song.trackName
        }
    }
}
