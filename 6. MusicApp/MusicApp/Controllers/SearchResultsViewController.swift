//
//  SearchResultsViewController.swift
//  MusicApp
//
//  Created by 지준용 on 2023/08/12.
//

import UIKit

final class SearchResultsViewController: UIViewController {

    // MARK: - Property
    
    // 검색 결과 데이터 소스
    private let networkManager = NetworkManager.shared
    private var musicArrays = [Music]()
    var searchTerm: String? {
        didSet {
            fetchMusicData(searchTerm)
        }
    }

    // MARK: - View
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        
        $0.collectionViewLayout = flowLayout
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        layout()
    }

    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchCell.self,
                                forCellWithReuseIdentifier: SearchCell.identifier)
    }
    
    private func layout() {
        view.addSubview(collectionView)
        collectionView.frame = view.safeAreaLayoutGuide.layoutFrame
    }
    
    // MARK: - Method
    
    private func fetchMusicData(_ searchTerm: String? = "Maroon") {
        self.musicArrays = []
        
        networkManager.fetchMusicData(searchTerm: searchTerm!) { result in
            switch result {
            case .success(let musics):
                self.musicArrays = musics
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error): print(error)
            }
        }
    }
}


extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicArrays.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.identifier, for: indexPath) as! SearchCell

        cell.imageURL = musicArrays[indexPath.row].imageURL
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width / 4 - 1
        let height = width
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}
