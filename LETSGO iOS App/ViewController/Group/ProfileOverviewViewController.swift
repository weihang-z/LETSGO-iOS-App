//
//  ProfileOverviewViewController.swift
//  LETSGO iOS App
//
//  Created by zft on 17/11/2025.
//

import UIKit

final class ProfileOverviewViewController: UIViewController {
    private let dataStore: UserContentDataStore

    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private let avatarImageView = UIImageView()
    private let uploadAvatarButton = UIButton(type: .system)
    private let usernameLabel = UILabel()
    private let bioLabel = UILabel()
    private let statsStackView = UIStackView()
    private let buttonStackView = UIStackView()
    private let socialButtonStackView = UIStackView()
    private let travelMapButton = UIButton(type: .system)
    private let bottomButtonStackView = UIStackView()
    private let editProfileButton = UIButton(type: .system)

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
        configureScrollView()
        configureAvatar()
        configureLabels()
        configureStats()
        configureButtons()
        layoutContent()
        refreshUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUI()
    }

    private func configureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.layoutMargins = UIEdgeInsets(top: 32, left: 24, bottom: 32, right: 24)

        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }

    private func configureAvatar() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.tintColor = .systemBlue
        avatarImageView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)

        uploadAvatarButton.setTitle("Upload photo", for: .normal)
        uploadAvatarButton.setTitleColor(.systemBlue, for: .normal)
        uploadAvatarButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        uploadAvatarButton.addTarget(self, action: #selector(uploadPhotoTapped), for: .touchUpInside)
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

        let logsButton = makeSecondaryButton(title: "My Logs", action: #selector(myLogsTapped))
        let groupsButton = makeSecondaryButton(title: "My Groups", action: #selector(myGroupsTapped))
        buttonStackView.addArrangedSubview(logsButton)
        buttonStackView.addArrangedSubview(groupsButton)

        socialButtonStackView.axis = .horizontal
        socialButtonStackView.distribution = .fillEqually
        socialButtonStackView.spacing = 12
        socialButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        let followersButton = makeSecondaryButton(title: "Followers", action: #selector(followersTapped))
        let followingButton = makeSecondaryButton(title: "Following", action: #selector(followingTapped))
        socialButtonStackView.addArrangedSubview(followersButton)
        socialButtonStackView.addArrangedSubview(followingButton)

        configureTravelMapButton()

        bottomButtonStackView.axis = .horizontal
        bottomButtonStackView.distribution = .fillEqually
        bottomButtonStackView.spacing = 12
        bottomButtonStackView.translatesAutoresizingMaskIntoConstraints = false

        configureEditProfileButton()
        bottomButtonStackView.addArrangedSubview(editProfileButton)
        bottomButtonStackView.addArrangedSubview(travelMapButton)
    }

    private func configureTravelMapButton() {
        travelMapButton.setTitle("Travel Footprint Map", for: .normal)
        travelMapButton.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.2)
        travelMapButton.setTitleColor(.systemTeal, for: .normal)
        travelMapButton.layer.cornerRadius = 14
        travelMapButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        travelMapButton.translatesAutoresizingMaskIntoConstraints = false
        travelMapButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        travelMapButton.addTarget(self, action: #selector(travelMapTapped), for: .touchUpInside)
    }

    private func configureEditProfileButton() {
        editProfileButton.setTitle("Edit Profile", for: .normal)
        editProfileButton.backgroundColor = .systemBlue
        editProfileButton.setTitleColor(.white, for: .normal)
        editProfileButton.layer.cornerRadius = 14
        editProfileButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        editProfileButton.translatesAutoresizingMaskIntoConstraints = false
        editProfileButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        editProfileButton.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
    }

    private func layoutContent() {
        let avatarContainer = UIView()
        avatarContainer.translatesAutoresizingMaskIntoConstraints = false
        let avatarStack = UIStackView(arrangedSubviews: [avatarImageView, uploadAvatarButton])
        avatarStack.axis = .vertical
        avatarStack.alignment = .center
        avatarStack.spacing = 8
        avatarStack.translatesAutoresizingMaskIntoConstraints = false
        avatarContainer.addSubview(avatarStack)
        NSLayoutConstraint.activate([
            avatarStack.centerXAnchor.constraint(equalTo: avatarContainer.centerXAnchor),
            avatarStack.topAnchor.constraint(equalTo: avatarContainer.topAnchor),
            avatarStack.bottomAnchor.constraint(equalTo: avatarContainer.bottomAnchor)
        ])

        avatarImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor).isActive = true
        avatarImageView.layer.cornerRadius = 60

        contentStackView.addArrangedSubview(avatarContainer)
        contentStackView.addArrangedSubview(usernameLabel)
        contentStackView.addArrangedSubview(bioLabel)
        contentStackView.addArrangedSubview(statsStackView)
        contentStackView.addArrangedSubview(buttonStackView)
        contentStackView.addArrangedSubview(socialButtonStackView)
        contentStackView.addArrangedSubview(bottomButtonStackView)
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

    @objc private func myGroupsTapped() {
        let controller = MyPostsViewController(dataStore: dataStore)
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func myLogsTapped() {
        let controller = LogTimelineViewController(allowsCreation: false)
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func uploadPhotoTapped() {
        let controller = AvatarUploadViewController(currentImage: dataStore.profile.avatarImage)
        controller.onSave = { [weak self] image in
            guard var profile = self?.dataStore.profile else { return }
            profile.avatarImage = image
            self?.dataStore.updateProfile(profile)
            self?.refreshUI()
        }
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func followersTapped() {
        let controller = FollowersListViewController(title: "Followers", users: dataStore.followers)
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func followingTapped() {
        let controller = FollowingFriendsViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func travelMapTapped() {
        let controller = TravelFootprintMapViewController(dataStore: dataStore)
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
