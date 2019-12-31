//
//  SongDetailsViewController.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 22/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import UIKit
import CoreData

class SongDetailsViewController: UIViewController {
    
    private let viewModel: SongDetailsViewControllerViewModel
    private let songDetailsView: SongDetailsView
    var saveBarButtonItem: UIBarButtonItem!
    
    init(viewModel: SongDetailsViewControllerViewModel) {
        self.viewModel = viewModel
        songDetailsView = SongDetailsView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        setupNavigationItems()
        viewModel.isSaveButtonEnabled.bind { [weak self] isEnabled in
            self?.saveBarButtonItem.isEnabled = isEnabled
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    deinit {
        print(String(describing: type(of: self)), #function)
    }

    override func loadView() {
        view = songDetailsView
        view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        songDetailsView.artworkImageView.loadImage(with: viewModel.song.artworkUrl, sizeClass: .x600)
        songDetailsView.songTitleLabel.text = viewModel.song.trackName
        songDetailsView.songAlbumLabel.text = viewModel.song.collectionName
        songDetailsView.songArtistLabel.text = viewModel.song.artistName
        songDetailsView.songGenreLabel.text = viewModel.song.primaryGenreName
        songDetailsView.songCountryLabel.text = viewModel.song.country
    }
    
    private func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.down"),
            style: .plain, target: self,
            action: #selector(handleTapDismiss))
        saveBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "folder.badge.plus"),
            style: .plain, target: self,
            action: #selector(handleSave))
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }

    
    @objc private func handleTapDismiss() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func handleSave() {
        let image = self.songDetailsView.artworkImageView.image
        viewModel.save(withImage: image)
        self.dismiss(animated: true, completion: nil)
    }

}
