
//  TodoTableViewCell.swift
//  TodoList
//
//  Created by 지준용 on 2023/07/16.
//

import UIKit

protocol TodoTableViewCellDelegate: AnyObject {
    func moveToRenewalViewController(_ sender: TodoTableViewCell)
    func presentAlert(_ sender: TodoTableViewCell)
}

final class TodoTableViewCell: UITableViewCell {
    
    // MARK: - Property
    
    static let identifier = "todoCell"
    weak var delegate: TodoTableViewCellDelegate?
    private let todoManager = CoreDataManager.shared
    
    // MARK: - View
    
    var colorView: UIView = {
        $0.backgroundColor = .backgroundRed
        $0.layer.cornerRadius = .eight
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    var memoLabel: UILabel = {
        $0.text = "할 일 입니다."
        $0.textColor = .black
        $0.font = .mediumSize
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    var hStackView = MemoComponentStackView()
    
    // MARK: - Init
    
    @available(*, unavailable) // 외부에서 접근을 막아 실수로 init을 호출하지 못하게 하기 위함.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupCell()
        attribute()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupCell

    func setupCell() {
        contentView.addSubview(colorView)
        colorView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: .sixteen).isActive = true
        colorView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -(.sixteen)).isActive = true
        colorView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(.eight)).isActive = true
        
        colorView.addSubview(memoLabel)
        memoLabel.leftAnchor.constraint(equalTo: colorView.leftAnchor, constant: .eight).isActive = true
        memoLabel.rightAnchor.constraint(equalTo: colorView.rightAnchor, constant: -(.eight)).isActive = true
        memoLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: .eight).isActive = true
        memoLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: memoLabel.intrinsicContentSize.height + 20).isActive = true
        
        colorView.addSubview(hStackView)
        hStackView.leftAnchor.constraint(equalTo: colorView.leftAnchor, constant: .eight).isActive = true
        hStackView.rightAnchor.constraint(equalTo: colorView.rightAnchor, constant: -(.eight)).isActive = true
        hStackView.topAnchor.constraint(equalTo: memoLabel.bottomAnchor, constant: .eight).isActive = true
        hStackView.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -(.eight)).isActive = true
    }
    
    // MARK: - Attribute
    
    func attribute() {
        self.selectionStyle = .none
        self.backgroundColor = .systemGray6
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(presentAlert))
        self.addGestureRecognizer(longPressGesture)
        
        hStackView.renewalButton.addTarget(self, action: #selector(moveToRenewalViewController), for: .touchUpInside)
    }
    
    // MARK: - Configure Cell
    
    func configure(memo: String, endDate: Date, color: ColorType) {
        self.memoLabel.text = memo
        self.hStackView.endDate.text = endDate.convertToString()

        if endDate.convertToString() == Date().convertToString() || endDate > Date() {
            self.hStackView.renewalButton.isEnabled = true
            self.hStackView.renewalButton.configuration?.title = "수정하기"
        } else {
            self.hStackView.renewalButton.isEnabled = false
            self.hStackView.renewalButton.configuration?.title = "마 감"
        }

        self.hStackView.renewalButton.configuration?.baseBackgroundColor = color.buttonColor
        self.colorView.backgroundColor = color.backgroundColor
    }
    
    // MARK: - Delegate

    @objc func moveToRenewalViewController() {
        delegate?.moveToRenewalViewController(self)
    }
    
    @objc func presentAlert() {
        delegate?.presentAlert(self)
    }
}
