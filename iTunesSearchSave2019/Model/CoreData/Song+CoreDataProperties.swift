//
//  Song+CoreDataProperties.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 20/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//
//

import Foundation
import CoreData


extension Song {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Song> {
        return NSFetchRequest<Song>(entityName: "Song")
    }

    @NSManaged public var artistName: String?
    @NSManaged public var imageFilename: String?
    @NSManaged public var collectionName: String?
    @NSManaged public var country: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var primaryGenreName: String?
    @NSManaged public var trackId: Int64
    @NSManaged public var trackName: String?
    
}


/*
 I made the Diffable struct within CoreData model, because I have encountered some crashes with DiffableDataSources
 because of duplicate data identifiers..
 */

extension Song {
    struct Diffable: Hashable {
        let id = UUID()
        var trackId: Int64
        var trackName: String
        var artistName: String
        var collectionName: String
        var primaryGenreName: String
        var country: String
        var imageURL: String?
        var imageFilename: String?
        
        init(song: Song) {
            self.trackId = song.trackId
            self.trackName = song.trackName ?? ""
            self.artistName = song.artistName ?? ""
            self.collectionName = song.collectionName ?? ""
            self.primaryGenreName = song.primaryGenreName ?? ""
            self.country = song.country ?? ""
            self.imageURL = song.imageURL ?? ""
            self.imageFilename = song.imageFilename ?? ""
        }
    }
}
