//
//  DataLoader.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 16/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import Foundation

protocol Networking {
    typealias DataResult = Result<Data, APIError>
    func request(_ endpoint: RequestProvider, then completion: @escaping (DataResult) -> Void)
}

class DataLoader: Networking {
    func request(_ endpoint: RequestProvider,
                 then completion: @escaping (DataResult) -> Void) {
        let task = URLSession.shared.dataTask(with: endpoint.urlRequest) {
            data, response, error in
            
            if let error = error {
                completion(.failure(.otherError(error)))
            }
            
            guard let HTTPResponse = response as? HTTPURLResponse,
                200 ..< 300 ~= HTTPResponse.statusCode else {
                    completion(.failure(.badResponse))
                    return
            }
       
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
    
}
