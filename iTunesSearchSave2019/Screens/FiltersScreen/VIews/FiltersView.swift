//
//  FiltersView.swift
//  iTunesSearchSave2019
//
//  Created by Staszek Stryjewski on 31/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import UIKit

protocol FiltersViewModelDelgate: AnyObject {
    func filterViewModel(_ filterViewModel: FiltersControllerViewModel, didChangeFilter filter: Filter)
}

class FiltersView: UIView {
    
    private let viewModel: FiltersControllerViewModel
    
    init(viewModel: FiltersControllerViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        [sortByTitleAZButton,
         sortByTitleZAButton,
         sortByArtistAZButton,
         sortByArtistZAButton,
         groupByArtistButton,
         groupByGenreButton]
            .forEach { $0.addTarget(viewModel, action: #selector(viewModel.handleButtonTap), for: .touchUpInside) }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        let sortByTitleStack = UIStackView(arrangedSubviews: [sortByTitleAZButton, sortByTitleZAButton])
        let sortByArtistStack = UIStackView(arrangedSubviews: [sortByArtistAZButton, sortByArtistZAButton])
        let groupByStack = UIStackView(arrangedSubviews: [groupByGenreButton, groupByArtistButton])
        let stacks = [sortByTitleStack, sortByArtistStack, groupByStack]
        stacks.forEach {
            $0.distribution = .fillEqually
            $0.spacing = 8
        }
        let overallStack = UIStackView(arrangedSubviews: stacks)
        overallStack.axis = .vertical
        addSubview(overallStack)
        let spacing: CGFloat = 16
        overallStack.spacing = spacing
        overallStack.layoutMargins = .init(top: spacing, left: spacing, bottom: 0, right: spacing)
        overallStack.isLayoutMarginsRelativeArrangement = true
        overallStack.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
    }
    
    lazy var sortByTitleAZButton = UIButton(text: "Sort by Title A-Z", tag: 1001)
    lazy var sortByTitleZAButton = UIButton(text: "Sort by Title Z-A", tag: 1002)
    lazy var sortByArtistAZButton = UIButton(text: "Sort by Artist A-Z", tag: 2001)
    lazy var sortByArtistZAButton = UIButton(text: "Sort by Artist Z-A", tag: 2002)
    lazy var groupByArtistButton = UIButton(text: "Group by Artist", tag: 3001)
    lazy var groupByGenreButton = UIButton(text: "Group by Genre", tag: 4001)
}
