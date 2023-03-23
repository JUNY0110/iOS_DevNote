//
//  BaseViewController.swift
//  CoordinatorTest
//
//  Created by 지준용 on 2023/03/23.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        layout()
        attribute()
    }
    
    func layout() {}
    func attribute() {}
}
