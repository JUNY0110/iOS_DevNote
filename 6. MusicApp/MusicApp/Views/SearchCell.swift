//
//  SearchCell.swift
//  MusicApp
//
//  Created by 지준용 on 2023/08/13.
//

import UIKit
import SkeletonView

final class SearchCell: UICollectionViewCell {
    
    // MARK: - Property
    
    static let identifier = "searchCell"
    var imageURL: String? {
        didSet {
            loadImage()
        }
    }
    
    // MARK: - View
    
    private let albumImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    // MARK: - Init
    
    @available(*, unavailable)
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
        
        albumImage.isSkeletonable = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func layout() {
        addSubview(albumImage)
        albumImage.frame = bounds
    }
    
    // MARK: - Method
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.albumImage.image = nil
    }
    
    private func loadImage() {
        let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .bottomRightTopLeft)
        self.albumImage.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.lightGray, .gray]), animation: skeletonAnimation)
        
        guard let urlString = imageURL,
              let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            guard urlString == url.absoluteString else { return }
            
            DispatchQueue.main.async {
                
                self.albumImage.image = UIImage(data: data)
                self.albumImage.stopSkeletonAnimation()
                self.albumImage.hideSkeleton(reloadDataAfter: true)
            }
        }
    }
}
