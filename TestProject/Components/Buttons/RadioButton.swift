////
////  RadioButton.swift
////  TestProject
////
////  Created by LeandroDiaz on 3/23/22.
////
//
//import UIKit
//import Anchorage
//import M13Checkbox
//
//class RadioButton: UIButton {
//    
//    
//    
//    var selectedAnswer: ((Bool) -> Void)?
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configure()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    convenience init(backgroundColor: UIColor) {
//        self.init(frame: .zero)
//        self.backgroundColor = backgroundColor
//        self.setTitle("", for: .normal)
//    }
//    
//    private func configure(){
//        addSubview(selectedCheckBox)
//        translatesAutoresizingMaskIntoConstraints = false
//        setupConstraints()
//        //        configureState()
//    }
//    
//    private func configureState(withAnswer answer: Bool, animated: Bool = false) {
//        
//    }
//    
//    func set(backgroundColor: UIColor, title: String){
//        self.backgroundColor = backgroundColor
//        setTitle(title, for: .normal)
//    }
//    
//    private func setupConstraints() {
//        //        NSLayoutConstraint.activate([
//        //            heightAnchor.constraint(equalToConstant: 30)
//        //        ])
//        heightAnchor == 50
//        widthAnchor  == 50
//    }
//    
//}
