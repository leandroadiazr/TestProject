//
//  Checking.swift
//  TestProject
//
//  Created by Leandro Diaz on 3/15/22.
//

import UIKit
import Anchorage

class Checking: UIView {
    
    var action: (() -> Void)?
    
    lazy var vc: UIViewController = {
        let vc = ViewController()
        
        return vc
    }()
    
    lazy var checkingLabel: UILabel = {
        let label = CustomTitleLabel(textAlignment: .left, fontSize: 14, text: "Check In")
        return label
    }()
    
    lazy var checkInToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .systemGreen
        return toggle
    }()
    
    private var toggleChanged: Bool = false {
        didSet {
            checkInToggle.isOn = toggleChanged
        }
    }
    
    lazy var datePicker: UIDatePicker = {
       let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .compact
        picker.addTarget(self, action: #selector(dateSelected), for: .editingDidEnd)
        return picker
    }()
    
    lazy var submitButton: UIButton = {
        let btn = CustomButton(backgroundColor: .systemBlue, title: "Submit")
        return btn
    }()
    
    lazy var componentsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [checkingLabel, checkInToggle])
        stack.distribution = .equalSpacing
        stack.spacing = 10
        stack.axis = .horizontal
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dateSelected(_ sender: UIDatePicker) {
        print(sender.date)
        
    }
    
    private func isCompleted(checkedIn: String, date: String) {
        
    }
    
    private func configure() {
        layer.borderWidth = 0.5
        layer.cornerRadius = 16
        backgroundColor = .systemGray6
        addSubview(componentsStackView)

        addSubview(datePicker)
        datePicker.layer.borderWidth = 1
        addSubview(submitButton)
        setupConstraints()
    }
    
    
    private func setupConstraints() {
        let padding: CGFloat = 20
        componentsStackView.topAnchor == topAnchor + padding
        componentsStackView.horizontalAnchors == horizontalAnchors + padding
        
        datePicker.topAnchor == componentsStackView.bottomAnchor + padding
        datePicker.leadingAnchor == leadingAnchor
        datePicker.trailingAnchor == trailingAnchor
        datePicker.heightAnchor == 80
        
        submitButton.topAnchor == datePicker.bottomAnchor + 10
        submitButton.centerXAnchor == centerXAnchor
        submitButton.widthAnchor == 100
    }
}
