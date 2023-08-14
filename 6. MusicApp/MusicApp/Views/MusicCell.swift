//
//  MusicCell.swift
//  MusicApp
//
//  Created by 지준용 on 2023/08/11.
//

import UIKit
import SkeletonView

final class MusicCell: UITableViewCell {
    
    // MARK: - Property
    
    static let identifier = "musicCell"
    var imageURL: String? {
        didSet {
            loadImage()
        }
    }
    
    // MARK: - View
    
    private let trackImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private let vStackView: UIStackView = {
        $0.axis = .vertical
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private let songTitle: UILabel = {
        $0.text = "노래제목"
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let artistName: UILabel = {
        $0.text = "음악장르"
        $0.textColor = .darkGray
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let albumName: UILabel = {
        $0.text = "앨범이름"
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 3
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let releaseDate: UILabel = {
        $0.text = "2023-08-12"
        $0.textColor = .darkGray
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    // MARK: - Init
    
    @available(*, unavailable)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        trackImageView.isSkeletonable =  true
        
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    // MARK: - Layout
    
    private func layout() {
        contentView.addSubview(trackImageView)
        trackImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        trackImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        trackImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        trackImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        trackImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        contentView.addSubview(vStackView)
        vStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        vStackView.leftAnchor.constraint(equalTo: trackImageView.rightAnchor, constant: 20).isActive = true
        vStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        vStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        
        vStackView.addArrangedSubview(songTitle)
        vStackView.addArrangedSubview(artistName)
        vStackView.addArrangedSubview(albumName)
        vStackView.addArrangedSubview(releaseDate)
    }
    
    // MARK: - Configure
    
    func configure(_ imageURL: String?, _ songTitle: String?,
                   _ artistName: String?, _ albumName: String?,
                   _ releaseDate: String?) {
        self.imageURL = imageURL
        self.songTitle.text = songTitle
        self.artistName.text = artistName
        self.albumName.text = albumName
        self.releaseDate.text = releaseDate
    }
    
    // MARK: - Method
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.trackImageView.image = nil
    }

    private func loadImage() {
        let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .bottomRightTopLeft)
        trackImageView.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.lightGray, .gray]), animation: skeletonAnimation)
        
        guard let urlString = imageURL,
              let url = URL(string: urlString) else { return }

        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                guard urlString == url.absoluteString else { return }
                
                DispatchQueue.main.async {
                    self.trackImageView.image = UIImage(data: data)
                    self.trackImageView.stopSkeletonAnimation()
                    self.trackImageView.hideSkeleton()
                }
            } catch {
                print("에러발생")
            }
        }
    }
}
