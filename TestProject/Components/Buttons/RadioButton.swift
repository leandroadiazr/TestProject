//
//  RadioButton.swift
//  TestProject
//
//  Created by LeandroDiaz on 3/23/22.
//

import UIKit
import Anchorage
import M13Checkbox

class RadioButton: UIView {

    var selectedAnswer: (() -> Void)?
    
    lazy var checkBox: M13Checkbox = {
        let checkbox = M13Checkbox()
        checkbox.boxType = .circle
        checkbox.markType = .radio
        checkbox.checkState = .unchecked
        checkbox.heightAnchor == 25
        checkbox.widthAnchor == 25
        checkbox.addTarget(self, action: #selector(answer), for: .valueChanged)
        return checkbox
    }()
    
    private var questionLabel: UILabel = {
        let label = CustomTitleLabel(textAlignment: .left, fontSize: 13, text: "")
        return label
    }()

    lazy var questionImage: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "hand.thumbsdown"))
        return view
    }()
    
    lazy var radioStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [checkBox, questionLabel, questionImage])
        view.axis = .horizontal
//        view.alignment = .center
        view.distribution = .equalSpacing
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(fillColor: UIColor?, questionLabel: String?, questionImage: String?) {
        self.init(frame: .zero)
        self.checkBox.tintColor = fillColor
        self.questionLabel.text = questionLabel
        self.questionLabel.textColor = fillColor
        self.questionImage.image = UIImage(systemName: questionImage ?? "")
        self.questionImage.tintColor = fillColor
        configure()
    }
    
    private func configure(){
        addSubview(checkBox)
        addSubview(questionImage)
        addSubview(questionLabel)
        translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
    @objc private func answer() {
        selectedAnswer?()
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 20
        checkBox.leadingAnchor == leadingAnchor + padding
        checkBox.centerYAnchor == centerYAnchor
        
        questionImage.leadingAnchor == checkBox.trailingAnchor + padding
        questionImage.centerYAnchor == centerYAnchor
        
        questionLabel.leadingAnchor == questionImage.trailingAnchor + padding
        questionLabel.trailingAnchor == trailingAnchor - padding
        questionLabel.centerYAnchor == centerYAnchor
//        checkBox.verticalAnchors == verticalAnchors
        
        
//        heightAnchor == 50
//        widthAnchor == 150
    }
    
}
