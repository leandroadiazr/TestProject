//
//  ViewController.swift
//  TestProject
//
//  Created by Leandro Diaz on 3/15/22.
//

import UIKit
import Anchorage
import M13Checkbox
import CoreLocation

enum MilestoneType: String, CaseIterable {
    case checkIn = "CHECK_IN"
    case loaded = "LOADED"
    case upload = "UPLOAD"
}

class MilestonesViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    
    lazy var stopLabel: UILabel = {
        let label = CustomTitleLabel(textAlignment: .left, fontSize: 16, text: "Pick 1 - Walmart Supercenter")
        return label
    }()
    
    var viewModel: ContentViewModel? {
        didSet {
            guard let milestones = viewModel?.allMilestones else { return }
            
            //MARK: CHECKIN MILESTONE
            guard let checkInMilestone = milestones.first(where: { $0.stopMilestoneType == MilestoneType.checkIn.rawValue }) else { return }
            
            if checkInMilestone.completed {
                self.isCheckinCompleted(milestone: checkInMilestone)
            } else {
                self.changeCheckinVisibility(completed: false)
                checkinSeparator.isHidden = false
                checkinPickerSeparator.isHidden = false
            }
            
            guard let loadedMilestone = milestones.first(where: { $0.stopMilestoneType == MilestoneType.loaded.rawValue }) else { return }
            if loadedMilestone.completed {
                self.isloadedCompleted(milestone: loadedMilestone)
            } else {
                self.changeLoadedVisibility(completed: false)
                loadedSeparator.isHidden = false
                loadedPickerSeparator.isHidden = false
            }
            
            guard let uploadMilestone = milestones.first(where: { $0.stopMilestoneType == MilestoneType.upload.rawValue }) else { return }
            if uploadMilestone.completed {
                //upload milestone
            } else {
                //upload milestone
            }
            
            viewModel?.currentMilestone = viewModel?.allMilestones?.first(where: {$0.completed == false })
            setCurrentMarker(milestone: viewModel?.currentMilestone)
            print("current milestone :", viewModel?.currentMilestone?.stopMilestoneType as Any)
            
            viewModel?.currentLocation = getLoacation()
        }
    }
    
    //MARK: -CHECK IN FUNTIONALITIES
    private func isCheckinCompleted(milestone: LoMAT.StopMilestone) {
        self.deleteButton.isHidden = false
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
        self.changeCheckinVisibility(completed: true)
        checkInSubmitButton.backgroundColor = .clear
        checkinSeparator.isHidden = true
    }
    
    
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
        toggle.tag = 1
        return toggle
    }()
    
    @objc private func toggleChangedValue(_ toggle: UISwitch) {
        //check in
        if toggle.tag == 1 {
            checkinToggleChanged = toggle.isOn ? true : false
            print(checkinToggleChanged)
        }
        
        //loaded
        if toggle.tag == 2 {
            loadedToggleChanged = toggle.isOn ? true : false
            print(loadedToggleChanged)
        }
    }
    
    private var checkinToggleChanged: Bool = false {
        didSet {
            checkInToggle.isOn = checkinToggleChanged
            changeCheckinVisibility(completed: checkinToggleChanged)
            checkInSubmitButton.backgroundColor = !checkinToggleChanged ? .lightGray : .systemBlue
        }
    }
    
    //MARK: - Date Picker
    lazy var checkinPickerSeparator: UIView = {
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
    
    //MARK: - Check in Submit Button
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
        view.addSubview(checkinPickerSeparator)
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
    //MARK: - LOADED
    //MARK: - LOADED
    //MARK: - LOADED
    //MARK: - LOADED
    private func isloadedCompleted(milestone: LoMAT.StopMilestone) {
        loadedSeparator.isHidden = true
        loadedToggle.isOn = true
        loadedToggle.isEnabled = false
        loadedSubmitButton.setTitle("Submited", for: .normal)
        loadedSubmitButton.isEnabled = false
        loadedSubmitButton.setTitleColor(.systemBlue, for: .disabled)
        guard let milestones = self.viewModel?.allMilestones?.first(where: { $0.stopMilestoneType == MilestoneType.loaded.rawValue }) else { return }
        guard let dateQuestion = milestones.questions.first(where: { $0.questionName == "LoadedTime" }) else { return }
        if let date = dateQuestion.selectedAnswer {
            loadedDatePicker.date = convertToDate(string: date, format: "MM-dd-yyyy HH:mm")
            loadedDatePicker.isEnabled = false
        }
        guard let issuesQuestion = milestones.questions.first(where: { $0.questionName == "issues" }) else { return }
        
        configureSelectedBox(issues: issuesQuestion.selectedAnswer == "Yes" ? true : false)
        
        self.changeLoadedVisibility(completed: true)
        loadedSeparator.isHidden = true
        loadedPickerSeparator.isHidden = true
    }
    
    private func configureSelectedBox(issues: Bool = false ) {
        switch issues {
        case true:
            self.problemCheckBox.checkBox.checkState = .checked
            self.problemCheckBox.checkBox.stateChangeAnimation = .fill
        case false:
            self.noIssuesCheckBox.checkBox.checkState = .checked
            self.noIssuesCheckBox.checkBox.stateChangeAnimation = .fill
        }
    }
    
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
        toggle.addTarget(self, action: #selector(toggleChangedValue), for: .valueChanged)
        toggle.tag = 2
        return toggle
    }()
    
    
    private var loadedToggleChanged: Bool = false {
        didSet {
            loadedToggle.isOn = loadedToggleChanged
            changeLoadedVisibility(completed: loadedToggleChanged)
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
    
    lazy var loadedPickerSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.widthAnchor == 8
        return view
    }()
    
    lazy var loadedDateLabel: UILabel = {
        let label = CustomTitleLabel(textAlignment: .left, fontSize: 14, text: "Time")
        return label
    }()
    
    lazy var loadedDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .compact
        picker.addTarget(self, action: #selector(loadedDateSelected), for: .editingDidEnd)
        return picker
    }()
    
    lazy var loadedDatePickerView: UIView = {
        let view = UIView()
        view.addSubview(loadedPickerSeparator)
        view.addSubview(loadedDateLabel)
        view.addSubview(loadedDatePicker)
        view.layer.borderWidth = 0.2
        view.backgroundColor = .white
        return view
    }()
    
    @objc func loadedDateSelected(_ picker: UIDatePicker) {
        loadedDate = picker.date
    }
    
    private var loadedDate: Date? {
        didSet {
            if let date = loadedDate {
                loadedDatePicker.date = date
                print("Loaded date", date)
            }
        }
    }
    
    
    let loadedMainQuestionTitle = CustomTitleLabel(textAlignment: .left, fontSize: 14, text: "Were there any issues?")
    
    lazy var loadedQuestionSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.widthAnchor == 8
        return view
    }()
    
    lazy var problemCheckBox: RadioButton = {
        let button = RadioButton(fillColor: .systemRed, questionLabel: "Problems", questionImage: "hand.thumbsdown")
        button.tag = 1
        button.selectedAnswer = {
            self.selectedAnswerValue(button)
            print("seleted issues")
        }
        return button
    }()
    
    lazy var noIssuesCheckBox: RadioButton = {
        let button = RadioButton(fillColor: .systemBlue, questionLabel: "No Issues", questionImage: "hand.thumbsup")
        button.tag = 2
        button.selectedAnswer = {
            self.selectedAnswerValue(button)
            print("seleted issues")
        }
        return button
    }()
    
    @objc private func selectedAnswerValue(_ box: RadioButton) {
        switch box.tag {
        case 1:
            problemCheckBox.checkBox.stateChangeAnimation = .fill
            noIssuesCheckBox.checkBox.checkState = .unchecked
            selectedAnswer = "Yes"
        case 2:
            noIssuesCheckBox.checkBox.stateChangeAnimation = .fill
            problemCheckBox.checkBox.checkState = .unchecked
            selectedAnswer = "No"
        default:
            break
        }
    }
    
    private var selectedAnswer: String? {
        didSet {
            print(selectedAnswer as Any)
        }
    }
    
    lazy var loadedQuestionStack: UIView = {
        let stack = UIView()
        stack.addSubview(loadedQuestionSeparator)
        stack.addSubview(loadedMainQuestionTitle)
        stack.addSubview(problemCheckBox)
        stack.addSubview(noIssuesCheckBox)
        stack.backgroundColor = .white
        stack.layer.borderWidth = 0.2
        return stack
    }()
    
    //MARK: - Loaded Submit Button
    lazy var loadedSubmitButton: UIButton = {
        let btn = CustomButton(backgroundColor: .systemBlue, title: "Submit")
        btn.addTarget(self, action: #selector(loadedButtonTapped(_:)), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - LOADED VIEW PIECES TOGETHER
    lazy var loadedView: UIView = {
        let view = UIView()
        view.addSubview(loadedSeparator)
        view.addSubview(loadedLabelSwitchStack)
        view.backgroundColor = .white
        view.layer.borderWidth = 0.2
        return view
    }()
    
    
    //MARK: -- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Work Flow"
        view.backgroundColor = .systemGray6
        configure()
        initContentViewModel()
        
        //                        flushSystem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        checkInSubmitButton.backgroundColor = !checkinToggleChanged ? .clear : .systemBlue
        loadedSubmitButton.backgroundColor = !loadedToggleChanged ? .clear : .systemBlue
    }
    
    private func flushSystem() {
        for milestone in self.viewModel!.allMilestones! {
            self.viewModel?.deleteAll(item: milestone, vc: self, completion: { response in
                print(response)
            })
        }
    }
    
    private func changeCheckinVisibility(completed: Bool = false) {
        self.deleteButton.isHidden = !completed
        checkInDateLabel.isHidden = !completed
        checkInDatePicker.isHidden = !completed
        checkInDatePickerView.isHidden = !completed
    }
    
    private func changeLoadedVisibility(completed: Bool = false) {
        self.deleteButton.isHidden = !completed
        loadedDateLabel.isHidden = !completed
        loadedDatePicker.isHidden = !completed
        loadedDatePickerView.isHidden = !completed
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
            case .success(var savedMilestones):
                self.dismissLoadingView()
                guard !savedMilestones.isEmpty else {
                    self.deleteButton.isHidden = true
                    return
                }
                
                guard let allMilestones = self.viewModel?.allMilestones else { return }
                var notSavedMilestone: LoMAT.StopMilestone!
                
                for singleMilestone in allMilestones {
                    if !savedMilestones.contains(singleMilestone) {
                        notSavedMilestone = singleMilestone
                    }
                }
                savedMilestones.append(notSavedMilestone)
                self.viewModel?.currentMilestone = notSavedMilestone
                self.viewModel = ContentViewModel(milestones: savedMilestones)
                
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    private func setCurrentMarker(milestone: LoMAT.StopMilestone?) {
        let separators = [checkinSeparator, checkinPickerSeparator, loadedSeparator, loadedPickerSeparator, loadedQuestionSeparator]
        for item in separators {
            item.isHidden = true
        }
        
        switch milestone?.stopMilestoneType {
        case "CHECK_IN":
            checkinSeparator.isHidden = false
            checkinPickerSeparator.isHidden = false
        case "LOADED":
            loadedSeparator.isHidden = false
            loadedPickerSeparator.isHidden = false
            loadedQuestionSeparator.isHidden = false
        case "UPLOAD":
            break
        default:
            break
        }
    }
    
    private func configure() {
        view.addSubview(stopLabel)
        view.addSubview(checkInView)
        view.addSubview(checkInDatePickerView)
        view.addSubview(checkInSubmitButton)
        view.addSubview(deleteButton)
        view.addSubview(loadedView)
        view.addSubview(loadedDatePickerView)
        view.addSubview(loadedQuestionStack)
        view.addSubview(loadedSubmitButton)
        setupConstraints()
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
    
    
    //MARK: CHECK IN BUTTON ACTION
    @objc private func checkInButtonTapped(_ sender: UIButton) {
        guard checkinToggleChanged && checkinDate != nil else {
            self.customAlert(title: "Choose Date ", message: "Trya again", buttonTitle: "ok")
            return
        }
        
        guard var allMilestones = self.viewModel?.allMilestones else { return }
        
        guard var checkinMilestone = allMilestones.first(where: { $0.stopMilestoneType == MilestoneType.checkIn.rawValue }), !checkinMilestone.completed else { return }
        
        for question in checkinMilestone.questions {
            switch question.questionName {
            case "CheckedInDateTime":
                guard let checkinDate = self.checkinDate else { return }
                //MM-dd-yyyy HH:mm
                //"MM/dd/yyyy"
                let date = convertDateToString(date: checkinDate, format: "MM-dd-yyyy HH:mm")
                let currentQuestion = LoMAT.Question(id: question.id, descendants: question.descendants, questionName: question.questionName, questionType: question.questionType, style: question.style, header: question.header, questionText: question.questionText, mobileDisplayData: question.mobileDisplayData, selectedAnswer: date, availableResponses: question.availableResponses)
                
                guard let QIndex = checkinMilestone.questions.firstIndex(where: {$0.questionName == question.questionName }) else { return }
                checkinMilestone.questions.remove(at: QIndex)
                checkinMilestone.questions.insert(currentQuestion, at: QIndex)
            case "CheckedInSubmit":
                guard let currentLocation = self.viewModel?.currentLocation else { return }
                let currentQuestion = LoMAT.Question(id: question.id, descendants: question.descendants, questionName: question.questionName, questionType: question.questionType, style: question.style, header: question.header, questionText: question.questionText, mobileDisplayData: question.mobileDisplayData, selectedAnswer: currentLocation, availableResponses: question.availableResponses)
                guard let QuestionIndex = checkinMilestone.questions.firstIndex(where: {$0.questionName == question.questionName }) else { return }
                checkinMilestone.questions.remove(at: QuestionIndex)
                
                checkinMilestone.questions.insert(currentQuestion, at: QuestionIndex)
                checkinMilestone.completed = true
                
            default:
                break
            }
            
            //UPDATE MILESTONE
            print(checkinMilestone)
            guard let MilestoneIndex = allMilestones.firstIndex(where: {$0.stopMilestoneType == checkinMilestone.stopMilestoneType }) else { return }
            allMilestones.remove(at: MilestoneIndex)
            
            allMilestones.insert(checkinMilestone, at: MilestoneIndex)
            checkinMilestone.completed = true
            self.viewModel = ContentViewModel(milestones: allMilestones)
        }
        
        self.viewModel?.checkIn(item: checkinMilestone, vc: self, completion: { saved in
            switch saved {
            case true:
                self.deleteButton.isHidden = false
                self.checkInToggle.isEnabled = false
                self.checkInDatePicker.isEnabled = false
                self.checkInSubmitButton.setTitle("Submitted", for: .normal)
                self.checkInSubmitButton.setTitleColor(.systemBlue, for: .disabled)
                self.checkInSubmitButton.backgroundColor = .clear
                self.checkInSubmitButton.isEnabled = false
                self.viewModel?.currentMilestone = self.viewModel?.allMilestones?.first(where: { $0.completed == false })
                print("Next milestone = ", self.viewModel?.currentMilestone)
            case false:
                self.customAlert(title: "Ehh something is wrong", message: "not saved", buttonTitle: "Try again..")
                break
            }
        })
    }
    
    //MARK: LOADED BUTTON ACTION
    @objc private func loadedButtonTapped(_ sender: UIButton) {
        guard loadedToggleChanged && loadedDate != nil else {
            self.customAlert(title: "Choose Date ", message: "Trya again", buttonTitle: "ok")
            return
        }
        guard var allMilestones = self.viewModel?.allMilestones else { return }
        
        guard var loadedMilestone = self.viewModel?.currentMilestone else { return }
        
        guard loadedMilestone.stopMilestoneType == MilestoneType.loaded.rawValue && !loadedMilestone.completed else { return }
        
        
        for question in loadedMilestone.questions {
            switch question.questionName {
            case "LoadedTime":
                guard let loadedDate = self.loadedDate else { return }
                //MM-dd-yyyy HH:mm
                //"MM/dd/yyyy"
                let date = convertDateToString(date: loadedDate, format: "MM-dd-yyyy HH:mm")
                let currentQuestion = LoMAT.Question(id: question.id, descendants: question.descendants, questionName: question.questionName, questionType: question.questionType, style: question.style, header: question.header, questionText: question.questionText, mobileDisplayData: question.mobileDisplayData, selectedAnswer: date, availableResponses: question.availableResponses)
                
                guard let QuestionIndex = loadedMilestone.questions.firstIndex(where: {$0.questionName == question.questionName }) else { return }
                loadedMilestone.questions.remove(at: QuestionIndex)
                loadedMilestone.questions.insert(currentQuestion, at: QuestionIndex)
            case "issues":
                guard selectedAnswer != nil else {
                    self.customAlert(title: "Choose an answer", message: "Were there any issues?", buttonTitle: "Ok")
                    return
                }
                
                let currentQuestion = LoMAT.Question(id: question.id, descendants: question.descendants, questionName: question.questionName, questionType: question.questionType, style: question.style, header: question.header, questionText: question.questionText, mobileDisplayData: question.mobileDisplayData, selectedAnswer: selectedAnswer, availableResponses: question.availableResponses)
                guard let QuestionIndex = loadedMilestone.questions.firstIndex(where: {$0.questionName == question.questionName }) else { return }
                loadedMilestone.questions.remove(at: QuestionIndex)
                
                loadedMilestone.questions.insert(currentQuestion, at: QuestionIndex)
                loadedMilestone.completed = true
                
            case "CommodityConfirm":
                break
            case "ConfirmNextStop":
                break
            case "NextStopETA":
                break
            case "LoadedSubmit":
                break
            case .none:
                break
            case .some(_):
                break
            }
            
        }
        
        guard let MilestoneIndex = allMilestones.firstIndex(where: {$0.stopMilestoneType == loadedMilestone.stopMilestoneType }) else { return }
        allMilestones.remove(at: MilestoneIndex)
        
        allMilestones.insert(loadedMilestone, at: MilestoneIndex)
        loadedMilestone.completed = true
        self.viewModel = ContentViewModel(milestones: allMilestones)
        
        
        self.viewModel?.checkIn(item: loadedMilestone, vc: self, completion: { saved in
            switch saved {
            case true:
                self.deleteButton.isHidden = false
                self.loadedToggle.isEnabled = false
                self.loadedDatePicker.isEnabled = false
                self.loadedSubmitButton.setTitle("Submitted", for: .normal)
                self.loadedSubmitButton.setTitleColor(.systemBlue, for: .disabled)
                self.loadedSubmitButton.backgroundColor = .clear
                self.loadedSubmitButton.isEnabled = false
                self.viewModel?.currentMilestone = self.viewModel?.allMilestones?.first(where: { $0.completed == false })
                print("Next milestone = ", self.viewModel?.currentMilestone as? Any)
            case false:
                self.customAlert(title: "Ehh something is wrong", message: "not saved", buttonTitle: "Try again..")
                break
            }
        })
    }
    
    private func getLoacation() -> String {
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        print(locationManager.location)
        
        return String(describing: locationManager.location)
    }
    
}

public typealias VoidClosure = () -> Void



extension MilestonesViewController {
    
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
        
        checkinPickerSeparator.verticalAnchors == checkInDatePickerView.verticalAnchors
        
        checkInDatePickerView.topAnchor == checkInView.bottomAnchor
        checkInDatePickerView.horizontalAnchors == view.horizontalAnchors
        checkInDatePickerView.heightAnchor == 80
        
        checkInDateLabel.centerYAnchor == checkInDatePicker.centerYAnchor
        checkInDateLabel.leadingAnchor == checkInDatePickerView.leadingAnchor + padding
        
        checkInDatePicker.topAnchor == checkInDatePickerView.topAnchor
        checkInDatePicker.leadingAnchor == checkInDatePickerView.centerXAnchor - padding
        checkInDatePicker.trailingAnchor == checkInDatePickerView.trailingAnchor - padding
        checkInDatePicker.heightAnchor == 80
        
        checkInSubmitButton.topAnchor == checkInDatePickerView.bottomAnchor + 10
        checkInSubmitButton.centerXAnchor == view.centerXAnchor
        checkInSubmitButton.widthAnchor == 100
        
        
        //MARK: - LOADED
        
        loadedView.topAnchor == checkInSubmitButton.bottomAnchor + padding
        loadedView.horizontalAnchors == view.horizontalAnchors
        loadedView.heightAnchor == 70
        
        loadedSeparator.verticalAnchors == loadedView.verticalAnchors
        
        loadedLabelSwitchStack.centerYAnchor == loadedView.centerYAnchor
        loadedLabelSwitchStack.horizontalAnchors == loadedView.horizontalAnchors + padding
        
        //date picker view
        loadedDatePickerView.topAnchor == loadedView.bottomAnchor
        loadedDatePickerView.horizontalAnchors == loadedView.horizontalAnchors
        loadedDatePickerView.heightAnchor == 80
        
        loadedPickerSeparator.verticalAnchors == loadedDatePickerView.verticalAnchors
        
        loadedDateLabel.leadingAnchor == loadedDatePickerView.leadingAnchor + padding
        loadedDateLabel.centerYAnchor == loadedDatePickerView.centerYAnchor
        loadedDatePicker.trailingAnchor == loadedDatePickerView.trailingAnchor - padding
        loadedDatePicker.centerYAnchor == loadedDatePickerView.centerYAnchor
        
        
        //questions
        
        loadedQuestionStack.topAnchor == loadedDatePickerView.bottomAnchor
        loadedQuestionStack.horizontalAnchors == loadedView.horizontalAnchors
        loadedQuestionStack.heightAnchor == 100
        
        loadedMainQuestionTitle.topAnchor == loadedQuestionStack.topAnchor + 5
        loadedMainQuestionTitle.leadingAnchor == loadedView.leadingAnchor + padding
        
        loadedQuestionSeparator.verticalAnchors == loadedQuestionStack.verticalAnchors
        
        problemCheckBox.centerYAnchor == loadedQuestionStack.centerYAnchor
        problemCheckBox.leadingAnchor == loadedQuestionStack.leadingAnchor + padding
        problemCheckBox.heightAnchor == 50
        
        noIssuesCheckBox.leadingAnchor == loadedQuestionStack.centerXAnchor + padding
        noIssuesCheckBox.centerYAnchor == loadedQuestionStack.centerYAnchor
        noIssuesCheckBox.heightAnchor == 50
        
        loadedSubmitButton.topAnchor == loadedQuestionStack.bottomAnchor + 10
        loadedSubmitButton.centerXAnchor == view.centerXAnchor
        loadedSubmitButton.widthAnchor == 100
        
        deleteButton.topAnchor == loadedSubmitButton.bottomAnchor + 10
        deleteButton.trailingAnchor == view.trailingAnchor -  10
        deleteButton.widthAnchor == 70
    }
}
