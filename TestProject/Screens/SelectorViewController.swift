//
//  SelectorViewController.swift
//  TestProject
//
//  Created by LeandroDiaz on 3/23/22.
//

import UIKit
import Anchorage

class SelectorViewController: UIViewController {

    lazy var updateButton: CustomButton = {
        let button = CustomButton(backgroundColor: .systemBlue, title: "Update Stops")
        button.widthAnchor == 170
        button.heightAnchor == 40
        button.addTarget(self, action: #selector(loadWorkFlowView), for: .touchUpInside)
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        // Do any additional setup after loading the view.
    }
    
    @objc private func loadWorkFlowView() {
        let milestonesVC = MilestonesViewController()
        self.navigationController?.pushViewController(milestonesVC, animated: true)
    }

    private func configure() {
        view.addSubview(updateButton)
        setupConstraints()
    }
    
    
    private func setupConstraints() {
        let padding: CGFloat = 20
        updateButton.centerXAnchor == view.centerXAnchor
        updateButton.centerYAnchor == view.centerYAnchor
    }

}
