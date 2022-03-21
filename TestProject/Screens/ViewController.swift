//
//  ViewController.swift
//  TestProject
//
//  Created by Leandro Diaz on 3/15/22.
//

import UIKit
import Anchorage

enum MilestoneType: String, CaseIterable {
    case checkIn = "CHECK_IN"
    case loaded = "LOADED"
    case upload = "UPLOAD"
}

//MARK: CONTENTVIEWMODEL
class ContentViewModel {
    var allMilestones: [LoMAT.StopMilestone]?
    var currentMilestone: LoMAT.StopMilestone?
    var questions: [LoMAT.Question]?
    
    init(milestones: [LoMAT.StopMilestone]?) {
        if let milestones = milestones {
            self.allMilestones = milestones
            for milestone in milestones {
                self.questions?.append(contentsOf: milestone.questions)
            }
        }
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


class ViewController: UIViewController {
    
    var viewModel: ContentViewModel? {
        didSet {
            guard let milestones = viewModel?.allMilestones else { return }
            
            guard let checkInMilestone = milestones.first(where: { $0.stopMilestoneType == MilestoneType.checkIn.rawValue }) else { return }
            
            if checkInMilestone.completed {
                self.isCheckinCompleted(milestone: checkInMilestone)
                self.changeVisibility(hidden: false)
            } else {
                viewModel?.currentMilestone = checkInMilestone
                self.changeVisibility(hidden: true)
                
            }
            
            guard let loadedMilestone = milestones.first(where: { $0.stopMilestoneType == MilestoneType.loaded.rawValue }) else { return }
            guard let uploadMilestone = milestones.first(where: { $0.stopMilestoneType == MilestoneType.upload.rawValue }) else { return }
        }
    }
    
    private func isCheckinCompleted(milestone: LoMAT.StopMilestone) {
        self.checkingLabel.text = "Already checked in"
        checkInToggle.isOn = true
        checkInToggle.isEnabled = false
        submitButton.setTitle("Submited", for: .normal)
        submitButton.isEnabled = false
        submitButton.setTitleColor(.systemBlue, for: .disabled)
        guard let milestones = self.viewModel?.allMilestones?.first(where: { $0.stopMilestoneType == MilestoneType.checkIn.rawValue }) else { return }
        guard let dateQuestion = milestones.questions.first(where: { $0.questionName == "CheckedInDateTime" }) else { return }
        if let date = dateQuestion.selectedAnswer {
            datePicker.date = convertToDate(string: date, format: "MM-dd-yyyy HH:mm")
            datePicker.isEnabled = false
        }
        self.changeVisibility(hidden: false)
        submitButton.backgroundColor = .clear
    }
    
    lazy var stopLabel: UILabel = {
        let label = CustomTitleLabel(textAlignment: .left, fontSize: 16, text: "Pick 1 - Walmart Supercenter")
        return label
    }()
    
    //MARK: - Toggle Button
    lazy var checkingLabel: UILabel = {
        let label = CustomTitleLabel(textAlignment: .left, fontSize: 14, text: "Check In")
        label.backgroundColor = .white
        return label
    }()
    
    lazy var checkInToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .systemGreen
        toggle.addTarget(self, action: #selector(toggleChangedValue), for: .valueChanged)
        return toggle
    }()
    
    @objc private func toggleChangedValue(_ toggle: UISwitch) {
        toggleChanged = toggle.isOn ? true : false
        print(toggleChanged)
    }
    
    private var toggleChanged: Bool = false {
        didSet {
            checkInToggle.isOn = toggleChanged
            changeVisibility(hidden: !toggleChanged)
            submitButton.backgroundColor = !toggleChanged ? .lightGray : .systemBlue
        }
    }
    
    //MARK: - Date Picker
    lazy var dateLabel: UILabel = {
        let label = CustomTitleLabel(textAlignment: .left, fontSize: 14, text: "Time")
        return label
    }()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .automatic
        picker.addTarget(self, action: #selector(dateSelected), for: .editingDidEnd)
        return picker
    }()
    
    @objc func dateSelected(_ picker: UIDatePicker) {
        checkinDate = picker.date
    }
    
    private var checkinDate: Date? {
        didSet {
            if let date = checkinDate {
                datePicker.date = date
                print(date)
            }
        }
    }
    
    //MARK: - Submit Button
    lazy var submitButton: UIButton = {
        let btn = CustomButton(backgroundColor: .systemBlue, title: "Submit")
        btn.addTarget(self, action: #selector(checkInButtonTapped(_:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var deleteButton: UIButton = {
        let btn = CustomButton(backgroundColor: .systemRed, title: "delete")
        btn.addTarget(self, action: #selector(deleteAll), for: .touchUpInside)
        return btn
    }()
    
    lazy var checkInLabelsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [checkingLabel, checkInToggle])
        stack.distribution = .equalSpacing
        stack.spacing = 10
        stack.axis = .horizontal
        return stack
    }()
    
    lazy var checkInView: UIView = {
        let view = UIView()
        view.addSubview(checkInLabelsStack)
        view.layer.borderWidth = 0.2
        view.backgroundColor = .white
        return view
    }()
    
    lazy var datePickerView: UIView = {
        let view = UIView()
        view.addSubview(dateLabel)
        view.addSubview(datePicker)
        view.layer.borderWidth = 0.2
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Work Flow"
        view.backgroundColor = .systemGray6
        configure()
        initContentViewModel()
        loadData()
        submitButton.backgroundColor = !toggleChanged ? .lightGray : .systemBlue
        //        flushSystem()
    }
    
    private func flushSystem() {
        for milestone in self.viewModel!.allMilestones! {
            self.viewModel?.deleteAll(item: milestone, vc: self, completion: { response in
                print(response)
            })
        }
    }
    
    private func changeVisibility(hidden: Bool = true) {
        self.deleteButton.isHidden = hidden
        dateLabel.isHidden = hidden
        datePicker.isHidden = hidden
        datePickerView.isHidden = hidden
    }
    
    private func initContentViewModel() {
        let testNewItem = LoMAT.Workflow.init(fromJsonFile: "workflow")
        self.viewModel = ContentViewModel(milestones: testNewItem?.stopMilestone)
    }
    
    private func loadData() {
        self.showLoadingView()
        NetworkManager.retreiveItems { [weak self] result in
            //            print(result)
            guard let self = self else { return }
            switch result {
            case .success(let milestones):
                self.dismissLoadingView()
                guard !milestones.isEmpty else {
                    self.deleteButton.isHidden = true
                    return
                }
                self.viewModel = ContentViewModel(milestones: milestones)
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    private func configure() {
        view.addSubview(stopLabel)
        view.addSubview(checkInView)
        view.addSubview(datePickerView)
        view.addSubview(submitButton)
        view.addSubview(deleteButton)
        setupConstraints()
    }
    
    func setupConstraints() {
        let padding: CGFloat = 20
        
        stopLabel.topAnchor == view.topAnchor + 100
        stopLabel.leadingAnchor == view.leadingAnchor + padding
        
        checkInView.topAnchor == stopLabel.bottomAnchor + padding
        checkInView.horizontalAnchors == view.horizontalAnchors
        checkInView.heightAnchor == 70
        
        checkInLabelsStack.topAnchor == checkInView.topAnchor + padding
        checkInLabelsStack.horizontalAnchors == checkInView.horizontalAnchors + padding
        
        datePickerView.topAnchor == checkInView.bottomAnchor
        datePickerView.horizontalAnchors == view.horizontalAnchors
        datePickerView.heightAnchor == 80
        
        dateLabel.centerYAnchor == datePicker.centerYAnchor
        dateLabel.leadingAnchor == datePickerView.leadingAnchor + padding
        
        datePicker.topAnchor == datePickerView.topAnchor
        datePicker.leadingAnchor == datePickerView.centerXAnchor - padding
        datePicker.trailingAnchor == datePickerView.trailingAnchor
        datePicker.heightAnchor == 80
        
        submitButton.topAnchor == datePickerView.bottomAnchor + 10
        submitButton.centerXAnchor == view.centerXAnchor
        submitButton.widthAnchor == 100
        
        deleteButton.topAnchor == submitButton.bottomAnchor + 10
        deleteButton.trailingAnchor == view.trailingAnchor -  10
        deleteButton.widthAnchor == 70
    }
    
}

//MARK: - Actions
extension ViewController {
    @objc private func deleteAll() {
        
        guard let milestones = self.viewModel?.allMilestones else { return }
        for milestone in milestones {
            self.deleteButton.isHidden = false
            
            self.viewModel?.deleteAll(item: milestone, vc: self, completion: { [weak self] deleted in
                
                switch deleted {
                case true:
                    self?.customAlert(title: "Deleted", message: "Deleted", buttonTitle: "ok")
                    self?.resetCheckinUI()
                case false:
                    self?.deleteButton.isHidden = true
                }
                
            })
        }
    }
    
    private func resetCheckinUI() {
        self.checkingLabel.text = "Check In"
        self.checkInToggle.isEnabled = true
        self.checkInToggle.isOn = false
        self.datePicker.isEnabled = true
        self.datePicker.date = Date()
        datePickerView.isHidden = true
        self.submitButton.setTitle("Submit", for: .normal)
        self.submitButton.backgroundColor = .systemBlue
        self.submitButton.isEnabled = true
        deleteButton.isHidden = true
    }
    
    @objc private func checkInButtonTapped(_ sender: UIButton) {
        guard toggleChanged && checkinDate != nil else {
            self.customAlert(title: "Choose Date ", message: "Trya again", buttonTitle: "ok")
            return
        }
        
        guard var currentMilestone = self.viewModel?.currentMilestone else { return }
//
//        workflow.forEach({
        guard currentMilestone.stopMilestoneType == MilestoneType.checkIn.rawValue && !currentMilestone.completed else { return }
//            guard self.viewModel?.currentMilestone?.stopMilestoneType == $0.stopMilestoneType && !$0.completed else {
//                return
//            }
//            if self.viewModel?.currentMilestone?.stopMilestoneType == $0.stopMilestoneType && !$0.completed{
                
                for question in currentMilestone.questions {
                    if question.questionName == "CheckedInDateTime" {
                        guard let checkinDate = self.checkinDate else { return }
                        //MM-dd-yyyy HH:mm
                        //"MM/dd/yyyy"
                        let date = convertDateToString(date: checkinDate, format: "MM-dd-yyyy HH:mm")
                        let currentQuestion = LoMAT.Question(id: question.id, descendants: question.descendants, questionName: question.questionName, questionType: question.questionType, style: question.style, header: question.header, questionText: question.questionText, mobileDisplayData: question.mobileDisplayData, selectedAnswer: date, availableResponses: question.availableResponses)
                        print(currentQuestion)
                        print("before ", currentMilestone.questions.first(where: {$0.questionName == question.questionName }))
                        
                        guard let Q = currentMilestone.questions.firstIndex(where: {$0.questionName == question.questionName }) else { return }
                        currentMilestone.questions.remove(at: Q)
                        
                        print("when removing :", currentMilestone.questions.first(where: {$0.questionName == question.questionName }))
                        
                        currentMilestone.questions.insert(currentQuestion, at: Q)
                        currentMilestone.completed = true
                    }
                }
//            }
//        })
        
        self.viewModel?.currentMilestone = currentMilestone
//        guard let milestonToSave = self.viewModel?.currentMilestone else { return }
        
        self.viewModel?.checkIn(item: currentMilestone, vc: self, completion: { saved in
            switch saved {
            case true:
                self.deleteButton.isHidden = false
                self.checkInToggle.isEnabled = false
                self.datePicker.isEnabled = false
                self.submitButton.setTitle("Submitted", for: .normal)
                self.submitButton.setTitleColor(.systemBlue, for: .disabled)
                self.submitButton.backgroundColor = .clear
                self.submitButton.isEnabled = false
            case false:
                self.customAlert(title: "Ehh something is wrong", message: "not saved", buttonTitle: "Try again..")
                break
            }
        })
    }
}

public typealias VoidClosure = () -> Void

