//
//  ZeroViewController.swift
//  CoordinatorTest
//
//  Created by 지준용 on 2023/03/23.
//

import UIKit
import SnapKit

protocol BViewControllerDelegate {
    func presentCViewController()
    func popToAViewController()
}

class BViewController: BaseViewController {
    
    // MARK: - Property
    
    var delegate: BViewControllerDelegate?
    
    // MARK: - View
    
    private let coordinatorButton: UIButton = {
        $0.configuration?.title = "Present"
        $0.configuration?.attributedTitle?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        $0.addTarget(self, action: #selector(didTapPresentButton), for: .touchUpInside)
        return $0
    }(UIButton(configuration: .filled()))

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "B"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(didTapBackButton))
    }

    // MARK: - Method

    override func layout() {
        view.addSubview(coordinatorButton)
        coordinatorButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Button
    
    @objc func didTapPresentButton() {
        delegate?.presentCViewController()
    }
    
    @objc func didTapBackButton() {
        delegate?.popToAViewController()
    }
}
