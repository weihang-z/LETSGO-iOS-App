//
//  GroupDetailViewController.swift
//  LETSGO iOS App
//
//  Created by zft on 17/11/2025.
//

import UIKit

final class GroupDetailViewController: UIViewController {
    var onGroupChanged: ((Group) -> Void)?
    var onMembershipChanged: ((Group, Bool) -> Void)?
    var onGroupDeleted: ((Group) -> Void)?

    private let groupID: UUID
    private let dataStore: GroupDataStore
    private var group: Group

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let descriptionLabel = UILabel()
    private let membersStack = UIStackView()
    private let actionButton = UIButton(type: .system)
    private let deleteButton = UIButton(type: .system)
    private let buttonStack = UIStackView()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    private var isCurrentUserOrganizer: Bool {
        return group.organizer == dataStore.currentUser
    }

    private var isCurrentUserMember: Bool {
        return group.members.contains(where: { $0.name == dataStore.currentUser })
    }

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

        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        deleteButton.layer.cornerRadius = 14
        deleteButton.layer.cornerCurve = .continuous
        deleteButton.backgroundColor = .systemRed
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.setTitle("Delete Group", for: .normal)
        deleteButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)

        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.addArrangedSubview(actionButton)
        buttonStack.addArrangedSubview(deleteButton)

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

        view.addSubview(buttonStack)
        NSLayoutConstraint.activate([
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
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
        let city = makeInfoRow(title: "City", value: group.city)
        city.tag = 104
        let theme = makeInfoRow(title: "Theme", value: group.theme)
        theme.tag = 105
        let spots = makeInfoRow(title: "Spots left", value: "\(group.spotsLeft)")
        spots.tag = 106

        [destination, date, budget, city, theme, spots].forEach { stack.addArrangedSubview($0) }
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
        let sortedMembers = group.members.sorted { $0.name < $1.name }
        for member in sortedMembers {
            let bubble = UIView()
            bubble.backgroundColor = member.accentColor.withAlphaComponent(0.15)
            bubble.layer.cornerRadius = 12

            let nameLabel = UILabel()
            nameLabel.text = "@\(member.name)"
            nameLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)

            let roleLabel = UILabel()
            roleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
            roleLabel.textColor = .secondaryLabel
            roleLabel.text = member.name == group.organizer ? "Organizer" : "Member"

            let stack = UIStackView(arrangedSubviews: [nameLabel, roleLabel])
            stack.axis = .vertical
            stack.spacing = 2
            stack.translatesAutoresizingMaskIntoConstraints = false

            bubble.addSubview(stack)
            NSLayoutConstraint.activate([
                stack.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 12),
                stack.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -12),
                stack.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 8),
                stack.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -8)
            ])

            membersStack.addArrangedSubview(bubble)
        }
        if membersStack.arrangedSubviews.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "No members yet. Be the first to join!"
            emptyLabel.textColor = .secondaryLabel
            emptyLabel.textAlignment = .center
            membersStack.addArrangedSubview(emptyLabel)
        }
    }

    private func updateActionButton() {
        deleteButton.isHidden = !isCurrentUserOrganizer
        if isCurrentUserOrganizer {
            actionButton.setTitle("Edit Group", for: .normal)
            actionButton.backgroundColor = .systemOrange
            actionButton.isEnabled = true
        } else if isCurrentUserMember {
            actionButton.setTitle("Leave Group", for: .normal)
            actionButton.backgroundColor = .systemRed
            actionButton.isEnabled = true
        } else {
            actionButton.setTitle(group.spotsLeft > 0 ? "Join Group" : "Group Full", for: .normal)
            actionButton.backgroundColor = group.spotsLeft > 0 ? .systemBlue : .systemGray3
            actionButton.isEnabled = group.spotsLeft > 0
        }
    }

    @objc private func primaryButtonTapped() {
        if isCurrentUserOrganizer {
            let controller = CreateGroupViewController(mode: .edit, group: group, currentUser: dataStore.currentUser)
            controller.onSave = { [weak self] updatedGroup in
                self?.handleGroupUpdate(updatedGroup)
            }
            navigationController?.pushViewController(controller, animated: true)
        } else if isCurrentUserMember {
            guard let updated = dataStore.leaveGroup(id: group.id, memberName: dataStore.currentUser) else { return }
            handleGroupUpdate(updated)
        } else {
            guard let updated = dataStore.joinGroup(id: group.id, memberName: dataStore.currentUser) else { return }
            handleGroupUpdate(updated)
        }
    }

    @objc private func deleteButtonTapped() {
        let alert = UIAlertController(
            title: "Delete Group?",
            message: "This will remove the trip for all members and cannot be undone.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.performGroupDeletion()
        }))
        present(alert, animated: true)
    }

    private func performGroupDeletion() {
        guard isCurrentUserOrganizer else { return }
        guard dataStore.deleteGroup(id: group.id) != nil else { return }
        onMembershipChanged?(group, false)
        onGroupDeleted?(group)
        navigationController?.popViewController(animated: true)
    }

    private func handleGroupUpdate(_ updatedGroup: Group) {
        dataStore.update(updatedGroup)
        group = updatedGroup
        onGroupChanged?(updatedGroup)
        renderContent()
        let isMember = updatedGroup.members.contains { $0.name == dataStore.currentUser }
        onMembershipChanged?(updatedGroup, isMember)
    }
}
