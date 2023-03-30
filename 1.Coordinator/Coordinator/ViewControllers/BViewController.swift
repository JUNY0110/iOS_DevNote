//
//  ZeroViewController.swift
//  Coordinator
//
//  Created by 지준용 on 2023/03/23.
//

import UIKit
import SnapKit

protocol BViewControllerDelegate: AnyObject {
    func presentCViewController()
    func popToAViewController()
}

class BViewController: BaseViewController {
    
    // MARK: - Property
    
    weak var delegate: BViewControllerDelegate?
    
    // MARK: - View
    
    private let coordinatorButton: UIButton = {
        $0.configuration?.title = "Present"
        $0.configuration?.attributedTitle?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        $0.addTarget(self, action: #selector(didTapPresentButton), for: .touchUpInside)
        return $0
    }(UIButton(configuration: .filled()))

    // MARK: - Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        navigationItem.title = "B"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(didTapBackButton))
    }
    
    override func layout() {
        view.addSubview(coordinatorButton)
        coordinatorButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    @objc func didTapPresentButton() {
        delegate?.presentCViewController()
    }
    
    @objc func didTapBackButton() {
        delegate?.popToAViewController()
    }
}
