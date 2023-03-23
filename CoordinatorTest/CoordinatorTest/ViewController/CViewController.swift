//
//  CViewController.swift
//  CoordinatorTest
//
//  Created by 지준용 on 2023/03/23.
//

import UIKit
import SnapKit

protocol CViewControllerDelegate {
    func pushToDViewController()
    func dismissViewController()
}

class CViewController: BaseViewController {
    
    // MARK: - Property
    
    var delegate: CViewControllerDelegate?
    
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapCloseButton))
    }
    
    // MARK: - Method
    
    override func layout() {
        navigationItem.title = "C"
        
        view.addSubview(coordinatorButton)
        coordinatorButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Button

    @objc func didTapPushButton() {
        delegate?.pushToDViewController()
    }
    
    
    @objc func didTapCloseButton() {
        delegate?.dismissViewController()
    }
}
