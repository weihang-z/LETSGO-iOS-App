//
//  FriendListViewController.swift
//  LETSGO ios App
//

import UIKit

class FriendListViewController: UIViewController {
    
    // MARK: - UI Elements
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(FriendCell.self, forCellReuseIdentifier: "FriendCell")
        return table
    }()
    
    private let addFriendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Friend", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        updateEmptyState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        updateEmptyState()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Friends"
        view.backgroundColor = .systemBackground
        
        view.addSubview(addFriendButton)
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addFriendButton.addTarget(self, action: #selector(addFriendButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            addFriendButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            addFriendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addFriendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addFriendButton.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: addFriendButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    private func updateEmptyState() {
        emptyStateLabel.isHidden = !DataManager.shared.friends.isEmpty
    }
    
    // MARK: - Actions
    @objc private func addFriendButtonTapped() {
        let addFriendVC = AddFriendViewController()
        navigationController?.pushViewController(addFriendVC, animated: true)
    }
}

// MARK: - UITableViewDelegate & DataSource
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
}

// MARK: - Custom Cell
class FriendCell: UITableViewCell {
    
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
        label.numberOfLines = 0
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
        contentView.addSubview(usernameLabel)
        contentView.addSubview(regionLabel)
        contentView.addSubview(noteLabel)
        
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            regionLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5),
            regionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            regionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            noteLabel.topAnchor.constraint(equalTo: regionLabel.bottomAnchor, constant: 5),
            noteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            noteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            noteLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with friend: Friend) {
        // Show nickname if it exists, otherwise show username
        usernameLabel.text = friend.nickname ?? friend.username
        
        // Show actual username in gray if nickname exists
        if let nickname = friend.nickname, !nickname.isEmpty {
            regionLabel.text = "@\(friend.username) • \(friend.region)"
        } else {
            regionLabel.text = friend.region
        }
        
        noteLabel.text = friend.note.isEmpty ? "No notes" : friend.note
    }
}
