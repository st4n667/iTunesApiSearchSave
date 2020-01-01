//
//  SavedSongsDiffableDataSource.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 29/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import UIKit

class SavedSongsDiffableDataSource: UICollectionViewDiffableDataSource<String, Song.Diffable> {

    typealias HeaderConfigurator = (IndexPath) -> String
    private let headerConfigurator: HeaderConfigurator
    
    init(collectionView: UICollectionView,
         cellProvider: @escaping UICollectionViewDiffableDataSource<String, Song.Diffable>.CellProvider,
         headerConfigurator: @escaping HeaderConfigurator) {
        
        self.headerConfigurator = headerConfigurator
        super.init(collectionView: collectionView, cellProvider: cellProvider)
    }
    
    deinit {
        print(String(describing: type(of: self)), #function)
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SavedSongsCollectionSectionHeaderView.reuseIdentifier, for: indexPath) as? SavedSongsCollectionSectionHeaderView else {
            fatalError("Identifier or class not registered with this collection view")
        }
        header.label.text = headerConfigurator(indexPath)
        return header
    }
    
}
