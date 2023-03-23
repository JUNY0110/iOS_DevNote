//
//  ACoordinator.swift
//  CoordinatorTest
//
//  Created by 지준용 on 2023/03/23.
//

protocol ACoordinatorDelegate {
    func pushToBViewController()
}

class ACoordinator: BaseCoordinator, AViewControllerDelegate   {

    // MARK: - Property

    var delegate: ACoordinatorDelegate?

    // MARK: - Start
    
    override func start() {
        let aVC = AViewController()
        aVC.delegate = self
        
        navigationController.viewControllers = [aVC]
    }
    
    // MARK: - Push
    
    func pushToBViewController() {
        delegate?.pushToBViewController()
    }
}
