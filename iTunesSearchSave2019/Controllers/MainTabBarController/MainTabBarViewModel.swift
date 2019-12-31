//
//  MainTabBarViewModel.swift
//  iTunesSearchSave2019
//
//  Created by Staszek Stryjewski on 31/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    private let viewModel: MainTabBarViewModel
    
    init(viewModel: MainTabBarViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewModel.makeTabBarItems()
        subscribeToSavedCount()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    deinit {
        print(String(describing: type(of: self)), #function)
    }
    
    private func subscribeToSavedCount() {
        viewModel.savedSongsCount.bind([.initial, .new]) { [weak self] count in
            self?.viewControllers?.last?.tabBarItem.badgeValue  = "\(count)"
        }
    }
    
}
