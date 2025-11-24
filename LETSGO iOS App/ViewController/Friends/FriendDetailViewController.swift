//
//  FriendDetailViewController.swift
//  LETSGO ios App
//

import UIKit

class FriendDetailViewController: UIViewController {
    
    // MARK: - Properties
    var friend: Friend?
    var friendLog: FriendLog?
    
    // MARK: - UI Elements
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
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
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Friend Details"
        view.backgroundColor = .systemBackground
        
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(locationIcon)
        containerView.addSubview(locationLabel)
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
            
            locationIcon.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            locationIcon.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -30),
            
            locationLabel.centerYAnchor.constraint(equalTo: locationIcon.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationIcon.trailingAnchor, constant: 5),
            
            noteLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20),
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
            nameLabel.text = friend.username
            locationLabel.text = friend.region
            noteLabel.text = friend.note
            timeLabel.text = ""
        } else if let log = friendLog {
            nameLabel.text = log.name
            locationLabel.text = log.location
            noteLabel.text = log.activity
            timeLabel.text = log.time
        }
    }
}
