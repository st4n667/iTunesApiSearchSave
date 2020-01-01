//
//  SongDetailsView.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 28/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import UIKit

class SongDetailsView: UIView {
    
    init(viewModel: SongDetailsViewControllerViewModel) {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(String(describing: type(of: self)), #function)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        addSubview(artworkImageView)
        artworkImageView.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: nil,
            bottom: nil,
            trailing: nil,
            size: .init(width: frame.width, height: frame.width))
        artworkImageView.centerXToSuperview()

        titleLabel.constrainWidth(65)
        albumLabel.constrainWidth(65)
        artistLabel.constrainWidth(65)
        genreLabel.constrainWidth(65)
        countryLabel.constrainWidth(65)
        
        addSubview(titleStack)
        addSubview(albumStack)
        addSubview(artistStack)
        addSubview(genreStack)
        addSubview(countryStack)

        let padding = UIEdgeInsets(top: 32, left: 16, bottom: 0, right: 16)
        
        titleStack.anchor(top: artworkImageView.bottomAnchor,
                          leading: leadingAnchor,
                          bottom: nil,
                          trailing: trailingAnchor,
                          padding: padding)
        albumStack.anchor(top: titleStack.bottomAnchor,
                          leading: leadingAnchor,
                          bottom: nil,
                          trailing: trailingAnchor,
                          padding: padding)
        artistStack.anchor(top: albumStack.bottomAnchor,
                           leading: leadingAnchor,
                           bottom: nil,
                           trailing: trailingAnchor,
                           padding: padding)
        genreStack.anchor(top: artistStack.bottomAnchor,
                          leading: leadingAnchor,
                          bottom: nil,
                          trailing: trailingAnchor,
                          padding: padding)
        countryStack.anchor(top: genreStack.bottomAnchor,
                            leading: leadingAnchor,
                            bottom: nil,
                            trailing: trailingAnchor,
                            padding: padding)
    }

    lazy var artworkImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    lazy var titleLabel = CustomLabel(text: "title", numberOfLines: 1, style: .small)
    lazy var songTitleLabel = CustomLabel(alignment: .left, numberOfLines: 2, style: .header)
    lazy var titleStack = UIStackView(arrangedSubviews: [self.titleLabel, self.songTitleLabel])
    
    lazy var albumLabel = CustomLabel(text: "album", numberOfLines: 1, style: .small)
    lazy var songAlbumLabel = CustomLabel(numberOfLines: 2, style: .header)
    lazy var albumStack = UIStackView(arrangedSubviews: [self.albumLabel, self.songAlbumLabel])
    
    lazy var artistLabel = CustomLabel(text: "artist", numberOfLines: 1, style: .small)
    lazy var songArtistLabel = CustomLabel(numberOfLines: 2, style: .header)
    lazy var artistStack = UIStackView(arrangedSubviews: [self.artistLabel, self.songArtistLabel])
    
    lazy var genreLabel = CustomLabel(text: "genre", numberOfLines: 1, style: .small)
    lazy var songGenreLabel = CustomLabel(numberOfLines: 2, style: .header)
    lazy var genreStack = UIStackView(arrangedSubviews: [self.genreLabel, self.songGenreLabel])
    
    lazy var countryLabel = CustomLabel(text: "country", numberOfLines: 1, style: .small)
    lazy var songCountryLabel = CustomLabel(numberOfLines: 2, style: .header)
    lazy var countryStack = UIStackView(arrangedSubviews: [self.countryLabel, self.songCountryLabel])

    
}
