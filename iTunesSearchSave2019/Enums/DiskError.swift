//
//  DiskError.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 29/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import Foundation

enum DiskError: Error {
    case dataTransformError
    case fileDeleteError(_ error: Error?)
    case fileSaveError(_ error: Error?)
    case createEndpointError(_ error: Error?)
    case createDirectoryError(_ error: Error?)
}
