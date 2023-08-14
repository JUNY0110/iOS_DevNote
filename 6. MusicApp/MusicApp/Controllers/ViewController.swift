//
//  ViewController.swift
//  MusicApp
//
//  Created by 지준용 on 2023/08/11.
//

import UIKit

final class ViewController: UIViewController {

    // MARK: - Property
    
    private let networkManager = NetworkManager.shared
    private var musicArrays = [Music]()
    
    // MARK: - View
    
    private let searchController = UISearchController(searchResultsController: SearchResultsViewController())
    
    private let tableView: UITableView = {
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITableView())

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
        layout()

        fetchMusicData()
    }
    
    // MARK: - Attribute

    private func attribute() {
        self.view.backgroundColor = .white
        
        setupSearchBar()
        setupTableView()
        configureRefreshControl()
    }
    
    private func setupSearchBar() {
        self.title = "Movie Search"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.searchController = searchController
        
        searchController.searchBar.placeholder = "Search Music"
        searchController.searchResultsUpdater = self
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MusicCell.self,
                           forCellReuseIdentifier: MusicCell.identifier)
    }
    
    // MARK: - Layout
    
    private func layout() {
        self.view.addSubview(tableView)
        tableView.frame = view.safeAreaLayoutGuide.layoutFrame
    }
    
    // MARK: - Method
    
    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self,
                                            action: #selector(handleRefreshControl),
                                            for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        tableView.reloadData()
        
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func fetchMusicData(_ searchTerm: String = "Maroon") {
        networkManager.fetchMusicData(searchTerm: searchTerm) { result in
            switch result {
            case .success(let musics):
                self.musicArrays = musics
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error): print(error)
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicArrays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MusicCell.identifier, for: indexPath) as! MusicCell

        cell.backgroundColor = .white
        
        let musicData = musicArrays[indexPath.row]
        cell.configure(musicData.imageURL,
                       musicData.songTitle,
                       musicData.artistName,
                       musicData.albumName,
                       musicData.releaseDateString)

        return cell
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let vc = searchController.searchResultsController as! SearchResultsViewController
        vc.searchTerm = searchController.searchBar.text ?? ""
    }
}
