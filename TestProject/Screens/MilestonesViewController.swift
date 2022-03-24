//
//  ViewController.swift
//  TestProject
//
//  Created by Leandro Diaz on 3/15/22.
//

import UIKit
import Anchorage
import M13Checkbox

enum MilestoneType: String, CaseIterable {
    case checkIn = "CHECK_IN"
    case loaded = "LOADED"
    case upload = "UPLOAD"
}




class MilestonesViewController: UIViewController {
    
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
    //MARK: -CHECK IN FUNTIONALITIES
    private func isCheckinCompleted(milestone: LoMAT.StopMilestone) {
        self.checkingLabel.text = "Already checked in"
        checkInToggle.isOn = true
        checkInToggle.isEnabled = false
        checkInSubmitButton.setTitle("Submited", for: .normal)
        checkInSubmitButton.isEnabled = false
        checkInSubmitButton.setTitleColor(.systemBlue, for: .disabled)
        guard let milestones = self.viewModel?.allMilestones?.first(where: { $0.stopMilestoneType == MilestoneType.checkIn.rawValue }) else { return }
        guard let dateQuestion = milestones.questions.first(where: { $0.questionName == "CheckedInDateTime" }) else { return }
        if let date = dateQuestion.selectedAnswer {
            checkInDatePicker.date = convertToDate(string: date, format: "MM-dd-yyyy HH:mm")
            checkInDatePicker.isEnabled = false
        }
        self.changeVisibility(hidden: false)
        checkInSubmitButton.backgroundColor = .clear
    }
    
    lazy var stopLabel: UILabel = {
        let label = CustomTitleLabel(textAlignment: .left, fontSize: 16, text: "Pick 1 - Walmart Supercenter")
        return label
    }()
    
    //MARK: CHECK IN
    //MARK: - Toggle Button
    lazy var checkinSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.widthAnchor == 8
        return view
    }()
    
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
            checkInSubmitButton.backgroundColor = !toggleChanged ? .lightGray : .systemBlue
        }
    }
    
    //MARK: - Date Picker
    lazy var pickerSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.widthAnchor == 8
        return view
    }()
    
    lazy var checkInDateLabel: UILabel = {
        let label = CustomTitleLabel(textAlignment: .left, fontSize: 14, text: "Time")
        return label
    }()
    
    lazy var checkInDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .automatic
        picker.addTarget(self, action: #selector(checkInDateSelected), for: .editingDidEnd)
        return picker
    }()
    
    @objc func checkInDateSelected(_ picker: UIDatePicker) {
        checkinDate = picker.date
    }
    
    private var checkinDate: Date? {
        didSet {
            if let date = checkinDate {
                checkInDatePicker.date = date
                print(date)
            }
        }
    }
    
    //MARK: - Submit Button
    lazy var checkInSubmitButton: UIButton = {
        let btn = CustomButton(backgroundColor: .systemBlue, title: "Submit")
        btn.addTarget(self, action: #selector(checkInButtonTapped(_:)), for: .touchUpInside)
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
        view.addSubview(checkinSeparator)
        view.addSubview(checkInLabelsStack)
        view.layer.borderWidth = 0.2
        view.backgroundColor = .white
        return view
    }()
    
    lazy var checkInDatePickerView: UIView = {
        let view = UIView()
        view.addSubview(pickerSeparator)
        view.addSubview(checkInDateLabel)
        view.addSubview(checkInDatePicker)
        view.layer.borderWidth = 0.2
        view.backgroundColor = .white
        return view
    }()
    
    //MARK: - END CHECK IN
    //MARK: - END CHECK IN
    
    //MARK: shared
    lazy var deleteButton: UIButton = {
        let btn = CustomButton(backgroundColor: .systemRed, title: "delete")
        btn.addTarget(self, action: #selector(deleteAll), for: .touchUpInside)
        return btn
    }()
    
    
    
    //MARK: - LOADED
    //MARK: - LOADED
    
    lazy var loadedSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.widthAnchor == 8
        return view
    }()
    
    lazy var loadedLabel: UILabel = {
        let label = CustomTitleLabel(textAlignment: .left, fontSize: 14, text: "Loaded")
        return label
    }()
    
    lazy var loadedToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .systemGreen
        return toggle
    }()
    
    private var loadedToggleChanged: Bool = false {
        didSet {
            loadedToggle.isOn = loadedToggleChanged
        }
    }
    
    lazy var loadedLabelSwitchStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [loadedLabel, loadedToggle])
        stack.distribution = .equalSpacing
        stack.spacing = 10
        stack.axis = .horizontal
        return stack
    }()
    
    //MARK: - loaded picker
    
    lazy var loadedTimeLabel: UILabel = {
        let label = CustomTitleLabel(textAlignment: .left, fontSize: 14, text: "Time")
        return label
    }()
    
    lazy var loadedDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .compact
        picker.addTarget(self, action: #selector(checkInDateSelected), for: .editingDidEnd)
        return picker
    }()
    
    lazy var loadedStackPickerView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [loadedTimeLabel, loadedDatePicker])
        stack.distribution = .equalSpacing
        stack.spacing = 10
        stack.axis = .horizontal
        return stack
    }()
    
    let loadedMainQuestionTitle = CustomTitleLabel(textAlignment: .left, fontSize: 14, text: "Were there any issues?")
    
    lazy var loadedQuestionSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.widthAnchor == 8
        return view
    }()
    
    lazy var selectedCheckBoxOne: M13Checkbox = {
       let checkbox = M13Checkbox()
//        checkbox.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        checkbox.boxType = .circle
        checkbox.markType = .radio
        checkbox.checkState = .unchecked
        checkbox.tintColor = .red
        checkbox.backgroundColor = .yellow
        checkbox.heightAnchor == 20
        checkbox.widthAnchor == 20
        return checkbox
    }()
             
    lazy var thumbsImageDown: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "hand.thumbsdown"))
        view.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        let img = UIImage(systemName: "hand.thumbsdown")
        return view
    }()
    
    lazy var questionProblemsLabel: UILabel = {
        let label = CustomTitleLabel(textAlignment: .left, fontSize: 11, text: "Problems")
        return label
    }()
    
    lazy var selectedCheckBoxTwo: M13Checkbox = {
       let checkbox = M13Checkbox()
        checkbox.boxType = .circle
        checkbox.markType = .radio
        checkbox.checkState = .unchecked
        checkbox.tintColor = .red
        checkbox.heightAnchor == 15
        checkbox.widthAnchor == 15
        return checkbox
    }()
             
    lazy var thumbsImageUp: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "hand.thumbsup"))
        return view
    }()
    
    lazy var questionNoIssuesLabel: UILabel = {
        let label = CustomTitleLabel(textAlignment: .left, fontSize: 11, text: "No Issues")
        return label
    }()
    
    lazy var loadedQuestionStack: UIView = {
        let stack = UIView()
        stack.addSubview(loadedQuestionSeparator)
        stack.addSubview(loadedMainQuestionTitle)
        stack.addSubview(selectedCheckBoxOne)
        stack.addSubview(thumbsImageDown)
        stack.addSubview(questionProblemsLabel)
        
        stack.addSubview(selectedCheckBoxTwo)
        stack.addSubview(thumbsImageUp)
        stack.addSubview(questionNoIssuesLabel)
        stack.backgroundColor = .white
        stack.layer.borderWidth = 0.2
        return stack
    }()
    
    //MARK: - LOADED VIEW PIECES TOGETHER
    lazy var loadedView: UIView = {
        let view = UIView()
        view.addSubview(loadedSeparator)
        view.addSubview(loadedLabelSwitchStack)
        view.addSubview(loadedStackPickerView)
        view.addSubview(loadedQuestionStack)
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        return view
    }()


    
    //MARK: -- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(selectedCheckBoxOne)
        title = "Work Flow"
        view.backgroundColor = .systemGray6
        configure()
        initContentViewModel()
        loadData()
        checkInSubmitButton.backgroundColor = !toggleChanged ? .lightGray : .systemBlue
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
        checkInDateLabel.isHidden = hidden
        checkInDatePicker.isHidden = hidden
        checkInDatePickerView.isHidden = hidden
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
        view.addSubview(checkInDatePickerView)
        view.addSubview(checkInSubmitButton)
//        view.addSubview(deleteButton)
        view.addSubview(loadedView)
        setupConstraints()
    }

    
    func setupConstraints() {
        let padding: CGFloat = 20
        
        stopLabel.topAnchor == view.topAnchor + 100
        stopLabel.leadingAnchor == view.leadingAnchor + padding
        
        //MARK: - CEHCK IN
        checkInView.topAnchor == stopLabel.bottomAnchor + padding
        checkInView.horizontalAnchors == view.horizontalAnchors
        checkInView.heightAnchor == 70
        
        checkinSeparator.verticalAnchors == checkInView.verticalAnchors
        
        checkInLabelsStack.topAnchor == checkInView.topAnchor + padding
        checkInLabelsStack.horizontalAnchors == checkInView.horizontalAnchors + padding
        
        pickerSeparator.verticalAnchors == checkInDatePickerView.verticalAnchors
        
        checkInDatePickerView.topAnchor == checkInView.bottomAnchor
        checkInDatePickerView.horizontalAnchors == view.horizontalAnchors
        checkInDatePickerView.heightAnchor == 80
        
        checkInDateLabel.centerYAnchor == checkInDatePicker.centerYAnchor
        checkInDateLabel.leadingAnchor == checkInDatePickerView.leadingAnchor + padding
        
        checkInDatePicker.topAnchor == checkInDatePickerView.topAnchor
        checkInDatePicker.leadingAnchor == checkInDatePickerView.centerXAnchor - padding
        checkInDatePicker.trailingAnchor == checkInDatePickerView.trailingAnchor
        checkInDatePicker.heightAnchor == 80
        
        checkInSubmitButton.topAnchor == checkInDatePickerView.bottomAnchor + 10
        checkInSubmitButton.centerXAnchor == view.centerXAnchor
        checkInSubmitButton.widthAnchor == 100
        
        
        //MARK: - LOADED
        
        loadedView.topAnchor == checkInSubmitButton.bottomAnchor + padding
        loadedView.horizontalAnchors == view.horizontalAnchors
        loadedView.heightAnchor == 200
        
        loadedSeparator.verticalAnchors == loadedView.verticalAnchors
//        loadedSeparator.leadingAnchor == view.leadingAnchor
        
        loadedLabelSwitchStack.topAnchor == loadedView.topAnchor + padding
        loadedLabelSwitchStack.horizontalAnchors == loadedView.horizontalAnchors + padding
        loadedView.heightAnchor == 70

        loadedStackPickerView.topAnchor == loadedLabelSwitchStack.bottomAnchor + 2
        loadedStackPickerView.horizontalAnchors == loadedView.horizontalAnchors + padding
        loadedStackPickerView.heightAnchor == 80
        
        loadedQuestionStack.topAnchor == loadedStackPickerView.bottomAnchor + 2
        loadedQuestionStack.horizontalAnchors == loadedView.horizontalAnchors
        loadedQuestionStack.heightAnchor == 100
        
        
        loadedMainQuestionTitle.topAnchor == loadedQuestionStack.topAnchor + 5
        loadedMainQuestionTitle.leadingAnchor == loadedView.leadingAnchor + padding
        
        loadedQuestionSeparator.verticalAnchors == loadedQuestionStack.verticalAnchors

        selectedCheckBoxOne.centerYAnchor == loadedQuestionStack.centerYAnchor
        selectedCheckBoxOne.leadingAnchor == loadedQuestionStack.leadingAnchor + padding * 2
        
        thumbsImageDown.leadingAnchor == selectedCheckBoxOne.trailingAnchor + padding
        thumbsImageDown.centerYAnchor == loadedQuestionStack.centerYAnchor
        
        questionNoIssuesLabel.leadingAnchor == thumbsImageDown.trailingAnchor + padding
        questionNoIssuesLabel.centerYAnchor == loadedQuestionStack.centerYAnchor
        
        
        selectedCheckBoxTwo.leadingAnchor == loadedQuestionStack.centerXAnchor + padding
        selectedCheckBoxTwo.centerYAnchor == loadedQuestionStack.centerYAnchor
        
        thumbsImageUp.leadingAnchor == selectedCheckBoxTwo.trailingAnchor + padding
        thumbsImageUp.centerYAnchor == loadedQuestionStack.centerYAnchor
        
        questionProblemsLabel.leadingAnchor == thumbsImageUp.trailingAnchor + padding
        questionProblemsLabel.centerYAnchor == loadedQuestionStack.centerYAnchor
        
//        deleteButton.topAnchor == loadedView.bottomAnchor + 10
//        deleteButton.trailingAnchor == view.trailingAnchor -  10
//        deleteButton.widthAnchor == 70
    }
    
}

//MARK: - Actions
extension MilestonesViewController {
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
        self.checkInDatePicker.isEnabled = true
        self.checkInDatePicker.date = Date()
        checkInDatePickerView.isHidden = true
        self.checkInSubmitButton.setTitle("Submit", for: .normal)
        self.checkInSubmitButton.backgroundColor = .systemBlue
        self.checkInSubmitButton.isEnabled = true
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
                self.checkInDatePicker.isEnabled = false
                self.checkInSubmitButton.setTitle("Submitted", for: .normal)
                self.checkInSubmitButton.setTitleColor(.systemBlue, for: .disabled)
                self.checkInSubmitButton.backgroundColor = .clear
                self.checkInSubmitButton.isEnabled = false
            case false:
                self.customAlert(title: "Ehh something is wrong", message: "not saved", buttonTitle: "Try again..")
                break
            }
        })
    }
}

public typealias VoidClosure = () -> Void

