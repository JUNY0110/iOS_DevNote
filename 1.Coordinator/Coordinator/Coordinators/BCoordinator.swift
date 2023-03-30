//
//  BCoordinator.swift
//  Coordinator
//
//  Created by 지준용 on 2023/03/23.
//

protocol BCoordinatorDelegate {
    func presentCViewController()
    func popViewController()
}

class BCoordinator: BaseCoordinator, BViewControllerDelegate   {

    // MARK: - Property

    var delegate: BCoordinatorDelegate?

    // MARK: - Start
    
    override func start() {
        let bVC = BViewController()
        bVC.delegate = self
        
        navigationController.pushViewController(bVC, animated: true)
    }
    
    // MARK: - Method
    
    func presentCViewController() {
        delegate?.presentCViewController()
    }
    
    func popToAViewController() {
        delegate?.popViewController()
    }
}
