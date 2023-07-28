//
//  DetailView.swift
//  TodoList
//
//  Created by 지준용 on 2023/07/24.
//

import UIKit

protocol DetailViewDelegate: AnyObject {
    func pressedSaveButton(_ sender: DetailView)
    func tappedCalendar(_ sender: DetailView)
}

final class DetailView: UIView {
    
    // MARK: - Property
    
    weak var delegate: DetailViewDelegate?
    private lazy var colorButtons = [redButton, greenButton, blueButton, purpleButton]
    
    var colorNumber = 0 {
        didSet {
            guard let color = ColorType(rawValue: colorNumber) else { return }
            colorButtons[colorNumber].configuration?.baseBackgroundColor = color.buttonColor
            colorButtons[colorNumber].configuration?.baseForegroundColor = .white
            addAndUpdateButton.configuration?.baseBackgroundColor = color.buttonColor
            textView.backgroundColor = color.backgroundColor
        }
    }
    var todoData: TodoData? {
        didSet {
            colorNumber = Int(todoData!.colors)
            textView.text = todoData!.memo
            dateLabel.text = "🕓 " + todoData!.endDate.convertToString()
            datePicker.date = todoData!.endDate
        }
    }
    
    // MARK: - View
    
    private var contentView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.spacing = .sixteen
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private var colorCategory = BaseHStackView()
    private var redButton = UIButton(configuration: .filled())
    private var greenButton = UIButton(configuration: .filled())
    private var blueButton = UIButton(configuration: .filled())
    private var purpleButton = UIButton(configuration: .filled())
    
    var textView: UITextView = {
        $0.text = ""
        $0.textAlignment = .left
        $0.font = .mediumSize
        $0.layer.cornerRadius = .eight
        $0.backgroundColor = .backgroundRed
        $0.autocorrectionType = .no
        $0.spellCheckingType = .yes
        $0.smartDashesType = .yes
        $0.smartInsertDeleteType = .yes
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITextView())

    private var dateStack = BaseHStackView()
    var dateLabel: UILabel = {
        $0.text = "🕓 " + Date().convertToString()
        $0.font = .mediumSize
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    var datePicker: UIDatePicker = {
        $0.preferredDatePickerStyle = .compact
        $0.datePickerMode = .date
        $0.minimumDate = .now
        let localeID = Locale.preferredLanguages.first ?? "ko_KR"
        $0.locale = Locale(identifier: localeID)
        $0.timeZone = .current
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(tappedCalendar), for: .valueChanged)
        return $0
    }(UIDatePicker())
    
    var addAndUpdateButton: UIButton = {
        $0.configuration?.title = "저장"
        $0.configuration?.baseBackgroundColor = .buttonRed
        $0.configuration?.baseForegroundColor = .white
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(pressedSaveButton), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton(configuration: .filled()))
    
    // MARK: - Init
    
    @available(*, unavailable)
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        attribute()
        activateButton()
        addKeyboardObserver()
        
        colorCategory.spacing = .eight
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ConfigureUI
    
    private func configureUI() {
        self.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,
                                         constant: .sixteen).isActive = true
        contentView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor,
                                          constant: .sixteen).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor,
                                           constant: -(.sixteen)).isActive = true
        
        colorCategory.addArrangedSubview(redButton)
        colorCategory.addArrangedSubview(greenButton)
        colorCategory.addArrangedSubview(blueButton)
        colorCategory.addArrangedSubview(purpleButton)
        
        contentView.addArrangedSubview(colorCategory)
        contentView.addArrangedSubview(textView)
        contentView.addArrangedSubview(dateStack)
        dateStack.addArrangedSubview(dateLabel)
        dateStack.addArrangedSubview(datePicker)
        
        textView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        self.addSubview(addAndUpdateButton)
        addAndUpdateButton.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor,
                                                 constant: .sixteen).isActive = true
        addAndUpdateButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor,
                                                  constant: -(.sixteen)).isActive = true
        addAndUpdateButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,
                                                   constant:  -(.sixteen)).isActive = true
        addAndUpdateButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    // MARK: - Attribute
    
    func attribute() {
        for (index, button) in colorButtons.enumerated(){
            guard let color = ColorType(rawValue: index) else { return }
            button.configuration?.title = "\(color)".uppercased()
            button.configuration?.buttonSize = .small
            button.configuration?.cornerStyle = .medium
            button.addTarget(self, action: #selector(pressedColorButton(_:)), for: .touchUpInside)
            button.configuration?.baseForegroundColor = (index == colorNumber) ? .white : .systemGray2
            button.configuration?.baseBackgroundColor = (index == colorNumber) ? color.buttonColor : color.backgroundColor
        }

        colorCategory.spacing = .eight
    }
    
    // MARK: - Configure Color Button
    
    @objc func pressedColorButton(_ sender: UIButton) {
        if let num = colorButtons.firstIndex(of: sender),
            let color = ColorType(rawValue: num) {
            
            for (index, button) in colorButtons.enumerated() where index != num {
                guard let otherColor = ColorType(rawValue: index) else { return }
                configureUnselectedButton(to: button, of: otherColor)
            }
            
            colorNumber = num
            configureSelectedButton(to: sender, of: color)
        }
    }
    
    private func configureSelectedButton(to button: UIButton, of color: ColorType) {
        button.configuration?.baseForegroundColor = .white
        button.configuration?.baseBackgroundColor = color.buttonColor
    }
    
    private func configureUnselectedButton(to button: UIButton, of color: ColorType) {
        button.configuration?.baseForegroundColor = .systemGray2
        button.configuration?.baseBackgroundColor = color.backgroundColor
    }
    
    // MARK: - Helper ( NotificationCenter Keyboard )
    
    private func activateButton() {
        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: textView, queue: OperationQueue.main) { (notification) in
            if self.textView.text.isEmpty {
                self.addAndUpdateButton.isEnabled = false
            } else if self.todoData?.memo != self.textView.text ||
                        self.todoData!.colors != self.colorNumber {
                self.addAndUpdateButton.isEnabled = true
            }
        }
    }
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(contentViewMoveUp),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(contentViewMoveDown),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func contentViewMoveUp(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3) {
                self.addAndUpdateButton.transform = CGAffineTransform(translationX: 0,
                                                                      y: -keyboardSize.height)
                self.contentView.transform = CGAffineTransform(translationX: 0,
                                                                          y: -(self.addAndUpdateButton).frame.height)
            }
        }
    }
    
    @objc func contentViewMoveDown(_ notification: NSNotification) {
        self.addAndUpdateButton.transform = .identity
        self.contentView.transform = .identity
    }
    
    // MARK: - Delegate ( SaveButton )
    
    @objc func pressedSaveButton() {
        delegate?.pressedSaveButton(self)
    }
    
    @objc func tappedCalendar() {
        delegate?.tappedCalendar(self)
    }
}
    
