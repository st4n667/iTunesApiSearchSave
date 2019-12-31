//
//  UIViewController+embedInNavigationController.swift
//  iTunesSearchSave2019
//
//  Created by Staszek Stryjewski on 31/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import UIKit

extension UIViewController {
    func embedInNavigationController(withTitle title: String,andImage image: String) -> UINavigationController {
        self.navigationItem.title = title
        let navController = UINavigationController(rootViewController: self)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: "\(image).circle")
        navController.tabBarItem.selectedImage = UIImage(systemName: "\(image).circle.fill")
        return navController
    }
}
