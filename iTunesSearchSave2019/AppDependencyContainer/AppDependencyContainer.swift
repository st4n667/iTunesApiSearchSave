//
//  AppDependencyContainer.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 22/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import Foundation

struct AppDependencyContainer {

    let dataLoader: DataLoader
    let coreDataService: CoreDataService

    init() {
        dataLoader = DataLoader()
        coreDataService = CoreDataService(modelName: "DataModel")
    }

    func makeMainTabController() -> MainTabBarController {
        MainTabBarController(viewModel: makeMainTabBarViewModel())
    }

    func makeMainTabBarViewModel() -> MainTabBarViewModel {
        MainTabBarViewModel(itemsTabBarFactory: self)
    }

}

protocol ItemsTabBarFactory {
    func makeSearchViewController() -> SearchViewController
    func makeSavedController() -> SavedController
}

extension AppDependencyContainer: ItemsTabBarFactory {
    func makeSearchViewController() -> SearchViewController {
        SearchViewController(viewModel: makeSearchViewControllerViewModel(),
                             songDetailsFactory: self)
    }

    func makeSearchViewControllerViewModel() -> SearchViewControllerViewModel {
        SearchViewControllerViewModel(networking: dataLoader)
    }
    
    func makeSavedViewControllerViewModel() -> SavedControllerViewModel {
        SavedControllerViewModel(coreDataService: coreDataService)
    }

    func makeSavedController() -> SavedController {
        SavedController(viewModel: makeSavedViewControllerViewModel(),
                        coreDataService: coreDataService,
                        filterControllerFactory: self)
    }
}

protocol DetailScreenFactory {
    func makeSongDetailsViewController(song: JsonSong) -> SongDetailsViewController
}

extension AppDependencyContainer: DetailScreenFactory {
    func makeSongDetailsViewModel(song: JsonSong) -> SongDetailsViewControllerViewModel {
        return SongDetailsViewControllerViewModel(song: song,
                                                  coreDataService: coreDataService)
    }

    func makeSongDetailsViewController(song: JsonSong) -> SongDetailsViewController {
        return SongDetailsViewController(viewModel: makeSongDetailsViewModel(song: song))
    }
}

protocol FilterScreenFactory {
    func makeFiltersController() -> FiltersViewContoller
}

extension AppDependencyContainer: FilterScreenFactory {
    func makeFiltersControllerViewModel() -> FiltersControllerViewModel {
        return FiltersControllerViewModel(coreDataService: coreDataService)
    }
    func makeFiltersController() -> FiltersViewContoller {
        return FiltersViewContoller(viewModel: makeFiltersControllerViewModel())
    }
}
