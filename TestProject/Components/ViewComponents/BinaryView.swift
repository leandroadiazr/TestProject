////
////  BinaryView.swift
////  TestProject
////
////  Created by LeandroDiaz on 3/23/22.
////
//
//import UIKit
//import Anchorage
//import M13Checkbox
//
//class BinaryView: UIView {
//    
//    lazy var selectedCheckBox: M13Checkbox = {
//       let checkbox = M13Checkbox()
//        checkbox.boxType = .circle
//        checkbox.markType = .radio
//        checkbox.checkState = .unchecked
//        checkbox.tintColor = .red
//        checkbox.backgroundColor = .yellow
//        return checkbox
//    }()
//    
//    let viewTitle = CustomTitleLabel(textAlignment: .left, fontSize: 14, text: "Were there any issues?")
//    
////    lazy var radioButton: RadioButton = {
////        let radio = RadioButton(backgroundColor: .clear)
////        radio.translatesAutoresizingMaskIntoConstraints = false
//////        radio.layer.cornerRadius = 15
////        return radio
////    }()
//    
//    lazy var thumbsImage: UIImageView = {
//        let view = UIImageView(image: UIImage(systemName: "thumbsup"))
//        return view
//    }()
//    
//    lazy var questionLabel: UILabel = {
//        let label = CustomTitleLabel(textAlignment: .left, fontSize: 11, text: "")
//        return label
//    }()
//    
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configure()
//    }
//    
//    convenience init(title: String, questionText: String) {
//        self.init(frame: .zero)
//        self.viewTitle.text = title
//        self.questionLabel.text = questionText
////        self.textAlignment = textAlignment
////        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
////        self.text = text
//    }
//    
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func configure() {
//    addSubview(selectedCheckBox)
//        addSubview(thumbsImage)
//        addSubview(questionLabel)
//         
//        setupConstraints()
//    }
//    
//    
//    private func setupConstraints() {
//        let padding: CGFloat = 20
//        
//        selectedCheckBox.topAnchor == topAnchor + padding
//        selectedCheckBox.centerYAnchor == centerYAnchor
//        selectedCheckBox.leadingAnchor == leadingAnchor + 10
//        selectedCheckBox.heightAnchor == 20
//        selectedCheckBox.widthAnchor == 20
//        
//        thumbsImage.leadingAnchor == selectedCheckBox.trailingAnchor + padding
//        thumbsImage.centerYAnchor == selectedCheckBox.centerYAnchor
////        thumbsImage.widthAnchor == 30
////        thumbsImage.heightAnchor == 30
////        
//        questionLabel.leadingAnchor == thumbsImage.trailingAnchor + padding
//        questionLabel.widthAnchor == 100
//        
//    }
//    
//}
