//
//  CCoordinator.swift
//  CoordinatorTest
//
//  Created by 지준용 on 2023/03/23.
//

import UIKit

protocol CCoordinatorDelegate {
    func dismissViewController()
}

class CCoordinator: BaseCoordinator, CViewControllerDelegate, DViewControllerDelegate, DCoordinatorDelegate {

    // MARK: - Property

    var delegate: CCoordinatorDelegate?
    var cVC: CViewController?
    lazy var rootViewController = UINavigationController(rootViewController: self.cVC!)
    
    // MARK: - Start
    
    override func start() {
        cVC = CViewController()
        cVC!.delegate = self
        rootViewController.modalPresentationStyle = .fullScreen
        
        navigationController.present(rootViewController, animated: true)
    }
    
    // MARK: - Push
    
    func pushToDViewController() {
        let coordinator = DCoordinator(navigationController: rootViewController)
        coordinator.delegate = self
        coordinator.start()
        childCoordinators.append(coordinator)
    }

    // MARK: - Pop
    
    func popToCViewController() {
        rootViewController.popViewController(animated: true)
    }
    
    // MARK: - Dismiss
    
    func dismissViewController() {
        delegate?.dismissViewController()
    }
}
