//
//  GroupFilterViewController.swift
//  LETSGO iOS App
//
//  Created by zft on 22/11/2025.
//
import UIKit

final class GroupFilterViewController: UIViewController {
    var onApply: ((GroupFilterOptions) -> Void)?
    var onClear: (() -> Void)?

    private var options: GroupFilterOptions

    private let budgetField = UITextField()
    private let cityField = UITextField()
    private let themeField = UITextField()
    private let datePicker = UIDatePicker()
    private let dateSwitch = UISwitch()

    init(options: GroupFilterOptions) {
        self.options = options
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filter Groups"
        view.backgroundColor = .systemBackground
        configureNavigation()
        configureFields()
        layoutContent()
        populateFields()
    }

    private func configureNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Reset",
            style: .plain,
            target: self,
            action: #selector(resetTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Apply",
            style: .done,
            target: self,
            action: #selector(applyTapped)
        )
    }

    private func configureFields() {
        [budgetField, cityField, themeField].forEach {
            $0.borderStyle = .roundedRect
            $0.heightAnchor.constraint(equalToConstant: 48).isActive = true
        }
        budgetField.placeholder = "Max budget (USD)"
        budgetField.keyboardType = .numberPad

        cityField.placeholder = "City keyword"
        themeField.placeholder = "Theme keyword"

        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        dateSwitch.addTarget(self, action: #selector(dateSwitchToggled), for: .valueChanged)
    }

    private func layoutContent() {
        let dateToggleLabel = UILabel()
        dateToggleLabel.text = "Enable date filter"
        dateToggleLabel.font = UIFont.preferredFont(forTextStyle: .body)

        let dateRow = UIStackView(arrangedSubviews: [dateToggleLabel, dateSwitch])
        dateRow.axis = .horizontal
        dateRow.distribution = .equalSpacing
        dateRow.alignment = .center

        let stack = UIStackView(arrangedSubviews: [
            makeSection(title: "Budget", content: budgetField),
            makeSection(title: "City", content: cityField),
            makeSection(title: "Theme", content: themeField),
            makeSection(title: "Earliest start date", content: datePicker),
            dateRow
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20)
        ])
    }

    private func makeSection(title: String, content: UIView) -> UIStackView {
        let label = UILabel()
        label.text = title
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = .secondaryLabel

        let container = UIStackView(arrangedSubviews: [label, content])
        container.axis = .vertical
        container.spacing = 8
        return container
    }

    private func populateFields() {
        if let maxBudget = options.maxBudget {
            budgetField.text = "\(maxBudget)"
        }
        cityField.text = options.cityKeyword
        themeField.text = options.themeKeyword
        if let fromDate = options.fromDate {
            datePicker.date = fromDate
            dateSwitch.isOn = true
        } else {
            datePicker.date = Date()
            dateSwitch.isOn = false
        }
        datePicker.isEnabled = dateSwitch.isOn
    }

    @objc private func applyTapped() {
        var updated = GroupFilterOptions()
        if let text = budgetField.text, let value = Int(text) {
            updated.maxBudget = value
        }
        if let text = cityField.text?.trimmingCharacters(in: .whitespacesAndNewlines), text.isEmpty == false {
            updated.cityKeyword = text
        }
        if let text = themeField.text?.trimmingCharacters(in: .whitespacesAndNewlines), text.isEmpty == false {
            updated.themeKeyword = text
        }
        if dateSwitch.isOn {
            updated.fromDate = datePicker.date
        }
        options = updated
        onApply?(updated)
        dismiss(animated: true)
    }

    @objc private func resetTapped() {
        options.clear()
        budgetField.text = nil
        cityField.text = nil
        themeField.text = nil
        dateSwitch.isOn = false
        datePicker.isEnabled = false
        datePicker.date = Date()
        onClear?()
        dismiss(animated: true)
    }

    @objc private func dateSwitchToggled() {
        datePicker.isEnabled = dateSwitch.isOn
    }
}
