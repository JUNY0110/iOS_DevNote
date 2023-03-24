//
//  DViewController.swift
//  Coordinator
//
//  Created by 지준용 on 2023/03/23.
//

import UIKit
import SnapKit

protocol DViewControllerDelegate {
    func popToCViewController()
    func dismissViewController()
}

class DViewController: BaseViewController {
    
    // MARK: - Property
    
    var delegate: DViewControllerDelegate?
    
    // MARK: - View
    
    private let endingButton: UIButton = {
        $0.configuration?.title = "Dismiss"
        $0.configuration?.attributedTitle?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        $0.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return $0
    }(UIButton(configuration: .filled()))
    
    // MARK: - Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        navigationItem.title = "D"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapBackButton))
    }
    
    override func layout() {
        view.addSubview(endingButton)
        endingButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    @objc func didTapBackButton() {
        delegate?.popToCViewController()
    }
    
    @objc func didTapCloseButton() {
        delegate?.dismissViewController()
    }
}
