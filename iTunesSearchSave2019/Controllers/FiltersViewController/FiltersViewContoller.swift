//
//  FiltersViewContoller.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 29/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import UIKit
import CoreData

protocol FiltersViewControllerDelegate: AnyObject {
    func filtersViewController(_ controller: FiltersViewContoller, didApplyFilter filter: Filter?)
    func filtersViewControllerDidCancel(_ controller: FiltersViewContoller)
}

extension FiltersViewControllerDelegate {
    func filtersViewControllerDidCancel(_ controller: FiltersViewContoller) {}
}

class FiltersViewContoller: UIViewController {
    
    lazy var filtersView = FiltersView(viewModel: viewModel)
    var resultsGroupingKeyPath: String?
    var sortDescriptor: NSSortDescriptor?
    weak var delegate: FiltersViewControllerDelegate?
    private let viewModel: FiltersControllerViewModel
    var currentFilter = Filter()
    
    init(viewModel: FiltersControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    deinit {
        print(String(describing: type(of: self)), #function)
    }
    
    fileprivate func setupNavBarItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
        let resetBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        let applyBarButtonItem = UIBarButtonItem(title: "Apply", style: .plain, target: self, action: #selector(handleApply))
        navigationItem.rightBarButtonItems = [applyBarButtonItem, resetBarButtonItem]
    }

    override func loadView() {
        view = filtersView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Apply filters"
        setupNavBarItems()
        viewModel.delegate = self
    }
    
    @objc func handleApply() {
        delegate?.filtersViewController(self, didApplyFilter: currentFilter)
        self.dismiss(animated: true)
    }
    
    @objc func handleReset() {
        self.currentFilter = Filter()
        delegate?.filtersViewController(self, didApplyFilter: nil)
        self.dismiss(animated: true)
    }
    
    @objc func handleCancel() {
        delegate?.filtersViewControllerDidCancel(self)
        self.dismiss(animated: true)
    }

}

extension FiltersViewContoller: FiltersViewModelDelgate {
    func filterViewModel(_ filterViewModel: FiltersControllerViewModel, didChangeFilter filter: Filter) {
        self.currentFilter = filter
    }
}
