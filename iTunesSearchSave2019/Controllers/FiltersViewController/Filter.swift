//
//  Filter.swift
//  iTunesSearchSave2019
//
//  Created by Staszek Stryjewski on 31/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import Foundation
import CoreData

struct Filter {
    // request
    private var predicate: NSPredicate? = nil
    private var sortDescriptors: [NSSortDescriptor] = []
    
    // fetchedResultsController
    private var groupingKeyPath: String?
    
    init(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor] = [], groupingKeyPath: String? = nil) {
        self.predicate = predicate
        self.sortDescriptors = sortDescriptors
        self.groupingKeyPath = groupingKeyPath
    }

    func applyToRequest<T>(_ request: inout NSFetchRequest<T>) {
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
    }
    
    func getGroupingKeyPath() -> String? {
        return groupingKeyPath
    }
    
    mutating func combine(with filter: inout Filter) {
        if let pred = filter.predicate {
            self.predicate = pred
        }
        if !filter.sortDescriptors.isEmpty {
            self.sortDescriptors = filter.sortDescriptors
        }
        if let path = filter.groupingKeyPath {
            self.groupingKeyPath = path
        }
    }
    
}
