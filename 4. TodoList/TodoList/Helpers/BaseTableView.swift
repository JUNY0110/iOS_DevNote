//
//  BaseTableView.swift
//  TodoList
//
//  Created by 지준용 on 2023/07/25.
//

import UIKit

class BaseTableView: UITableView {
    
    // MARK: - Init
    
    @available(*, unavailable)
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        attribute()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Attribute
    
    private func attribute() {
//        self.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.identifier)
        self.backgroundColor = .systemGray6
        self.separatorStyle = .none
        self.delaysContentTouches = false
        self.canCancelContentTouches = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Method
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIButton {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
}
