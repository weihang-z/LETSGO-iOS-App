//
//  FriendListViewController.swift
//  LETSGO ios App
//

import UIKit

class FriendListViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(FriendCell.self, forCellReuseIdentifier: "FriendCell")
        return table
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No friends yet!\nTap 'Add Friend' to get started"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupDataManagerCallback()
        fetchFriends()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        updateEmptyState()
    }
    
    private func setupUI() {
        title = "Friends"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)
        view.addSubview(activityIndicator)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupDataManagerCallback() {
        DataManager.shared.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.updateEmptyState()
            }
        }
    }
    
    private func fetchFriends() {
        activityIndicator.startAnimating()
        emptyStateLabel.isHidden = true
        
        DataManager.shared.fetchFriends { [weak self] _ in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
                self?.updateEmptyState()
            }
        }
    }
    
    private func updateEmptyState() {
        emptyStateLabel.isHidden = !DataManager.shared.friends.isEmpty
    }
}

extension FriendListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell else {
            return UITableViewCell()
        }
        
        let friend = DataManager.shared.friends[indexPath.row]
        cell.configure(with: friend)
        cell.loadAvatar(urlString: friend.avatarURL)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let friend = DataManager.shared.friends[indexPath.row]
        let detailVC = FriendDetailViewController()
        detailVC.friend = friend
        detailVC.onNicknameUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Remove") { [weak self] _, _, completionHandler in
            let friend = DataManager.shared.friends[indexPath.row]
            
            let alert = UIAlertController(
                title: "Remove Friend",
                message: "Are you sure you want to remove \(friend.username) from your friends?",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                completionHandler(false)
            })
            
            alert.addAction(UIAlertAction(title: "Remove", style: .destructive) { _ in
                DataManager.shared.removeFriend(username: friend.username) { success in
                    completionHandler(success)
                }
            })
            
            self?.present(alert, animated: true)
        }
        deleteAction.image = UIImage(systemName: "person.badge.minus")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

class FriendCell: UITableViewCell {
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let regionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(regionLabel)
        contentView.addSubview(noteLabel)
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            regionLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 2),
            regionLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            regionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            noteLabel.topAnchor.constraint(equalTo: regionLabel.bottomAnchor, constant: 2),
            noteLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            noteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
        ])
    }
    
    func configure(with friend: Friend) {
        usernameLabel.text = friend.nickname ?? friend.username
        
        if let nickname = friend.nickname, !nickname.isEmpty {
            regionLabel.text = "@\(friend.username) • \(friend.region)"
        } else {
            regionLabel.text = friend.region
        }
        
        noteLabel.text = friend.note.isEmpty ? "No notes" : friend.note
    }
    
    func loadAvatar(urlString: String?) {
        guard let urlString = urlString else {
            avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
            avatarImageView.tintColor = .systemBlue
            return
        }
        FirebaseService.shared.downloadImage(from: urlString) { [weak self] image in
            guard let self = self else { return }
            if let image = image {
                self.avatarImageView.image = image
                self.avatarImageView.tintColor = .clear
            } else {
                self.avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
                self.avatarImageView.tintColor = .systemBlue
            }
        }
    }
}
