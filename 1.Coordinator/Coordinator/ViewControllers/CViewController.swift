//
//  CViewController.swift
//  Coordinator
//
//  Created by 지준용 on 2023/03/23.
//

import UIKit
import SnapKit

protocol CViewControllerDelegate: AnyObject {
    func pushToDViewController()
    func dismissViewController()
}

class CViewController: BaseViewController {
    
    // MARK: - Property
    
    weak var delegate: CViewControllerDelegate?
    
    // MARK: - View
    
    private let coordinatorButton: UIButton = {
        $0.configuration?.title = "Push"
        $0.configuration?.attributedTitle?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        $0.addTarget(self, action: #selector(didTapPushButton), for: .touchUpInside)
        return $0
    }(UIButton(configuration: .filled()))

    // MARK: - Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapCloseButton))
    }
    
    override func layout() {
        navigationItem.title = "C"
        
        view.addSubview(coordinatorButton)
        coordinatorButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    @objc func didTapPushButton() {
        delegate?.pushToDViewController()
    }
    
    
    @objc func didTapCloseButton() {
        delegate?.dismissViewController()
    }
}
