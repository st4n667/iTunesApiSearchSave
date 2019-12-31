//
//  ImageSizeClass.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 29/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import Foundation

enum ImageSizeClass {
    case x160
    case x250
    case x600
    
    var sizeString: String {
        switch self {
        case .x160:
            return "160x160"
        case .x250:
            return "250x250"
        case .x600:
            return"600x600"
        }
    }
}


/*
 Available sizes in iTunes API.
 30 × 30.
 40 × 40.
 60 × 60.
 80 × 80.
 100 × 100.
 110 × 110.
 130 × 130.
 150 × 150.
 160 × 160.
 170 × 170.
 200 × 200.
 220 × 220.
 230 × 230.
 250 × 250.
 340 × 340.
 400 × 400.
 440 × 440.
 450 × 450.
 460 × 460.
 600 × 600.
 1 200 × 1 200.
 1 400 × 1 400.
 */
