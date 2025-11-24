//
//  UserGroupPostDetailViewController.swift
//  LETSGO iOS App
//
//  Created by zft on 23/11/2025.
//
import UIKit

final class UserGroupPostDetailViewController: UIViewController {
    private let group: UserGroupSummary
    private let infoStack = UIStackView()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    init(group: UserGroupSummary) {
        self.group = group
        super.init(nibName: nil, bundle: nil)
        title = "Group Log"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureStack()
        layoutContent()
        render()
    }

    private func configureStack() {
        infoStack.axis = .vertical
        infoStack.spacing = 16
        infoStack.translatesAutoresizingMaskIntoConstraints = false
    }

    private func layoutContent() {
        view.addSubview(infoStack)
        NSLayoutConstraint.activate([
            infoStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            infoStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func render() {
        let titleLabel = UILabel()
        titleLabel.text = group.destination
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.numberOfLines = 0

        let dateLabel = pillLabel(text: "🗓 \(dateFormatter.string(from: group.departureDate))")
        let budgetLabel = pillLabel(text: "💰 Budget $\(group.budget)")
        let peopleLabel = pillLabel(text: "👥 \(group.peopleCount) travelers")

        let descriptionLabel = UILabel()
        descriptionLabel.text = "Share itinerary details, meetup info, and packing tips here."
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .secondaryLabel

        [titleLabel, dateLabel, budgetLabel, peopleLabel, descriptionLabel].forEach {
            infoStack.addArrangedSubview($0)
        }
    }

    private func pillLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.backgroundColor = UIColor.secondarySystemBackground
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: 44).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
