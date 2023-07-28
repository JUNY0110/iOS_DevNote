//
//  MemoComponentStackView.swift
//  TodoList
//
//  Created by 지준용 on 2023/07/17.
//

import UIKit

final class MemoComponentStackView: BaseHStackView {

    // MARK: - View
    
    var endDate: UILabel = {
        $0.text = "0일 남았습니다."
        $0.textColor = .secondaryLabel
        $0.font = .smallSize
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private var emptyView = UIView()
    
    var renewalButton: UIButton = {
        $0.configuration?.title = "수정하기"
        $0.configuration?.baseForegroundColor = .white
        $0.configuration?.baseBackgroundColor = .brown
        $0.configuration?.buttonSize = .small
        $0.configuration?.background.cornerRadius = .eight
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton(configuration: .filled()))
    
    // MARK: - Init
    
    @available(*, unavailable)
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.distribution = .fillEqually
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - SetupArrangedSubViews
    
    override func setupArrangedSubViews() {
        self.addArrangedSubview(endDate)
        self.addArrangedSubview(emptyView)
        self.addArrangedSubview(renewalButton)
    }
}
