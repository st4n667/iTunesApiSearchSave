//
//  SavedSongsCollectionSectionHeaderView.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 29/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import UIKit

class SavedSongsCollectionSectionHeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = "sectionHeaderID"
    lazy var label = CustomLabel(alignment: .center,
                                 numberOfLines: 1,
                                 style: .header)
      
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        addSubview(label)
        label.centerInSuperview()
        label.minimumScaleFactor = 0.7
        label.lineBreakMode = .byTruncatingTail
    }
  
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    deinit {
        print(String(describing: type(of: self)), #function)
    }
}
