//
//  LoadedView.swift
//  TestProject
//
//  Created by Leandro Diaz on 3/15/22.
//
/*
import UIKit
import Anchorage

class LoadedView: UIView {
    
    var buttonAction: (() -> Void)?
    var switchAction: (() -> Void)?
    
    lazy var loadedLabel: UILabel = {
        let label = CustomTitleLabel(textAlignment: .left, fontSize: 14, text: "Loaded")
        return label
    }()
    
    lazy var loadedToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .systemGreen
        return toggle
    }()
    
    private var loadedToggleChanged: Bool = false {
        didSet {
            loadedToggle.isOn = loadedToggleChanged
        }
    }
    
    lazy var loadedDatePicker: UIDatePicker = {
       let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .compact
        picker.addTarget(self, action: #selector(checkInDateSelected), for: .editingDidEnd)
        return picker
    }()
    
    lazy var binaryViewOne: UIView = {
        let view = BinaryView(title: "Were there any issues", questionText: "Problems")
        view.backgroundColor = .white
        return view
    }()
    
    lazy var loadedSubmitButton: UIButton = {
        let btn = CustomButton(backgroundColor: .systemBlue, title: "Submit")
        return btn
    }()
    
    lazy var componentsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [loadedLabel, loadedToggle])
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
    
    private func isCompleted(loadedIn: String, date: String) {
        
    }
    
    private func configure() {
        layer.borderWidth = 0.5
        layer.cornerRadius = 16
        backgroundColor = .systemGray6
        addSubview(componentsStackView)
        isUserInteractionEnabled = true
        addSubview(loadedDatePicker)
        loadedDatePicker.layer.borderWidth = 1
        addSubview(binaryViewOne)
        addSubview(loadedSubmitButton)
        setupConstraints()
    }
    
    
    private func setupConstraints() {
        let padding: CGFloat = 20
        componentsStackView.topAnchor == topAnchor + padding
        componentsStackView.horizontalAnchors == horizontalAnchors + padding
        
        loadedDatePicker.topAnchor == componentsStackView.bottomAnchor + padding
        loadedDatePicker.leadingAnchor == leadingAnchor
        loadedDatePicker.trailingAnchor == trailingAnchor
        loadedDatePicker.heightAnchor == 80
        
        binaryViewOne.topAnchor == loadedDatePicker.bottomAnchor + padding
        binaryViewOne.horizontalAnchors == horizontalAnchors
        binaryViewOne.heightAnchor == 100
        
        loadedSubmitButton.topAnchor == binaryViewOne.bottomAnchor + 10
        loadedSubmitButton.centerXAnchor == centerXAnchor
        loadedSubmitButton.widthAnchor == 100
    }
}
*/
