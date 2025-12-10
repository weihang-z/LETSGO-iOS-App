//
//  EditProfileViewController.swift
//  LETSGO iOS App
//
//  Created by zft on 17/11/2025.
//

import UIKit

final class EditProfileViewController: UIViewController {
    var onSave: ((UserProfile) -> Void)?

    private var profile: UserProfile

    private let avatarButton = UIButton(type: .system)
    private let usernameField = UITextField()
    private let bioTextView = UITextView()

    init(profile: UserProfile) {
        self.profile = profile
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Edit Profile"
        configureNavigationItems()
        configureAvatarButton()
        configureFields()
        layoutContent()
        populateFields()
    }

    private func configureNavigationItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveTapped)
        )
    }

    private func configureAvatarButton() {
        avatarButton.translatesAutoresizingMaskIntoConstraints = false
        avatarButton.tintColor = .systemBlue
        avatarButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        avatarButton.layer.cornerRadius = 50
        avatarButton.setImage(nil, for: .normal)
        updateAvatarButtonImage()
        avatarButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        avatarButton.widthAnchor.constraint(equalTo: avatarButton.heightAnchor).isActive = true
        avatarButton.addTarget(self, action: #selector(avatarTapped), for: .touchUpInside)
    }

    private func configureFields() {
        usernameField.borderStyle = .roundedRect
        usernameField.placeholder = "Username"
        usernameField.autocapitalizationType = .none

        bioTextView.layer.cornerRadius = 12
        bioTextView.layer.borderWidth = 1
        bioTextView.layer.borderColor = UIColor.systemGray4.cgColor
        bioTextView.font = UIFont.preferredFont(forTextStyle: .body)
    }

    private func layoutContent() {
        let labelsStack = UIStackView(arrangedSubviews: [makeFieldLabel(text: "Username"), usernameField, makeFieldLabel(text: "Bio"), bioTextView])
        labelsStack.axis = .vertical
        labelsStack.spacing = 12

        let container = UIStackView(arrangedSubviews: [avatarButton, labelsStack])
        container.axis = .vertical
        container.spacing = 24
        container.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(container)
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bioTextView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }

    private func populateFields() {
        usernameField.text = profile.username
        bioTextView.text = profile.bio
    }

    private func updateAvatarButtonImage() {
        if let image = profile.avatarImage {
            avatarButton.setBackgroundImage(image, for: .normal)
            avatarButton.setImage(nil, for: .normal)
        } else {
            avatarButton.setBackgroundImage(nil, for: .normal)
            avatarButton.setImage(UIImage(systemName: "person.crop.circle"), for: .normal)
        }
    }

    @objc private func avatarTapped() {
        let controller = AvatarUploadViewController(currentImage: profile.avatarImage)
        controller.onSave = { [weak self] updatedImage in
            guard let self else { return }
            self.profile.avatarImage = updatedImage
            self.updateAvatarButtonImage()
        }
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func saveTapped() {
        var updated = profile
        let trimmedUsername = usernameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        updated.username = trimmedUsername.isEmpty ? profile.username : trimmedUsername

        let trimmedBio = bioTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        updated.bio = trimmedBio.isEmpty ? nil : trimmedBio
        profile = updated
        onSave?(updated)
    }

    private func makeFieldLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.text = text.uppercased()
        return label
    }
}
