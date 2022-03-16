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
    var milesstoneId: Int?
    var checkinDate: Date?
    var milestoneCompleted: Bool?
}

//MARK: CONTENTVIEWMODEL
class ContentViewModel {
    var checkInMilestone = [WorkFlow]()
    
    init(milestone: WorkFlow?) {
        if let milestone = milestone {
            self.checkInMilestone.append(milestone)
        }
    }
    
    func checkIn(item: WorkFlow, vc: UIViewController) {
        vc.showLoadingView()
        NetworkManager.updateWith(WorkFlowItem: item, actionType: .add) { error in
            vc.dismissLoadingView()
            guard let error = error else {
                vc.customAlert(title: "Success!...", message: "Milestone Completed...", buttonTitle: "Okay")
                return
            }
            vc.customAlert(title: "Something went wrong...", message: error.rawValue, buttonTitle: "Ok")
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
                    submitButton.setTitle("Loaded", for: .normal)
                    submitButton.isEnabled = false
                    if let date = milestone.checkinDate {
                        datePicker.date = date
                        datePicker.isEnabled = false
                    }
                }
            }
        }
    }
    
    //MARK: - Toggle Button
    lazy var checkingLabel: UILabel = {
        let label = CustomTitleLabel(textAlignment: .left, fontSize: 14, text: "Check In")
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
        }
    }
    
    //MARK: - Date Picker
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
    
    @objc private func deleteAll() {
        deleteData()
    }
    
    @objc private func checkInButtonTapped(_ sender: UIButton) {
        guard toggleChanged && checkinDate != nil else {
            print("Check the input")
            return
        }
        let item = WorkFlow(milesstoneId: 1, checkinDate: self.checkinDate, milestoneCompleted: self.toggleChanged)
        print(item)
        self.viewModel?.checkIn(item: item, vc: self)
    }
    
    
    lazy var componentsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [checkingLabel, checkInToggle])
        stack.distribution = .equalSpacing
        stack.spacing = 10
        stack.axis = .horizontal
        return stack
    }()
    
    lazy var checkInView: UIView = {
        let view = UIView()
        view.addSubview(checkingLabel)
        view.addSubview(checkInToggle)
        view.addSubview(datePicker)
        view.addSubview(componentsStackView)
        view.addSubview(submitButton)
        view.addSubview(deleteButton)
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 16
        view.backgroundColor = .systemGray6
        return view
    }()
    
    weak var delegate: Delegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Work Flow"
        view.backgroundColor = .systemBlue
        configure()
        initContentViewModel()
        loadData()
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
    
    private func deleteData() {
        guard let milestones = self.viewModel?.checkInMilestone else { return }
        for milestone in milestones {
                NetworkManager.updateWith(WorkFlowItem: milestone, actionType: .remove, completed: {error in
                    print(error)
                    print("completed")
                })
        }
    }
    
    private func configure() {
        view.addSubview(checkInView)
        setupConstraints()
    }
    
    func setupConstraints() {
        checkInView.topAnchor == view.topAnchor + 100
        checkInView.horizontalAnchors == view.horizontalAnchors + 20
        checkInView.heightAnchor == view.heightAnchor / 4
        
        let padding: CGFloat = 20
        componentsStackView.topAnchor == checkInView.topAnchor + padding
        componentsStackView.horizontalAnchors == checkInView.horizontalAnchors + padding
        
        datePicker.topAnchor == componentsStackView.bottomAnchor + padding
        datePicker.leadingAnchor == checkInView.leadingAnchor
        datePicker.trailingAnchor == checkInView.trailingAnchor
        datePicker.heightAnchor == 80
        
        submitButton.topAnchor == datePicker.bottomAnchor + 10
        submitButton.centerXAnchor == checkInView.centerXAnchor
        submitButton.widthAnchor == 100
        
        deleteButton.topAnchor == submitButton.bottomAnchor + 10
        deleteButton.trailingAnchor == checkInView.trailingAnchor -  10
        deleteButton.bottomAnchor == checkInView.bottomAnchor - 10
        deleteButton.widthAnchor == 70
    }
    
}



extension ViewController: Actionable {
    enum Action {
        case deleteList(list: String)
        case close
        case keepItem
        case deleteItem(item: String)
    }
}


protocol Coordinator {
    
    //    /// A child coordinator spun off by this coordinator.
    //    /// Important to keep a reference to prevent deallocation.
    //    var childCoordinator: Coordinator? { get set }
    
    /// Start any action this coordinator should take. Often, this is
    /// presenting/pushing a new controller, or starting up a
    /// child coordinator.
    ///
    /// - Parameters:
    ///   - animated: whether to animate any transitions.
    ///   - completion: a completion block.
    func completeAction(animated: Bool, completion: VoidClosure?)
    
    /// Clean up after this coordinator. Should get the app back to the
    /// state it was in when this coordinator started.
    ///
    /// - Parameters:
    ///   - animated: whether to animate any transitions.
    ///   - completion: a completion block.
    func cleanup(animated: Bool, completion: VoidClosure?)
    
}


public typealias VoidClosure = () -> Void

//open class BaseView: UIView {
//    public override init(frame: CGRect = .zero) {
//        super.init(frame: frame)
//        setup()
//    }
//
//    public required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
//
//    open func setup() {}
//}
