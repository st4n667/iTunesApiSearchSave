//
//  SongCell.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 19/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import UIKit

class SongSearchResultCell: UITableViewCell {
    
    static let reuseIdentifier = "SongCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    deinit {
        print(String(describing: type(of: self)), #function)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        artistLabel.text = nil
        albumLabel.text = nil
        coverImageView.image = nil
        coverImageView.cancelImageLoad()
    }
    
    override func layoutSubviews() {
        let labelsStack = UIStackView(arrangedSubviews: [titleLabel, artistLabel, albumLabel])
        labelsStack.axis = .vertical
        labelsStack.spacing = 4
        let overallStack = UIStackView(arrangedSubviews: [coverImageView, labelsStack])
        overallStack.alignment = .center
        overallStack.distribution = .fill
        overallStack.spacing = 12
        coverImageView.constrainHeight(80)
        coverImageView.constrainWidth(80)
        addSubview(overallStack)
        overallStack.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
                            padding: .init(top: 4, left: 8, bottom: 4, right: 8)
        )
        addSubview(separatorView)
        separatorView.anchor(top: overallStack.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                             padding: .init(top: 0, left: 64, bottom: 0, right: 0))
    }
    
    // MARK: - UI Elements
    lazy var separatorView: UIView = {
        let v =  UIView(frame: .zero)
        v.backgroundColor = UIColor(white: 0.9, alpha: 0.9)
        v.constrainHeight(0.5)
        return v
    }()
    lazy var titleLabel = CustomLabel(numberOfLines: 2, style: .header)
    lazy var artistLabel = CustomLabel(numberOfLines: 1, style: .regular)
    lazy var albumLabel = CustomLabel(numberOfLines: 1, style: .bolded)

    lazy var coverImageView: UIImageView = {
        let iv = UIImageView(frame: .zero)
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        return iv
    }()
}
