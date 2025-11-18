//
//  GroupDetailViewController.swift
//  LETSGO iOS App
//
//  Created by zft on 17/11/2025.
//

import UIKit

final class GroupDetailViewController: UIViewController {
    var onGroupChanged: ((Group) -> Void)?

    private let groupID: UUID
    private let dataStore: GroupDataStore
    private var group: Group

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let descriptionLabel = UILabel()
    private let membersStack = UIStackView()
    private let actionButton = UIButton(type: .system)

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    init(groupID: UUID, dataStore: GroupDataStore) {
        self.groupID = groupID
        self.dataStore = dataStore
        self.group = dataStore.group(with: groupID) ?? Group.sampleData[0]
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = group.destination
        configureLayout()
        renderContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let latest = dataStore.group(with: groupID) {
            group = latest
            renderContent()
        }
    }

    private func configureLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 20
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)

        membersStack.axis = .vertical
        membersStack.spacing = 12

        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        actionButton.layer.cornerRadius = 14
        actionButton.layer.cornerCurve = .continuous
        actionButton.backgroundColor = .systemBlue
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        actionButton.addTarget(self, action: #selector(primaryButtonTapped), for: .touchUpInside)

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])

        let summaryCard = makeSummaryCard()
        contentStack.addArrangedSubview(summaryCard)
        contentStack.addArrangedSubview(descriptionLabel)
        contentStack.addArrangedSubview(makeMembersCard())

        view.addSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    private func renderContent() {
        title = group.destination
        descriptionLabel.text = group.description
        updateSummaryValues()
        renderMembers()
        updateActionButton()
    }

    private func makeSummaryCard() -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor.secondarySystemBackground
        card.layer.cornerRadius = 18
        card.layer.cornerCurve = .continuous

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false

        let destination = makeInfoRow(title: "Destination", value: group.destination)
        destination.tag = 101
        let date = makeInfoRow(title: "Date", value: dateFormatter.string(from: group.startDate))
        date.tag = 102
        let budget = makeInfoRow(title: "Budget", value: "$\(group.budget)")
        budget.tag = 103
        let spots = makeInfoRow(title: "Spots left", value: "\(group.spotsLeft)")
        spots.tag = 104

        [destination, date, budget, spots].forEach { stack.addArrangedSubview($0) }
        card.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20)
        ])
        card.tag = 100
        return card
    }

    private func makeMembersCard() -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor.secondarySystemBackground
        card.layer.cornerRadius = 18
        card.layer.cornerCurve = .continuous

        let titleLabel = UILabel()
        titleLabel.text = "Members"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)

        membersStack.translatesAutoresizingMaskIntoConstraints = false

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

    private func makeInfoRow(title: String, value: String) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        titleLabel.textColor = .secondaryLabel

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        valueLabel.textAlignment = .right

        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }

    private func updateSummaryValues() {
        guard let summaryCard = contentStack.arrangedSubviews.first(where: { $0.tag == 100 }) else { return }
        summaryCard.subviews.forEach { view in
            view.subviews.forEach { _ in }
        }
        summaryCard.removeFromSuperview()
        contentStack.insertArrangedSubview(makeSummaryCard(), at: 0)
    }

    private func renderMembers() {
        membersStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for member in group.members {
            let bubble = UIView()
            bubble.backgroundColor = member.accentColor.withAlphaComponent(0.15)
            bubble.layer.cornerRadius = 12

            let label = UILabel()
            label.text = member.name
            label.font = UIFont.preferredFont(forTextStyle: .subheadline)
            label.translatesAutoresizingMaskIntoConstraints = false

            bubble.addSubview(label)
            label.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 12).isActive = true
            label.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -12).isActive = true
            label.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 8).isActive = true
            label.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -8).isActive = true

            membersStack.addArrangedSubview(bubble)
        }
    }

    private func updateActionButton() {
        let isOrganizer = group.organizer == dataStore.currentUser
        if isOrganizer {
            actionButton.setTitle("Edit Group", for: .normal)
            actionButton.backgroundColor = .systemOrange
        } else {
            actionButton.setTitle(group.spotsLeft > 0 ? "Join Group" : "Group Full", for: .normal)
            actionButton.backgroundColor = group.spotsLeft > 0 ? .systemBlue : .systemGray3
            actionButton.isEnabled = group.spotsLeft > 0
        }
    }

    @objc private func primaryButtonTapped() {
        let isOrganizer = group.organizer == dataStore.currentUser
        if isOrganizer {
            let controller = CreateGroupViewController(mode: .edit, group: group, currentUser: dataStore.currentUser)
            controller.onSave = { [weak self] updatedGroup in
                self?.handleGroupUpdate(updatedGroup)
            }
            navigationController?.pushViewController(controller, animated: true)
        } else {
            guard let updated = dataStore.joinGroup(id: group.id, memberName: dataStore.currentUser) else { return }
            handleGroupUpdate(updated)
        }
    }

    private func handleGroupUpdate(_ updatedGroup: Group) {
        dataStore.update(updatedGroup)
        group = updatedGroup
        onGroupChanged?(updatedGroup)
        renderContent()
    }
}
