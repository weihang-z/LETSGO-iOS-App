//
//  FriendLogViewController.swift
//  LETSGO ios App
//

import UIKit

class FriendLogViewController: UIViewController {
    
    // MARK: - UI Elements
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(FriendLogCell.self, forCellReuseIdentifier: "FriendLogCell")
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Friend's Log"
        view.backgroundColor = .systemBackground
        
        // Add navigation button to see all friends
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "My Friends",
            style: .plain,
            target: self,
            action: #selector(showFriendList)
        )
        
        view.addSubview(addFriendButton)
        view.addSubview(tableView)
        
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
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func addFriendButtonTapped() {
        let addFriendVC = AddFriendViewController()
        navigationController?.pushViewController(addFriendVC, animated: true)
    }
    
    @objc private func showFriendList() {
        let friendListVC = FriendListViewController()
        navigationController?.pushViewController(friendListVC, animated: true)
    }
}

// MARK: - UITableViewDelegate & DataSource
extension FriendLogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.friendLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendLogCell", for: indexPath) as? FriendLogCell else {
            return UITableViewCell()
        }
        
        let log = DataManager.shared.friendLogs[indexPath.row]
        cell.configure(with: log)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let log = DataManager.shared.friendLogs[indexPath.row]
        
        // Check if this person is in our friends list
        if let friend = DataManager.shared.friends.first(where: { $0.username == log.name }) {
            // Show friend profile (with edit nickname button and phone number)
            let detailVC = FriendDetailViewController()
            detailVC.friend = friend
            detailVC.onNicknameUpdated = { [weak self] in
                self?.tableView.reloadData()
            }
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            // Show log details only
            let detailVC = FriendDetailViewController()
            detailVC.friendLog = log
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: - Custom Cell
class FriendLogCell: UITableViewCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = .systemGray2
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
        contentView.addSubview(nameLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(activityLabel)
        contentView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            activityLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 5),
            activityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            activityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            timeLabel.topAnchor.constraint(equalTo: activityLabel.bottomAnchor, constant: 5),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            timeLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with log: FriendLog) {
        nameLabel.text = "📍 \(log.name)"
        locationLabel.text = log.location
        activityLabel.text = log.activity
        timeLabel.text = log.time
    }
}
