//
//  ProfileOverviewViewController.swift
//  LETSGO iOS App
//
//  Created by zft on 17/11/2025.
//

import UIKit

final class ProfileOverviewViewController: UIViewController {
    private let dataStore: UserContentDataStore

    private let avatarImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let bioLabel = UILabel()
    private let statsStackView = UIStackView()
    private let buttonStackView = UIStackView()

    init(dataStore: UserContentDataStore) {
        self.dataStore = dataStore
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "My Profile"
        configureAvatar()
        configureLabels()
        configureStats()
        configureButtons()
        layoutContent()
        refreshUI()
    }

    private func configureAvatar() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.tintColor = .systemBlue
        avatarImageView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
    }

    private func configureLabels() {
        usernameLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        usernameLabel.textColor = .label
        usernameLabel.textAlignment = .center
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false

        bioLabel.font = UIFont.preferredFont(forTextStyle: .body)
        bioLabel.textColor = .secondaryLabel
        bioLabel.numberOfLines = 0
        bioLabel.textAlignment = .center
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureStats() {
        statsStackView.axis = .horizontal
        statsStackView.distribution = .fillEqually
        statsStackView.spacing = 12
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureButtons() {
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 12
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false

        let editButton = makePrimaryButton(title: "Edit Profile", action: #selector(editProfileTapped))
        let postsButton = makeSecondaryButton(title: "My Posts", action: #selector(myPostsTapped))
        buttonStackView.addArrangedSubview(editButton)
        buttonStackView.addArrangedSubview(postsButton)
    }

    private func layoutContent() {
        let avatarContainer = UIView()
        avatarContainer.translatesAutoresizingMaskIntoConstraints = false
        avatarContainer.addSubview(avatarImageView)
        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: avatarContainer.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: avatarContainer.topAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: avatarContainer.bottomAnchor)
        ])

        let container = UIStackView(arrangedSubviews: [avatarContainer, usernameLabel, bioLabel, statsStackView, buttonStackView])
        container.axis = .vertical
        container.spacing = 16
        container.alignment = .fill
        container.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(container)
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 120),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor),
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])

        avatarImageView.layer.cornerRadius = 60
    }

    private func refreshUI() {
        let profile = dataStore.profile
        avatarImageView.image = profile.avatarImage
        usernameLabel.text = profile.username
        bioLabel.text = profile.bio ?? "Add something about yourself."

        statsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let stats = [
            ("\(profile.citiesVisited)", "cities visited"),
            ("\(profile.travelDays)", "travel days"),
            ("\(profile.journalsCount)", "journals")
        ]

        stats.forEach { tuple in
            let view = makeStatView(value: tuple.0, label: tuple.1)
            statsStackView.addArrangedSubview(view)
        }
    }

    @objc private func editProfileTapped() {
        let controller = EditProfileViewController(profile: dataStore.profile)
        controller.onSave = { [weak self] updatedProfile in
            self?.dataStore.updateProfile(updatedProfile)
            self?.refreshUI()
            self?.navigationController?.popViewController(animated: true)
        }
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func myPostsTapped() {
        let controller = MyPostsViewController(groups: dataStore.userGroups, journals: dataStore.userJournals)
        navigationController?.pushViewController(controller, animated: true)
    }

    private func makeStatView(value: String, label: String) -> UIView {
        let valueLabel = UILabel()
        valueLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        valueLabel.textAlignment = .center
        valueLabel.text = value

        let titleLabel = UILabel()
        titleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        titleLabel.textColor = .secondaryLabel
        titleLabel.textAlignment = .center
        titleLabel.text = label

        let stack = UIStackView(arrangedSubviews: [valueLabel, titleLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        let container = UIView()
        container.layer.cornerRadius = 16
        container.backgroundColor = UIColor.secondarySystemBackground
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8)
        ])
        return container
    }

    private func makePrimaryButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 14
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }

    private func makeSecondaryButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor.systemGray5
        button.tintColor = .label
        button.layer.cornerRadius = 14
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }
}
