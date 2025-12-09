//
//  MyPostsViewController.swift
//  LETSGO iOS App
//
//  Created by zft on 17/11/2025.
//
import UIKit

final class MyPostsViewController: UIViewController {
    private let dataStore: UserContentDataStore
    private var joinedGroups: [Group] {
        dataStore.joinedGroups
    }

    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "You have not joined any groups yet."
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    init(dataStore: UserContentDataStore) {
        self.dataStore = dataStore
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Groups"
        view.backgroundColor = .systemBackground
        configureTableView()
        layoutContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    private func layoutContent() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension MyPostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = joinedGroups.isEmpty ? emptyStateLabel : nil
        return joinedGroups.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .none
        let group = joinedGroups[indexPath.row]
        cell.contentConfiguration = joinedGroupConfiguration(for: group)
        return cell
    }

    private func joinedGroupConfiguration(for group: Group) -> UIListContentConfiguration {
        var config = UIListContentConfiguration.subtitleCell()
        config.text = group.destination
        let details = "\(dateFormatter.string(from: group.startDate))  ·  \(group.city)  ·  $\(group.budget)"
        config.secondaryText = details
        config.image = UIImage(systemName: "figure.2.and.child.holdinghands")
        config.imageProperties.tintColor = .systemGreen
        return config
    }

}

extension MyPostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let group = joinedGroups[indexPath.row]
        let controller = JoinedGroupDetailViewController(group: group)
        controller.onLeave = { [weak self] removedGroup in
            self?.dataStore.removeJoinedGroup(with: removedGroup.id)
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}

