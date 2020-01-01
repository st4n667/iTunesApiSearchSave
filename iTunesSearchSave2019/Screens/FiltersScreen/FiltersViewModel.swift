//
//  FiltersViewModel.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 31/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import UIKit
import CoreData

class FiltersControllerViewModel {
    
    weak var delegate: FiltersViewModelDelgate?
    var currentFilter = Filter()
    private let coreDataService: CoreDataService
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }
    
    /*
     I'm aware this is not the prettiest approach. I was running out of time...
     */
    
    @objc func handleButtonTap(sender: UIButton) {
        var filter = Filter()
        switch sender.tag {
        case 1001:
            filter = Filter(predicate: nil,
                            sortDescriptors: [NSSortDescriptor(key: #keyPath(Song.trackName), ascending: true)],
                            groupingKeyPath: nil)
        case 1002:
            filter = Filter(predicate: nil,
                            sortDescriptors: [NSSortDescriptor(key: #keyPath(Song.trackName), ascending: false)],
                            groupingKeyPath: nil)
        case 2001:
            filter = Filter(predicate: nil,
                            sortDescriptors: [NSSortDescriptor(key: #keyPath(Song.artistName), ascending: true)],
                            groupingKeyPath: nil)
        case 2002:
            filter = Filter(predicate: nil,
                            sortDescriptors: [NSSortDescriptor(key: #keyPath(Song.artistName), ascending: false)],
                            groupingKeyPath: nil)
        case 3001:
            filter = Filter(predicate: nil,
                            sortDescriptors: [],
                            groupingKeyPath: #keyPath(Song.artistName))
        case 4001:
            filter = Filter(predicate: nil,
                            sortDescriptors: [],
                            groupingKeyPath: #keyPath(Song.primaryGenreName))
        default:
            return
        }
        
        currentFilter.combine(with: &filter)
        delegate?.filterViewModel(self, didChangeFilter: currentFilter)
    }
    
    /*
    Unused for now. My plan was to fetch all genres and add ability to filter results with picker selection
    */
//    fileprivate func dictionaryFetch() {
//        let keypathExpression = NSExpression(forKeyPath: #keyPath(Song.primaryGenreName))
//        let expression = NSExpression(forFunction: "count:", arguments: [keypathExpression])
//        let sumDescription = NSExpressionDescription()
//        sumDescription.expression = expression
//        sumDescription.name = "count"
//        sumDescription.expressionResultType = .integer32AttributeType
//
//        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Song")
//        fetchRequest.resultType = .dictionaryResultType
//        fetchRequest.propertiesToGroupBy = [#keyPath(Song.primaryGenreName)]
//        fetchRequest.propertiesToFetch = [#keyPath(Song.primaryGenreName), sumDescription]
//        fetchRequest.returnsObjectsAsFaults = false
//
//        do {
////            let results = try coreDataService.context.fetch(fetchRequest)
////            print(results)
//        } catch let error as NSError {
//            print("count not fetched \(error), \(error.userInfo)")
//        }
//    }
    
}
