//
//  JoinedGroupDetailViewController.swift
//  LETSGO iOS App
//
//  Created by zft on 17/11/2025.
//
import UIKit

final class JoinedGroupDetailViewController: UIViewController {
    private let group: Group
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let descriptionLabel = UILabel()
    private let membersStack = UIStackView()
    var onLeave: ((Group) -> Void)?
    private let leaveButton = UIButton(type: .system)

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    init(group: Group) {
        self.group = group
        super.init(nibName: nil, bundle: nil)
        title = group.destination
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLayout()
        renderContent()
    }

    private func configureLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 20
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.isLayoutMarginsRelativeArrangement = true
        contentStack.layoutMargins = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)

        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)

        membersStack.axis = .vertical
        membersStack.spacing = 8

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        contentStack.addArrangedSubview(makeSummaryCard())
        contentStack.addArrangedSubview(descriptionLabel)
        contentStack.addArrangedSubview(makeMembersCard())
        configureLeaveButton()
        contentStack.addArrangedSubview(leaveButton)
    }

    private func renderContent() {
        descriptionLabel.text = group.description
        renderMembers()
    }

    private func makeSummaryCard() -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor.secondarySystemBackground
        card.layer.cornerRadius = 18
        card.layer.cornerCurve = .continuous

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false

        let rows = [
            ("Destination", group.destination),
            ("City", group.city),
            ("Theme", group.theme),
            ("Start Date", dateFormatter.string(from: group.startDate)),
            ("Budget", "$\(group.budget)"),
            ("Spots Left", "\(group.spotsLeft)")
        ]

        rows.forEach { title, value in
            stack.addArrangedSubview(makeInfoRow(title: title, value: value))
        }

        card.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20)
        ])
        return card
    }

    private func makeInfoRow(title: String, value: String) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        titleLabel.textColor = .secondaryLabel

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        valueLabel.textAlignment = .right

        let row = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        row.axis = .horizontal
        row.distribution = .equalSpacing
        return row
    }

    private func makeMembersCard() -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor.secondarySystemBackground
        card.layer.cornerRadius = 18
        card.layer.cornerCurve = .continuous

        let titleLabel = UILabel()
        titleLabel.text = "Members"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)

        let stack = UIStackView(arrangedSubviews: [titleLabel, membersStack])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20)
        ])
        return card
    }

    private func renderMembers() {
        membersStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if group.members.isEmpty {
            let label = UILabel()
            label.text = "No members listed."
            label.textColor = .secondaryLabel
            label.textAlignment = .center
            membersStack.addArrangedSubview(label)
            return
        }

        for member in group.members {
            let container = UIStackView()
            container.axis = .vertical
            container.spacing = 2

            let nameLabel = UILabel()
            nameLabel.text = "@\(member.name)"
            nameLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)

            let roleLabel = UILabel()
            roleLabel.text = member.name == group.organizer ? "Organizer" : "Member"
            roleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
            roleLabel.textColor = .secondaryLabel

            container.addArrangedSubview(nameLabel)
            container.addArrangedSubview(roleLabel)

            let background = UIView()
            background.backgroundColor = member.accentColor.withAlphaComponent(0.15)
            background.layer.cornerRadius = 12
            background.translatesAutoresizingMaskIntoConstraints = false

            background.addSubview(container)
            container.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                container.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 12),
                container.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -12),
                container.topAnchor.constraint(equalTo: background.topAnchor, constant: 8),
                container.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -8)
            ])

            membersStack.addArrangedSubview(background)
        }
    }

    private func configureLeaveButton() {
        leaveButton.setTitle("Leave Group", for: .normal)
        leaveButton.backgroundColor = .systemRed
        leaveButton.setTitleColor(.white, for: .normal)
        leaveButton.layer.cornerRadius = 14
        leaveButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        leaveButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        leaveButton.addTarget(self, action: #selector(leaveTapped), for: .touchUpInside)
    }

    @objc private func leaveTapped() {
        onLeave?(group)
        navigationController?.popViewController(animated: true)
    }
}
