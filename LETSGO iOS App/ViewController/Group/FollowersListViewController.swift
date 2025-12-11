//  FollowersListViewController.swift
//  LETSGO iOS App
//
//  Created by zft on 22/11/2025.
//
import UIKit

final class FollowersListViewController: UIViewController {
    private let users: [SocialUser]
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let cellIdentifier = "FollowerCell"

    init(title: String, users: [SocialUser]) {
        self.users = users
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTableView()
    }

    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 72
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension FollowersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let user = users[indexPath.row]
        var config = UIListContentConfiguration.subtitleCell()
        config.text = "@\(user.username)"
        config.secondaryText = user.city
        config.image = nil
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension FollowersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = users[indexPath.row]
        let detail = FriendDetailViewController()
        let followerLog = FriendLog(
            name: user.username,
            location: user.city,
            activity: "",
            time: ""
        )
        detail.friendLog = followerLog
        navigationController?.pushViewController(detail, animated: true)
    }
}

final class FollowingFriendsViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let cellIdentifier = "FollowingFriendCell"
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "You are not following anyone yet.\nAdd friends from the Friends tab."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()

    private var friends: [Friend] {
        DataManager.shared.friends
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Following"
        view.backgroundColor = .systemBackground
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        updateBackgroundView()
    }

    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 72
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func updateBackgroundView() {
        tableView.backgroundView = friends.isEmpty ? emptyStateLabel : nil
    }
}

extension FollowingFriendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        let friend = friends[indexPath.row]
        var configuration = UIListContentConfiguration.subtitleCell()
        configuration.text = friend.nickname ?? friend.username
        configuration.secondaryText = friend.region
        configuration.image = nil
        cell.contentConfiguration = configuration
        return cell
    }
}

extension FollowingFriendsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let friend = friends[indexPath.row]
        let controller = FriendDetailViewController()
        controller.friend = friend
        controller.onNicknameUpdated = { [weak self] in
            self?.tableView.reloadData()
            self?.updateBackgroundView()
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}
