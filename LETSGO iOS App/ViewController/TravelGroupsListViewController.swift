//
//  TravelGroupsListViewController.swift
//  LETSGO iOS App
//
//  Created by zft on 17/11/2025.
//

import UIKit

final class TravelGroupsListViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let dataStore: GroupDataStore
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    init(dataStore: GroupDataStore) {
        self.dataStore = dataStore
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Travel Groups"
        configureTableView()
        configureNavigationItems()
    }

    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GroupCardCell.self, forCellReuseIdentifier: GroupCardCell.reuseIdentifier)

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        let headerLabel = UILabel()
        headerLabel.text = "Discover nearby trips run by real travelers."
        headerLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        headerLabel.textColor = .secondaryLabel
        headerLabel.numberOfLines = 0
        headerLabel.textAlignment = .center
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        let headerContainer = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80))
        headerContainer.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 24),
            headerLabel.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -24),
            headerLabel.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor)
        ])
        tableView.tableHeaderView = headerContainer
    }

    private func configureNavigationItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "+ Create",
            style: .done,
            target: self,
            action: #selector(createGroupTapped)
        )
    }

    @objc private func createGroupTapped() {
        let controller = CreateGroupViewController(mode: .create, group: nil, currentUser: dataStore.currentUser)
        controller.onSave = { [weak self] group in
            self?.dataStore.add(group)
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(controller, animated: true)
    }

    private func openDetail(for group: Group) {
        let detailController = GroupDetailViewController(groupID: group.id, dataStore: dataStore)
        detailController.onGroupChanged = { [weak self] _ in
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(detailController, animated: true)
    }
}

extension TravelGroupsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStore.groups.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupCardCell.reuseIdentifier, for: indexPath) as? GroupCardCell else {
            return UITableViewCell()
        }
        let group = dataStore.groups[indexPath.row]
        cell.configure(with: group, formatter: dateFormatter)
        return cell
    }
}

extension TravelGroupsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = dataStore.groups[indexPath.row]
        openDetail(for: group)
    }
}
