//
//  UIImageLoader.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 26/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import UIKit

class UIImageLoader {
    static let loader = UIImageLoader()
    
    private let imageLoader = ImageLoader()
    private var uuidMap = [UIImageView: UUID]()
    
    private init() {}
    
    func load(_ urlString: String, for imageView: UIImageView, sizeClass: ImageSizeClass) {
        let urlStringWithSize = urlString.replacingOccurrences(of: "100x100", with: sizeClass.sizeString)
        let token = self.imageLoader.loadImage(urlStringWithSize) { res in
            do {
                let image = try res.get()
                DispatchQueue.main.async {
                    imageView.image = image
                }
            } catch {
                print(error)
            }
        }

        if let token = token {
            uuidMap[imageView] = token
        }
    }
    
    func cancel(for imageView: UIImageView) {
        if let uuid = uuidMap[imageView] {
            imageLoader.cancelLoad(uuid)
            uuidMap.removeValue(forKey: imageView)
        }
    }
    
}
