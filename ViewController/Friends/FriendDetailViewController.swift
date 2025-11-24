//
//  FriendDetailViewController.swift
//  LETSGO ios App
//

import UIKit

class FriendDetailViewController: UIViewController {
    
    // MARK: - Properties
    var friend: Friend?
    var friendLog: FriendLog?
    var onNicknameUpdated: (() -> Void)?
    
    // MARK: - UI Elements
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationIcon: UILabel = {
        let label = UILabel()
        label.text = "📍"
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let phoneIcon: UILabel = {
        let label = UILabel()
        label.text = "📞"
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .systemGray2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        configure()
        
        // Add edit button for friends (not for friend logs)
        if friend != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "Edit Nickname",
                style: .plain,
                target: self,
                action: #selector(editNicknameTapped)
            )
        }
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Friend Details"
        view.backgroundColor = .systemBackground
        
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(usernameLabel)
        containerView.addSubview(locationIcon)
        containerView.addSubview(locationLabel)
        containerView.addSubview(phoneIcon)
        containerView.addSubview(phoneLabel)
        containerView.addSubview(noteLabel)
        containerView.addSubview(timeLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            usernameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            usernameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            locationIcon.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 20),
            locationIcon.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -40),
            
            locationLabel.centerYAnchor.constraint(equalTo: locationIcon.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationIcon.trailingAnchor, constant: 5),
            
            phoneIcon.topAnchor.constraint(equalTo: locationIcon.bottomAnchor, constant: 15),
            phoneIcon.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -50),
            
            phoneLabel.centerYAnchor.constraint(equalTo: phoneIcon.centerYAnchor),
            phoneLabel.leadingAnchor.constraint(equalTo: phoneIcon.trailingAnchor, constant: 5),
            
            noteLabel.topAnchor.constraint(equalTo: phoneIcon.bottomAnchor, constant: 20),
            noteLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            noteLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            timeLabel.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 15),
            timeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            timeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30)
        ])
    }
    
    private func configure() {
        if let friend = friend {
            // Show nickname if it exists, otherwise show username
            nameLabel.text = friend.nickname ?? friend.username
            usernameLabel.text = friend.nickname != nil ? "@\(friend.username)" : ""
            usernameLabel.isHidden = friend.nickname == nil
            locationLabel.text = friend.region
            phoneLabel.text = friend.phoneNumber.isEmpty ? "Not provided" : friend.phoneNumber
            phoneLabel.textColor = friend.phoneNumber.isEmpty ? .systemGray : .systemBlue
            noteLabel.text = friend.note.isEmpty ? "No notes" : friend.note
            timeLabel.text = ""
            phoneIcon.isHidden = false
            phoneLabel.isHidden = false
        } else if let log = friendLog {
            nameLabel.text = log.name
            usernameLabel.isHidden = true
            locationLabel.text = log.location
            phoneIcon.isHidden = true
            phoneLabel.isHidden = true
            noteLabel.text = log.activity
            timeLabel.text = log.time
        }
    }
    
    @objc private func editNicknameTapped() {
        guard let friend = friend else { return }
        
        let alert = UIAlertController(
            title: "Edit Nickname",
            message: "Set a personal nickname for \(friend.username)",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Enter nickname"
            textField.text = friend.nickname
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let textField = alert.textFields?.first else { return }
            let nickname = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let finalNickname = (nickname?.isEmpty ?? true) ? nil : nickname
            self?.updateNickname(finalNickname)
        })
        
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive) { [weak self] _ in
            self?.updateNickname(nil)
        })
        
        present(alert, animated: true)
    }
    
    private func updateNickname(_ nickname: String?) {
        guard let friend = friend else { return }
        
        // Update the friend in DataManager
        DataManager.shared.updateFriendNickname(username: friend.username, nickname: nickname)
        
        // Update local friend reference
        self.friend = Friend(
            username: friend.username,
            region: friend.region,
            note: friend.note,
            phoneNumber: friend.phoneNumber,
            nickname: nickname
        )
        
        // Update UI
        configure()
        
        // Notify callback
        onNicknameUpdated?()
    }
}
