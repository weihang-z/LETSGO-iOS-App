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
        config.secondaryText = "\(user.tagline) · \(user.city)"
        config.image = user.avatarImage ?? UIImage(systemName: "person.circle")
        config.imageProperties.tintColor = .systemBlue
        cell.contentConfiguration = config
        return cell
    }
}
