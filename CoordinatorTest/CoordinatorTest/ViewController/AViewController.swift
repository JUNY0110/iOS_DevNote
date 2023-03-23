//
//  AViewController.swift
//  CoordinatorTest
//
//  Created by 지준용 on 2023/03/23.
//

import UIKit
import SnapKit

protocol AViewControllerDelegate {
    func pushToBViewController()
}

class AViewController: BaseViewController {
    
    // MARK: - Property
    
    var delegate: AViewControllerDelegate?
    
    // MARK: - View
    
    private let coordinatorButton: UIButton = {
        $0.configuration?.title = "Push"
        $0.configuration?.attributedTitle?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        $0.addTarget(self, action: #selector(didTapPushButton), for: .touchUpInside)
        return $0
    }(UIButton(configuration: .filled()))

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "A"
    }

    // MARK: - Method
    
    override func layout() {
        view.addSubview(coordinatorButton)
        coordinatorButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Button
    
    @objc func didTapPushButton() {
        delegate?.pushToBViewController()
    }
}