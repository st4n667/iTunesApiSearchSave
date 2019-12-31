//
//  ImageLoader.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 26/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import UIKit

class ImageLoader: NSObject {
    private var loadedImages = NSCache<NSString, UIImage>()
    private var runningRequests = [UUID: URLSessionTask]()
    
    typealias ImageLoaderHandler = (Result<UIImage, APIError>) -> Void
    
    func loadImage(_ urlString: String, _ completion: @escaping ImageLoaderHandler) -> UUID? {
        if let image = loadedImages.object(forKey: NSString(string: urlString)) {
            completion(.success(image))
            return nil
        }
        
        let uuid = UUID()
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidUrl))
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            defer { self.runningRequests.removeValue(forKey: uuid)}
            
            if let error = error {
                if (error as NSError).code == NSURLErrorCancelled {
                    return
                } else {
                    completion(.failure(.otherError(error)))
                }
            }
            
            guard let HTTPResponse = response as? HTTPURLResponse,
                200 ..< 300 ~= HTTPResponse.statusCode else {
                    completion(.failure(.badResponse))
                    return
            }
            
            if let data = data, let image = UIImage(data: data) {
                self.loadedImages.setObject(image, forKey: NSString(string: urlString))
                completion(.success(image))
            } else {
                completion(.failure(.badData))
            }
        }
        task.resume()
        runningRequests[uuid] = task
        return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
}
