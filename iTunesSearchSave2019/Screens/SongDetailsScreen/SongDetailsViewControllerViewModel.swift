//
//  SongDetailsViewControllerViewModel.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 28/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import UIKit
import CoreData

class SongDetailsViewControllerViewModel {
    
    let song: JsonSong
    let isSaveButtonEnabled = Observable<Bool>(false)
    var coreDataService: CoreDataService
    
    init(song: JsonSong, coreDataService: CoreDataService) {
        self.song = song
        self.coreDataService = coreDataService
        checkIfSaveButtonEnabled()
    }
    
    deinit {
        print(String(describing: type(of: self)), #function)
    }
    
    func save(withImage image: UIImage?) {
        do {
            let diskEndpoint = try DiskEndpoint.imageDocuments(filename: song.imageFilename)
            if let image = image {
                try DiskService.saveImage(image, to: diskEndpoint.absoluteURL)
            }
            coreDataService.saveSong(song)
        } catch {
            print(error)
        }
    }

    private func checkIfSaveButtonEnabled() {
        let request: NSFetchRequest<Song> = Song.fetchRequest()
        let predicate = NSPredicate(format: "%K = %d", #keyPath(Song.trackId), song.trackId)
        request.predicate = predicate
        do {
            let fetched = try coreDataService.context.fetch(request)
            isSaveButtonEnabled.value = fetched.isEmpty
        } catch {
            isSaveButtonEnabled.value = false
            print(error)
        }
    }

}
