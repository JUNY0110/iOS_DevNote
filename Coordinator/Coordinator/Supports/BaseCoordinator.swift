//
//  BaseCoordinator.swift
//  Coordinator
//
//  Created by 지준용 on 2023/03/23.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}

class BaseCoordinator: Coordinator {
    
    // MARK: - Property
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Start

    func start() {}
}
