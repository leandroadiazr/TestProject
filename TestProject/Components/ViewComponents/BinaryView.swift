//
//  BinaryView.swift
//  TestProject
//
//  Created by LeandroDiaz on 3/23/22.
//

import UIKit
import Anchorage
import M13Checkbox

class BinaryView: UIView {
    var buttonAction: (() -> Void)?
    
    lazy var mainQuestionLabel: UILabel = {
        let label = CustomTitleLabel(textAlignment: .left, fontSize: 14, text: "")
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = CustomSubTitleLabel(fontSize: 12, backgroundColor: .clear, text: "")
        return label
    }()
    

    var checkBoxOne = RadioButton(fillColor: .systemRed, questionLabel: "", questionImage: "hand.thumbsdown")

    var checkBoxTwo = RadioButton(fillColor: .systemBlue, questionLabel: "", questionImage: "hand.thumbsdown")

    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [checkBoxOne, checkBoxTwo])
        checkBoxOne.checkBox.addTarget(self, action: #selector(answer(_:)), for: .valueChanged)
        checkBoxOne.checkBox.tag = 1
        checkBoxTwo.checkBox.addTarget(self, action: #selector(answer(_:)), for: .valueChanged)
        checkBoxTwo.checkBox.tag = 2
        view.axis = .horizontal
        view.distribution = .equalSpacing
        return view
    }()
    
    init(frame: CGRect, mainQuestionTitle: String, subtitleLabel: String?, boxOneFillCollor: UIColor, boxOneText: String, boxOneImage: String, boxTwoFillCollor: UIColor, boxTwoText: String, boxTwoImage: String) {
        super.init(frame: frame)
        self.mainQuestionLabel.text = mainQuestionTitle
        self.subtitleLabel.text = subtitleLabel ?? ""
        self.checkBoxOne = RadioButton(fillColor: boxOneFillCollor, questionLabel: boxOneText, questionImage: boxOneImage)
        self.checkBoxTwo = RadioButton(fillColor: boxTwoFillCollor, questionLabel: boxTwoText, questionImage: boxTwoImage)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func answer(_ box: RadioButton) {
        print("working")
        buttonAction?()
        changeState(box)
    }
    
    @objc private func changeState(_ box: RadioButton) {
        print("called?", box.tag)
        switch box.tag {
        case 1:
            checkBoxOne.checkBox.stateChangeAnimation = .fill
            checkBoxTwo.checkBox.checkState = .unchecked
        case 2:
            checkBoxTwo.checkBox.stateChangeAnimation = .fill
            checkBoxOne.checkBox.checkState = .unchecked
        default:
            break
        }
    }
    
    private func configure() {
        addSubview(mainQuestionLabel)
        addSubview(subtitleLabel)
        addSubview(stackView)
        setupConstraints()
    }
    
    
    private func setupConstraints() {
        let padding: CGFloat = 20
        mainQuestionLabel.topAnchor == topAnchor + padding
        mainQuestionLabel.horizontalAnchors == horizontalAnchors + padding
        
        subtitleLabel.topAnchor == mainQuestionLabel.bottomAnchor
        subtitleLabel.horizontalAnchors == mainQuestionLabel.horizontalAnchors
        
        stackView.topAnchor == subtitleLabel.bottomAnchor
        stackView.horizontalAnchors == horizontalAnchors + padding
        stackView.heightAnchor == 50
        
    }
    
}
