//
//  SavedController.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 17/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import UIKit
import CoreData

class SavedController: UIViewController {
    
    private var datasource: SavedSongsDiffableDataSource!
    private var fetchedResultsController: NSFetchedResultsController<Song>!
    private var fetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
    
    private let viewModel: SavedControllerViewModel
    private let filterControllerFactory: FilterScreenFactory
    private let coreDataService: CoreDataService
    
    init(viewModel: SavedControllerViewModel, coreDataService: CoreDataService, filterControllerFactory: FilterScreenFactory) {
        self.filterControllerFactory = filterControllerFactory
        self.viewModel = viewModel
        self.coreDataService = coreDataService
        super.init(nibName: nil, bundle: nil)
        configureFetchRequest()
        fetchedResultsController = configureFetchedResultsController(withSectionKeyPath: nil)
        datasource = configureDatasource()
        registerCells()
        fetch()
    }

    func bindObserverToSongCount(_ observable: inout Observable<Int>) {
        observable = viewModel.savedSongsCount
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    deinit {
        print(String(describing: type(of: self)), #function)
    }
    
    override func loadView() {
        view = cv
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarItems()
    }
    
    private func configureFetchRequest(withPredicate predicate: NSPredicate? = nil,
                                       sortDescriptors: [NSSortDescriptor] = []) {
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
    }

    func configureFetchedResultsController(withSectionKeyPath keyPath: String?) -> NSFetchedResultsController<Song> {
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataService.context,
            sectionNameKeyPath: keyPath,// #keyPath(Song.artistName),
            cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }

    func updateTabBarBadge() {
        viewModel.updateBadgeData()
    }
    
    private func configureDatasource() -> SavedSongsDiffableDataSource {
        let datasource = SavedSongsDiffableDataSource(collectionView: self.cv, cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedSongCell.reuseIdentifier, for: indexPath) as? SavedSongCell else {
                fatalError("cannot dequeue cell")
            }
            
            let song = self.fetchedResultsController.object(at: indexPath)
            cell.titleLabel.text = song.trackName ?? ""
            cell.artistLabel.text = song.artistName ?? ""
            cell.albumLabel.text = song.collectionName ?? ""
            
            do {
                let endpoint = try DiskEndpoint.imageDocuments(filename: song.imageFilename ?? "")
                try cell.coverImageView.image = DiskService.loadImageWithEndpoint(endpoint)
            } catch {
                print(error)
            }
            
            return cell
        }, headerConfigurator: { indexPath in
            let sectionInfo = self.fetchedResultsController.sections?[indexPath.section]
            return(sectionInfo?.name ?? "")
            
        })
        return datasource
    }
    
    private func fetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
    }
    
    private func registerCells() {
        cv.register(SavedSongCell.self, forCellWithReuseIdentifier: SavedSongCell.reuseIdentifier)
        cv.register(SavedSongsCollectionSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SavedSongsCollectionSectionHeaderView.reuseIdentifier)
    }

    lazy var cv: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self.datasource
        cv.delegate = self
        cv.backgroundColor = .white
        return cv
    }()

}

// MARK: - UICollectionViewDelegate
extension SavedController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        viewModel.delete(item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let sectionsCount = fetchedResultsController.sections?.count ?? 0
        let height: CGFloat = sectionsCount <= 1 ? 0 : 40
        return CGSize.init(width: collectionView.frame.width, height: height)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SavedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 24) / 2 - 1
        return CGSize.init(width: width, height: width * 1.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension SavedController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        
        var diff = NSDiffableDataSourceSnapshot<String, Song.Diffable>()
        snapshot.sectionIdentifiers.forEach { section in
            diff.appendSections([section as! String])
            let items = snapshot.itemIdentifiersInSection(withIdentifier: section)
                .map { (objectId: Any) -> Song.Diffable in
                    let oid =  objectId as! NSManagedObjectID
                    let song = controller.managedObjectContext.object(with: oid) as! Song
                    return Song.Diffable.init(song: song)
            }
            diff.appendItems(items, toSection: section as? String)
        }
        datasource.apply(diff)
        updateTabBarBadge()
    }

}

// MARK: - UIBarButtonItems + handlers
extension SavedController {
    private func setupNavBarItems() {
        let deleteItem = UIBarButtonItem(
            image: UIImage(systemName: "text.badge.xmark"),
            style: .done,
            target: self, action: #selector(handleDelete))
        let filterItem = UIBarButtonItem(
            image: UIImage(systemName: "slider.horizontal.3"),
            style: .plain,
            target: self,
            action: #selector(handleFilter))
        navigationItem.rightBarButtonItem = filterItem
        navigationItem.leftBarButtonItems = [deleteItem]
    }
    
    @objc private func handleFilter() {
        let filtersController = filterControllerFactory.makeFiltersController()
        filtersController.delegate = self
        let nav = filtersController.embedInNavigationController(withTitle: "", andImage: "")
        present(nav, animated: true, completion: nil)
    }
    
    @objc private func handleSort() {
        fetchedResultsController = configureFetchedResultsController(withSectionKeyPath: #keyPath(Song.primaryGenreName))
        fetch()
    }
    
    @objc private func handleDelete() {
        print("delete")
        let request = NSBatchDeleteRequest(fetchRequest: Song.fetchRequest())
        try! coreDataService.context.execute(request)
        fetch()
    }
}

extension SavedController: FiltersViewControllerDelegate {
    func filtersViewController(_ controller: FiltersViewContoller, didApplyFilter filter: Filter?) {
        guard let filter = filter else {
            fetchRequest.predicate = nil
            fetchRequest.sortDescriptors = []
            fetchedResultsController = configureFetchedResultsController(withSectionKeyPath: nil)
            fetch()
            return
        }
        filter.applyToRequest(&fetchRequest)
        
        if let groupingPath = filter.getGroupingKeyPath() {
            fetchedResultsController = configureFetchedResultsController(withSectionKeyPath: groupingPath)
        }
        fetch()
    }
    
}
