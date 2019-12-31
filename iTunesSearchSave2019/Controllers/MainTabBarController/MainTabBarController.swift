//
//  MainTabBarController.swift
//  iTunesSearchSave2019
//
//  Created by Staszek Stryjewski on 18/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import UIKit
import CoreData


class MainTabBarViewModel {
    
    typealias ItemDecorator = (title: String, image: String)
    
    private let itemDecorators: [ItemDecorator] = [
        ("Search", "magnifyingglass"),
        ("Saved", "star")
    ]
    private let itemsTabBarFactory: ItemsTabBarFactory

    var savedSongsCount: Observable<Int> = Observable(0)

    init(itemsTabBarFactory: ItemsTabBarFactory) {
        self.itemsTabBarFactory = itemsTabBarFactory
    }

    func makeTabBarItems() -> [UIViewController] {
        [itemsTabBarFactory.makeSearchViewController(), makeAndBindSavedController()]
            .enumerated()
            .map {
                let safeDecorator: ItemDecorator = $0 < itemDecorators.count ? itemDecorators[$0] : ("" , "xmark")
                return $1.embedInNavigationController(withTitle: safeDecorator.title, andImage: safeDecorator.image)
        }
    }

    private func makeAndBindSavedController() -> SavedController {
        let saved = itemsTabBarFactory.makeSavedController()
        saved.bindObserverToSongCount(&savedSongsCount)
        return saved
    }


}
