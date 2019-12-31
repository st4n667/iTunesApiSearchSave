//
//  Enpdoint.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 16/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import Foundation

protocol APITargetType {
    var scheme: String { get }
    var host: String { get }
}

fileprivate enum APITarget {
    case iTunes
}

extension APITarget: APITargetType {
    var scheme: String {
        switch self {
        case .iTunes:
            return "https"
        }
    }
    
    var host: String {
        switch self {
        case .iTunes:
            return "itunes.apple.com"
        }
    }
}

protocol RequestProvider {
    var urlRequest: URLRequest { get }
}

struct Endpoint {
    fileprivate let apiTarget: APITarget
    fileprivate let path: String
    let queryItems: [URLQueryItem]
}

extension Endpoint: RequestProvider {
    var urlRequest: URLRequest {
        var components = URLComponents()
        components.scheme = apiTarget.scheme
        components.host = apiTarget.host
        components.path = path
        components.queryItems = queryItems
        guard let url = components.url else {
            fatalError("Invalid URL used to create URL instance")
        }
        let r = URLRequest(url: url)
        return r
    }
}

extension Endpoint {
    
    static func searchForSong(_ query: String, limit: Int = 10, offset: Int = 0) -> Endpoint {
        return Endpoint(apiTarget: .iTunes,
                        path: "/search",
                        queryItems: [
                            URLQueryItem(name: "media", value: "music"),
                            URLQueryItem(name: "term", value: query),
                            URLQueryItem(name: "limit", value: String(limit)),
                            URLQueryItem(name: "offset", value: String(offset))
        ])
    }
}
