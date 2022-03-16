//
//  Coordinator.swift
//  TestProject
//
//  Created by Leandro Diaz on 3/15/22.
//

import UIKit


class ViewCoordinator: Coordinator {
    func completeAction(animated: Bool, completion: VoidClosure?) {
        
    }
    
    func cleanup(animated: Bool, completion: VoidClosure?) {
        
    }
    
    var childCoordinator: Coordinator?
    
    lazy var viewController: ViewController = {
        let listSelectionViewController = ViewController()
        listSelectionViewController.delegate = self
        return listSelectionViewController
    }()
}


extension ViewCoordinator: ViewControllerDelegate {
    func viewController(_ vc: ViewController, didNotify action: ViewController.Action) {
        switch action {
        case .close:
            vc.dismiss(animated: true, completion: nil)
        case .keepItem:
            vc.dismiss(animated: true, completion: nil)
        case .deleteList(list: let list):
            print(list)
//            vc.startLoader(style: .simpleBrand)
//            viewModel?.deleteList(listId: list.id, completion: { [weak self] (response, error) in
//                vc.stopLoader()
//                if (response as? ListsDeleteResponse) != nil {
//                    self?.listTabBar.viewModel = self?.viewModel
//                } else {
//                    if let error = error as NSError? {
//                        let errorString = error.localizedDescription
//                        vc.showAlert(title: L10n.Alert.General.title, body: errorString)
//                    }
//                }
//                vc.dismiss(animated: true, completion: nil)
//            })
            break
        case .deleteItem(item: let date):
            print(date)
//            vc.startLoader(style: .simpleBrand)
//            viewModel?.deleteItem(itemId: item.id, completion: { [weak self] (response, error) in
//                vc.stopLoader()
//                if (response as? ListsDeleteResponse) != nil {
//                    let updatedItems = self?.addProductViewController.list?.items?.filter {$0.id != item.id}
//                    self?.addProductViewController.list?.items = updatedItems
//                    self?.listShoppingViewController.list?.items = updatedItems
//                    self?.addProductViewController.addOverlayView(bannerText: L10n.Lists.DeleteItem.Success.title)
//                } else {
//                    if let error = error as NSError? {
//                        let errorString = error.localizedDescription
//                        vc.showAlert(title: L10n.Alert.General.title, body: errorString)
//                    }
//                }
                vc.dismiss(animated: true, completion: nil)
//            })
        }
    }
}


// MARK: - ListConfirmationViewController
protocol ViewControllerDelegate: AnyObject {
    func viewController(_ vc: ViewController, didNotify action: ViewController.Action)
}

extension ViewController {

    typealias ActionType = Action
    typealias Delegate = ViewControllerDelegate

    func notify(_ action: ActionType) {
        delegate?.viewController(self, didNotify: action)
    }
}
