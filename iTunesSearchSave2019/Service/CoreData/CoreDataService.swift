//
//  CoreDataService.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 27/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import CoreData

class CoreDataService {

    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func saveSong(_ song: JsonSong) {
        let cdSong = Song(context: context)
        cdSong.artistName = song.artistName
        cdSong.imageFilename = song.imageFilename
        cdSong.collectionName = song.collectionName
        cdSong.country = song.country
        cdSong.imageURL = song.artworkUrl
        cdSong.primaryGenreName = song.primaryGenreName
        cdSong.trackId = song.trackId
        cdSong.trackName = song.trackName
        saveContext()
    }
    
    func delete(_ song: Song) {
        context.delete(song)
        saveContext()
    }
    
}
