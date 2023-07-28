//
//  BaseHStackView.swift
//  TodoList
//
//  Created by 지준용 on 2023/07/17.
//

import UIKit

class BaseHStackView: UIStackView {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        setupArrangedSubViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Attribute
    
    private func attribute() {
        self.axis = .horizontal
        self.distribution = .fillEqually
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - SetupArrangedSubViews
    
    func setupArrangedSubViews() {}
}
