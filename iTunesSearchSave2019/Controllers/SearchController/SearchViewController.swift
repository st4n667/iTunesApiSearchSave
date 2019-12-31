//
//  SearchViewController.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 16/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var searchController: UISearchController!
    private var viewModel: SearchViewControllerViewModelType
    private var datasource: UITableViewDiffableDataSource<Int, JsonSong.Diffable>!
    private var songDetailsFactory: DetailScreenFactory
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Lifecycle
    init(viewModel: SearchViewControllerViewModelType, songDetailsFactory: DetailScreenFactory) {
        self.songDetailsFactory = songDetailsFactory
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        datasource = configureDatasource()
        subscribeToViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    deinit {
        print(String(describing: type(of: self)), #function)
    }
    
    override func loadView() {
        view = tv
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        view.addSubview(activityIndicator)
    }
    
    private func subscribeToViewModel() {
        viewModel.onFeedUpdate = {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            self.updateSnapshot()
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if let cell = tv.visibleCells.last,
            let indexPath = tv.indexPath(for: cell),
            indexPath.row == viewModel.songs.count - 1 {
            self.viewModel.paginate()
        }
    }
    
    // MARK: Configure diffable datasource
    private func configureDatasource() -> UITableViewDiffableDataSource<Int, JsonSong.Diffable> {
        let datasource = UITableViewDiffableDataSource<Int, JsonSong.Diffable>(tableView: self.tv) { [unowned self]
            tableView, indexPath, itemIdentifier in
            let song = self.viewModel.getItemAt(indexPath)
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SongSearchResultCell.reuseIdentifier, for: indexPath) as? SongSearchResultCell else {
                fatalError("Identifier or class not registered with this table view")
            }
            
            cell.titleLabel.text = song.trackName
            cell.artistLabel.text = song.artistName
            cell.albumLabel.text = song.collectionName
            cell.coverImageView.loadImage(with: song.artworkUrl, sizeClass: .x160)
            
            return cell
        }
        return datasource
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, JsonSong.Diffable>()
        snapshot.appendSections([0])
        let songs = self.viewModel.songs.map(JsonSong.Diffable.init)
        snapshot.appendItems(songs, toSection: 0)
        DispatchQueue.main.async {
            self.datasource.apply(snapshot, animatingDifferences: false, completion: nil)
        }
    }
    
    lazy var tv: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(SongSearchResultCell.self, forCellReuseIdentifier: SongSearchResultCell.reuseIdentifier)
        tv.dataSource = self.datasource
        tv.delegate = self
        tv.rowHeight = 100
        tv.keyboardDismissMode = .interactive
        tv.tableFooterView = UIView()
        return tv
    }()
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = viewModel.songs[indexPath.row]
        let songDetailController = songDetailsFactory.makeSongDetailsViewController(song: song)
        let nav = songDetailController.embedInNavigationController(withTitle: "", andImage: "")
        present(nav, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text!.replacingOccurrences(of: " ", with: "+")
        self.activityIndicator.startAnimating()
        viewModel.makeRequestWithQuery(query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.clearResults()
    }
    
}
