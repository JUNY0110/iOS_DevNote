//
//  TestCollectionViewCell.swift
//  Delegate
//
//  Created by 지준용 on 2023/03/22.
//

import UIKit
import SnapKit

class TestCollectionCell: UICollectionViewCell {

    static let identifier = "testCollectionCell"

    private let colorView: UIView = {
        $0.backgroundColor = .gray
        return $0
    }(UIView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(colorView)
        colorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
