//
//  CreateGroupViewController.swift
//  LETSGO iOS App
//
//  Created by zft on 17/11/2025.
//

import UIKit

final class CreateGroupViewController: UIViewController {
    var onSave: ((Group) -> Void)?

    private let mode: Group.Mode
    private var group: Group?
    private let currentUser: String

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let destinationField = UITextField()
    private let budgetField = UITextField()
    private let spotsField = UITextField()
    private let descriptionView = UITextView()
    private let datePicker = UIDatePicker()

    init(mode: Group.Mode, group: Group?, currentUser: String) {
        self.mode = mode
        self.group = group
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = mode == .create ? "Create Group" : "Edit Group"
        configureLayout()
        populateFields()
    }

    private func configureLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        destinationField.placeholder = "Destination"
        configureTextField(destinationField)

        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date

        budgetField.placeholder = "Budget (USD)"
        budgetField.keyboardType = .numberPad
        configureTextField(budgetField)

        spotsField.placeholder = "Spots Needed"
        spotsField.keyboardType = .numberPad
        configureTextField(spotsField)

        descriptionView.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionView.layer.cornerRadius = 12
        descriptionView.layer.borderWidth = 1
        descriptionView.layer.borderColor = UIColor.systemGray4.cgColor
        descriptionView.heightAnchor.constraint(equalToConstant: 100).isActive = true

        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save Group", for: .normal)
        saveButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        saveButton.backgroundColor = .systemGreen
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 14
        saveButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        let dateRow = UIStackView(arrangedSubviews: [UILabel(), datePicker])
        if let label = dateRow.arrangedSubviews.first as? UILabel {
            label.text = "Start Date"
            label.font = UIFont.preferredFont(forTextStyle: .body)
        }
        dateRow.axis = .horizontal
        dateRow.distribution = .equalSpacing

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])

        [destinationField,
         dateRow,
         budgetField,
         spotsField,
         descriptionView,
         saveButton].forEach { stackView.addArrangedSubview($0) }
    }

    private func configureTextField(_ textField: UITextField) {
        textField.borderStyle = .roundedRect
        textField.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }

    private func populateFields() {
        guard let group = group else {
            descriptionView.text = ""
            datePicker.date = Date()
            return
        }
        destinationField.text = group.destination
        budgetField.text = "\(group.budget)"
        spotsField.text = "\(group.spotsLeft)"
        descriptionView.text = group.description
        datePicker.date = group.startDate
    }

    @objc private func saveTapped() {
        guard let destination = destinationField.text, destination.isEmpty == false else {
            showAlert(message: "Destination is required.")
            return
        }
        let budget = Int(budgetField.text ?? "") ?? 0
        let spots = Int(spotsField.text ?? "") ?? 0
        let descriptionText = descriptionView.text ?? ""

        let groupToSave: Group
        if var existing = group {
            existing.destination = destination
            existing.startDate = datePicker.date
            existing.budget = budget
            existing.spotsLeft = spots
            existing.description = descriptionText
            groupToSave = existing
        } else {
            groupToSave = Group(
                id: UUID(),
                destination: destination,
                startDate: datePicker.date,
                budget: budget,
                spotsLeft: spots,
                organizer: currentUser,
                description: descriptionText,
                members: [GroupMember(name: currentUser, accentColor: .systemBlue)]
            )
        }

        onSave?(groupToSave)
        navigationController?.popViewController(animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Missing Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
