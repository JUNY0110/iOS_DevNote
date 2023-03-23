//
//  DCoordinator.swift
//  CoordinatorTest
//
//  Created by 지준용 on 2023/03/23.
//

protocol DCoordinatorDelegate {
    func popToCViewController()
    func dismissViewController()
}

class DCoordinator: BaseCoordinator, DViewControllerDelegate {

    // MARK: - Property
    
    var delegate: DCoordinatorDelegate?
    

    // MARK: - Start
    
    override func start() {
        let dVC = DViewController()
        dVC.delegate = self
        navigationController.pushViewController(dVC, animated: true)
    }
    
    // MARK: - Pop

    func popToCViewController() {
        delegate?.popToCViewController()
    }
    
    // MARK: - Dismiss
    
    func dismissViewController() {
        delegate?.dismissViewController()
    }
}
