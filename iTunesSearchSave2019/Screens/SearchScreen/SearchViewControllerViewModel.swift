//
//  SearchViewControllerViewModel.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 24/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import UIKit

protocol SearchViewControllerViewModelType {
    var songs: [JsonSong] { get }
    var onFeedUpdate: (() -> Void)? { get set }
    func makeRequestWithQuery(_ query: String)
    func clearResults()
    func getItemAt(_ indexPath: IndexPath) -> JsonSong
    
    
    func paginate()
}

extension SearchViewControllerViewModelType {
    func getItemAt(_ indexPath: IndexPath) -> JsonSong {
        return songs[indexPath.row]
    }
}

class SearchViewControllerViewModel: NSObject, SearchViewControllerViewModelType {
    let networking: Networking
    private(set) var songs: [JsonSong] = []
    var onFeedUpdate: (() -> Void)?

    func clearResults() {
        songs.removeAll()
        onFeedUpdate?()
    }
    
    private let fetchSessionLimit = 10
    private var query: String?
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    deinit {
        print(String(describing: type(of: self)), #function)
    }
    
    func makeRequestWithQuery(_ query: String) {
        self.query = query
        let endpoint: RequestProvider = Endpoint.searchForSong(query, limit: fetchSessionLimit, offset: 0)
        networking.request(endpoint) { [weak self] res in
            if case let .success(data) = res {
                let results = try! JSONDecoder().decode(JsonResponse.self, from: data)
                self?.songs = results.results ?? []
                self?.onFeedUpdate?()
            }
        }
    }
    
    func paginate() {
        guard let query = query else { return }
        let endpoint = Endpoint.searchForSong(query, limit: fetchSessionLimit, offset: songs.count + 1)
        networking.request(endpoint) { [weak self] res in
            if case let .success(data) = res {
                let results = try! JSONDecoder().decode(JsonResponse.self, from: data)
                let downloadedSongs = results.results ?? []
                self?.songs += downloadedSongs
                DispatchQueue.global().async {
                    self?.onFeedUpdate?()
                }
            }
        }
    }

}
