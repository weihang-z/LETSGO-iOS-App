//
//  ProfileOverviewViewController.swift
//  LETSGO iOS App
//
//  Created by zft on 17/11/2025.
//

import UIKit
import FirebaseAuth

final class ProfileOverviewViewController: UIViewController {
    private let dataStore: UserContentDataStore

    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private let avatarImageView = UIImageView()
    private let uploadAvatarButton = UIButton(type: .system)
    private let usernameLabel = UILabel()
    private let emailLabel = UILabel()
    private let bioLabel = UILabel()
    private let statsStackView = UIStackView()
    private let buttonStackView = UIStackView()
    private let socialButtonStackView = UIStackView()
    private let travelMapButton = UIButton(type: .system)
    private let bottomButtonStackView = UIStackView()
    private let editProfileButton = UIButton(type: .system)
    private let signOutButton = UIButton(type: .system)
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let refreshControl = UIRefreshControl()
    
    private var currentUser: AppUser? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.updateUI()
            }
        }
    }
    private var userStats: UserStats? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.updateStatsUI()
            }
        }
    }
    private var avatarImage: UIImage? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                if let image = self?.avatarImage {
                    self?.avatarImageView.image = image
                }
            }
        }
    }

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
        
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        
        loadUserProfile()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserProfile()
    }
    
    @objc private func handleRefresh() {
        loadUserProfile()
    }
    
    private func loadUserProfile() {
        guard let userId = FirebaseService.shared.currentUserId else {
            return
        }

        if !refreshControl.isRefreshing {
            activityIndicator.startAnimating()
        }
        
        FirebaseService.shared.getUserProfileWithStats(uid: userId) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.refreshControl.endRefreshing()
                
                if case .success(let data) = result {
                    self?.currentUser = data.user
                    self?.userStats = data.stats
                    self?.loadAvatarImage()
                } else if case .failure(let error) = result {
                    self?.showError("Failed to load profile: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func loadAvatarImage() {
        guard let avatarURL = currentUser?.avatarURL, !avatarURL.isEmpty else {
            avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
            return
        }
        
        FirebaseService.shared.downloadImage(from: avatarURL) { [weak self] image in
            if let image = image {
                self?.avatarImage = image
            }
        }
    }
    
    private func updateUI() {
        guard let user = currentUser else { return }
        usernameLabel.text = user.username
        emailLabel.text = user.email
        bioLabel.text = user.bio ?? "Ready for the next adventure!"
    }
    
    private func updateStatsUI() {
        let stats = userStats ?? UserStats()
        
        statsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let statValues = [
            ("\(stats.citiesVisited)", "cities visited"),
            ("\(stats.travelDays)", "travel days"),
            ("\(stats.journalsCount)", "journals")
        ]
        
        statValues.forEach { tuple in
            let view = makeStatView(value: tuple.0, label: tuple.1)
            statsStackView.addArrangedSubview(view)
        }
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
        avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")

        uploadAvatarButton.setTitle("Upload photo", for: .normal)
        uploadAvatarButton.setTitleColor(.systemBlue, for: .normal)
        uploadAvatarButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        uploadAvatarButton.addTarget(self, action: #selector(uploadPhotoTapped), for: .touchUpInside)
    }

    private func configureLabels() {
        usernameLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        usernameLabel.textColor = .label
        usernameLabel.textAlignment = .center
        usernameLabel.text = "Loading..."
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        emailLabel.textColor = .secondaryLabel
        emailLabel.textAlignment = .center
        emailLabel.translatesAutoresizingMaskIntoConstraints = false

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
        
        updateStatsUI()
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
        configureSignOutButton()
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
    
    private func configureSignOutButton() {
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.15)
        signOutButton.setTitleColor(.systemRed, for: .normal)
        signOutButton.layer.cornerRadius = 14
        signOutButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signOutButton.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
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
        contentStackView.addArrangedSubview(emailLabel)
        contentStackView.addArrangedSubview(bioLabel)
        contentStackView.addArrangedSubview(statsStackView)
        contentStackView.addArrangedSubview(buttonStackView)
        contentStackView.addArrangedSubview(socialButtonStackView)
        contentStackView.addArrangedSubview(bottomButtonStackView)
        contentStackView.addArrangedSubview(signOutButton)
        
        contentStackView.setCustomSpacing(32, after: bottomButtonStackView)
    }

    
    @objc private func editProfileTapped() {
        print("🔧 Edit Profile tapped")
        
        guard let user = currentUser else {
            print("❌ Cannot edit - currentUser is nil")
            showError("Profile not loaded yet. Please wait and try again.")
            return
        }
        
        print("✅ Creating EditProfileViewController with user: \(user.username)")
        
        let localProfile = UserProfile(
            username: user.username,
            bio: user.bio,
            avatarImage: avatarImage,
            citiesVisited: userStats?.citiesVisited ?? 0,
            travelDays: userStats?.travelDays ?? 0,
            journalsCount: userStats?.journalsCount ?? 0
        )
        
        let controller = EditProfileViewController(profile: localProfile)
        controller.onSave = { [weak self] updatedProfile in
            print("💾 Saving updated profile...")
            guard let self = self, var updatedUser = self.currentUser else { return }
            
            updatedUser.username = updatedProfile.username
            updatedUser.bio = updatedProfile.bio
            
            self.activityIndicator.startAnimating()
            
            FirebaseService.shared.updateUserProfile(updatedUser) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        print("✅ Profile updated in Firebase")
                        
                        if let newAvatar = updatedProfile.avatarImage,
                           let userId = FirebaseService.shared.currentUserId {
                            
                            FirebaseService.shared.uploadAvatar(newAvatar, for: userId) { [weak self] uploadResult in
                                DispatchQueue.main.async {
                                    self?.activityIndicator.stopAnimating()
                                    
                                    if case .success(let url) = uploadResult {
                                        updatedUser.avatarURL = url
                                        self?.currentUser = updatedUser
                                        self?.avatarImage = newAvatar
                                        
                                        FirebaseService.shared.updateUserProfile(updatedUser) { _ in
                                            print("✅ Avatar URL updated")
                                        }
                                    }
                                    self?.loadUserProfile()
                                }
                            }
                        } else {
                            self?.activityIndicator.stopAnimating()
                            self?.currentUser = updatedUser
                        }
                        
                    case .failure(let error):
                        self?.activityIndicator.stopAnimating()
                        self?.showError("Failed to update profile: \(error.localizedDescription)")
                    }
                }
            }
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
        let controller = AvatarUploadViewController(currentImage: avatarImage)
        controller.onSave = { [weak self] image in
            guard let self = self,
                  let userId = FirebaseService.shared.currentUserId else { return }
            
            self.activityIndicator.startAnimating()
            
            FirebaseService.shared.uploadAvatar(image!, for: userId) { [weak self] result in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    
                    switch result {
                    case .success(let url):
                        self?.avatarImage = image
                        self?.avatarImageView.image = image
                        
                        if var user = self?.currentUser {
                            user.avatarURL = url
                            self?.currentUser = user
                            FirebaseService.shared.updateUserProfile(user) { result in
                                if case .failure(let error) = result {
                                    print("❌ Failed to update avatar URL: \(error.localizedDescription)")
                                }
                            }
                        }
                        
                    case .failure(let error):
                        self?.showError("Failed to upload avatar: \(error.localizedDescription)")
                    }
                }
            }
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
    
    @objc private func signOutTapped() {
        let alert = UIAlertController(
            title: "Sign Out",
            message: "Are you sure you want to sign out?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive) { [weak self] _ in
            self?.performSignOut()
        })
        
        present(alert, animated: true)
    }
    
    private func performSignOut() {
        do {
            try FirebaseService.shared.signOut()
        } catch {
            showError("Failed to sign out: \(error.localizedDescription)")
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
