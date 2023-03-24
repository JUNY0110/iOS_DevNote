//
//  AppCoordinator.swift
//  Coordinator
//
//  Created by 지준용 on 2023/03/23.
//

import UIKit

class AppCoordinator: BaseCoordinator, ACoordinatorDelegate, BCoordinatorDelegate, CCoordinatorDelegate {

    // MARK: - Start
    
    override func start() {
        showAViewController()
    }
    
    // MARK: - Show
    
    func showAViewController() {
        let coordinator = ACoordinator(navigationController: navigationController)
        coordinator.delegate = self
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    
    // MARK: - Push
    
    func pushToBViewController() {
        let coordinator = BCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    
    // MARK: - Present
    
    func presentCViewController() {
        let coordinator = CCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        coordinator.start()
        childCoordinators.append(coordinator)
    }

    // MARK: - Pop
    
    func popViewController() {
        navigationController.popViewController(animated: true)
        childCoordinators.removeLast()
    }
    
    
    // MARK: - Dismiss
    
    func dismissViewController() {
        navigationController.dismiss(animated: true)
        childCoordinators.removeLast()
    }
}
