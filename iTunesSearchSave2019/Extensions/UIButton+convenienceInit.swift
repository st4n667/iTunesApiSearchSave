//
//  UIButton+convenienceInit.swift
//  iTunesSearchSave2019
//
//  Created by Staszek Stryjewski on 31/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(text: String, tag: Int) {
        self.init(type: .system)
        self.setTitle(text, for: .normal)
        self.tag = tag
    }
}


