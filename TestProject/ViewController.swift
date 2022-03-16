//
//  ViewController.swift
//  TestProject
//
//  Created by Leandro Diaz on 3/15/22.
//

import UIKit
import Anchorage


//MARK: MODEL
struct WorkFlow: Codable, Hashable {
    
    //CHECKIN MILESTONE
    var milesstoneId: Int?
    var checkinDate: Date?
    var milestoneCompleted: Bool?
    
    //LOADED MILESTONE
//    var loadedId: Int?
//    var answer: String
    
    //
    
    
}

//MARK: CONTENTVIEWMODEL
class ContentViewModel {
    var checkInMilestone = [WorkFlow]()
    
    init(milestone: WorkFlow?) {
        if let milestone = milestone {
            self.checkInMilestone.append(milestone)
        }
    }
    
    func checkIn(item: WorkFlow, vc: UIViewController, completion: @escaping (Bool) -> Void) {
        vc.showLoadingView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        NetworkManager.updateWith(WorkFlowItem: item, actionType: .add) { error in
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
    
    func deleteAll(item: WorkFlow, vc: UIViewController, completion: @escaping (Bool) -> Void) {
        vc.showLoadingView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            NetworkManager.updateWith(WorkFlowItem: item, actionType: .remove) { error in
                vc.dismissLoadingView()
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
            guard let milestones = viewModel?.checkInMilestone else { return }

            for milestone in milestones {
                if milestone.milestoneCompleted == true {
                    self.checkingLabel.text = "Already checked in"
                    checkInToggle.isOn = true
                    checkInToggle.isEnabled = false
                    submitButton.setTitle("Submited", for: .normal)
                    submitButton.isEnabled = false
                    submitButton.backgroundColor = .clear
                    submitButton.setTitleColor(.systemBlue, for: .disabled)
                    if let date = milestone.checkinDate {
                        datePicker.date = date
                        datePicker.isEnabled = false
                    }
                }
            }
        }
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
        changeVisibility()
    }
    
    private func changeVisibility(hidden: Bool = true) {
        self.deleteButton.isHidden = hidden
        guard let milestones = self.viewModel?.checkInMilestone else { return }
        milestones.forEach({
            if $0.milestoneCompleted ?? false {
                dateLabel.isHidden = !hidden
                datePicker.isHidden = !hidden
                deleteButton.isHidden = !hidden
            } else {
                dateLabel.isHidden = hidden
                datePicker.isHidden = hidden
            }
        })
    }

    private func initContentViewModel() {
        let testItem = [WorkFlow(milesstoneId: 2, checkinDate: Date(), milestoneCompleted: false), WorkFlow(milesstoneId: 3, checkinDate: Date(), milestoneCompleted: false),  ]
        testItem.forEach({ self.viewModel = ContentViewModel(milestone: $0) })
    }
    
    private func loadData() {
            NetworkManager.retreiveItems { [weak self] result in
                print(result)
                guard let self = self else { return }
                switch result {
                case .success(let items):
                    items.forEach({ self.viewModel = ContentViewModel(milestone: $0)})
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
        guard let milestones = self.viewModel?.checkInMilestone else { return }
        for milestone in milestones {
            self.deleteButton.isHidden = false
            self.viewModel?.deleteAll(item: milestone, vc: self, completion: { deleted in
                
                switch deleted {
                case true:
                    self.customAlert(title: "Deleted", message: "Deleted", buttonTitle: "ok")
                    self.checkInToggle.isEnabled = true
                    self.datePicker.isEnabled = true
                    self.datePicker.date = Date()
                    self.submitButton.setTitle("Submit", for: .normal)
                    self.submitButton.backgroundColor = .systemBlue
                    self.submitButton.isEnabled = true
                case false:
//                    break
                    self.deleteButton.isHidden = true
                }
                
            })
        }
    }
    
    @objc private func checkInButtonTapped(_ sender: UIButton) {
        guard toggleChanged && checkinDate != nil else {
            self.customAlert(title: "Choose Date ", message: "Trya again", buttonTitle: "ok")
            return
        }
        let item = WorkFlow(milesstoneId: 1, checkinDate: self.checkinDate, milestoneCompleted: self.toggleChanged)
        print("printing this item ", item)
        self.viewModel?.checkIn(item: item, vc: self, completion: { saved in
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
                break
            }
            
        })
    }
}



public typealias VoidClosure = () -> Void

