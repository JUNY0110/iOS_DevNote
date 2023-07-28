//
//  BaseViewController.swift
//  TodoList
//
//  Created by 지준용 on 2023/07/17.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        attribute()
    }
    
    // MARK: - Layout
    
    func layout() {}
    
    // MARK: - Attribute
    
    func attribute() {
        view.backgroundColor = .systemGray6
    }
    
    // MARK: - Method
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideKeyboard()
    }
}
