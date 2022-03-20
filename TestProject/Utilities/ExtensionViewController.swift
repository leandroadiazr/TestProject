//
//  ExtensionViewController.swift
//  TestProject
//
//  Created by LeandroDiaz on 3/16/22.
//

import UIKit
import Anchorage
fileprivate var containerView: UIView!

extension UIViewController {
    func customAlert(title: String, message: String, buttonTitle: String){
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: buttonTitle, style: .default)
            alertVC.addAction(action)
            alertVC.modalPresentationStyle   = .overFullScreen
            alertVC.modalTransitionStyle     = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func showLoadingView(){
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor   = .systemBackground
        containerView.alpha             = 0
        
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor == view.centerXAnchor
        activityIndicator.centerYAnchor == view.centerYAnchor
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async{
            containerView.removeFromSuperview()
            containerView = nil
        }
    }
    
    //MM-dd-yyyy HH:mm
    //"MM/dd/yyyy"
    func convertToDate(string: String, format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string) ?? Date()
    }
    
    //MM-dd-yyyy HH:mm
    //"MM/dd/yyyy"
    func convertDateToString(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }

}
