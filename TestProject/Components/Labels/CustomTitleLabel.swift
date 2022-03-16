//
//  CustomLabel.swift
//  TestProject
//
//  Created by Leandro Diaz on 3/15/22.
//

import UIKit

class CustomTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat, text: String) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        self.text = text
    }
    
    private func configure(){
        textColor                    = .label
        adjustsFontSizeToFitWidth    = true
        minimumScaleFactor           = 0.90
        lineBreakMode                = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
}
