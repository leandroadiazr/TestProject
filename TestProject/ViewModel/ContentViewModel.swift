//
//  ContentViewModel.swift
//  TestProject
//
//  Created by LeandroDiaz on 3/23/22.
//

import UIKit


//MARK: CONTENTVIEWMODEL
class ContentViewModel {
    var allMilestones: [LoMAT.StopMilestone]?
    var currentMilestone: LoMAT.StopMilestone?
    var questions: [LoMAT.Question]?
    var questionType: LoMAT.Question?
    
    init(milestones: [LoMAT.StopMilestone]?) {
        if let milestones = milestones {
            self.allMilestones = milestones
            for milestone in milestones {
                self.questions?.append(contentsOf: milestone.questions)
            }
        }
//        self.currentMilestone = milestones?.first(where: {$0.completed == false })
        print(currentMilestone)
    }
    
    
    //MARK: Check In
    func checkIn(item: LoMAT.StopMilestone, vc: UIViewController, completion: @escaping (Bool) -> Void) {
        
        vc.showLoadingView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            NetworkManager.updateWith(milestone: item, actionType: .add) { error in
                vc.dismissLoadingView()
                guard let error = error else {
                    vc.customAlert(title: "Success!...", message: "Milestone Completed...", buttonTitle: "Okay")
                    completion(true)
                    return
                }
                vc.customAlert(title: "Something went wrong...", message: error.rawValue, buttonTitle: "Ok")
            }
            completion(false)
        }
        
        
  
    }
    
    //MARK: Delete All
    func deleteAll(item: LoMAT.StopMilestone, vc: UIViewController, completion: @escaping (Bool) -> Void) {
        //        vc.showLoadingView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            NetworkManager.updateWith(milestone: item, actionType: .remove) { error in
                //                vc.dismissLoadingView()
                guard let error = error else {
                    vc.customAlert(title: "Success!...", message: "Milestone Deleted...", buttonTitle: "Okay")
                    completion(true)
                    return
                }
                vc.customAlert(title: "Something went wrong...", message: error.rawValue, buttonTitle: "Ok")
            }
            completion(false)
        }
    }
}
