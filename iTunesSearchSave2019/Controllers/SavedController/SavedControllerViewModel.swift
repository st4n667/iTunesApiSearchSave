//
//  SavedControllerViewModel.swift
//  iTunesSearchSave2019
//
//  Created by Staszek Stryjewski on 31/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import CoreData

class SavedControllerViewModel {
    
    var savedSongsCount = Observable<Int>(0)
    
    private var coreDataService: CoreDataService
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }
    
    /* move this to service */
    func delete(_ item: Song) {
        do {
            let endpoint = try DiskEndpoint.imageDocuments(filename: item.imageFilename!)
            try DiskService.removeDataWithEndpint(endpoint)
            coreDataService.delete(item)
        } catch {
            print(error)
        }
    }
    
    func updateBadgeData() {
        let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Song")
        fetchRequest.resultType = .countResultType
        do {
            let counts: [NSNumber] = try coreDataService.context.fetch(fetchRequest)
            let res = (counts.first ?? 0).intValue
            savedSongsCount.value = res
        } catch {
            print(error)
        }
    }
    
}

