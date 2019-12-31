//
//  File.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 29/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import Foundation

enum APIError: Error {
    case invalidUrl
    case badData
    case badResponse
    case otherError(_ error: Error?)
}
