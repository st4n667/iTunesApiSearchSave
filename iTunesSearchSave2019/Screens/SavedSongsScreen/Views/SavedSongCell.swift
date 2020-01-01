//
//  SavedCell.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 28/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import UIKit

class SavedSongCell: UICollectionViewCell {
    
    static let reuseIdentifier = "savedSongCellID"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    deinit {
        print(String(describing: type(of: self)), #function)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        clipsToBounds = true
        
        addSubview(coverImageView)
        coverImageView.centerXToSuperview()
        coverImageView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil,
                              padding: .init(top: 16, left: 0, bottom: 0, right: 0),
                              size: .init(width: 140, height: 140))

        titleLabel.textAlignment = .center
        artistLabel.textAlignment = .center
        albumLabel.textAlignment = .center
        
        titleLabel.numberOfLines = 2
        albumLabel.numberOfLines = 2
        artistLabel.numberOfLines = 1
        
        titleLabel.lineBreakMode = .byClipping
        albumLabel.lineBreakMode = .byClipping
        artistLabel.lineBreakMode = .byClipping
        
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            artistLabel,
            albumLabel
        ])
        stack.axis = .vertical
        stack.spacing = 4
        addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 8),
            stack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        layer.borderWidth = 0.5
        layer.cornerRadius = 8
        
    }

    // MARK: - UI Elements
    lazy var titleLabel = CustomLabel(text: "title", numberOfLines: 2, style: .header)
    lazy var artistLabel = CustomLabel(text: "artist", numberOfLines: 1, style: .regular)
    lazy var albumLabel = CustomLabel(text: "album", numberOfLines: 2, style: .light)
    
    lazy var coverImageView: UIImageView = {
        let iv = UIImageView(frame: .zero)
        iv.backgroundColor = .gray
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.lightGray.cgColor
        return iv
    }()
}
