//
//  UIImageView+loadImage.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 26/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func loadImage(with urlString: String, sizeClass: ImageSizeClass) {
        UIImageLoader.loader.load(urlString, for: self, sizeClass: sizeClass)
    }
    
    func cancelImageLoad() {
        UIImageLoader.loader.cancel(for: self)
        
    }
}
