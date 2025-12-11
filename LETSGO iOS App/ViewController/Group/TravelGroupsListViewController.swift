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
    private let userContentStore: UserContentDataStore
    private var filterOptions = GroupFilterOptions()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No groups available.\nCreate one to get started!"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    private var currentGroups: [Group] {
        if filterOptions.isEmpty { return dataStore.groups }
        return dataStore.groups.filter { filterOptions.matches($0) }
    }

    init(dataStore: GroupDataStore, userContentStore: UserContentDataStore) {
        self.dataStore = dataStore
        self.userContentStore = userContentStore
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
        setupDataStoreCallback()
        fetchGroups()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        updateEmptyState()
    }
    
    private func setupDataStoreCallback() {
        dataStore.onGroupsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.updateEmptyState()
            }
        }
    }
    
    private func fetchGroups() {
        activityIndicator.startAnimating()
        emptyStateLabel.isHidden = true
        
        dataStore.fetchGroupsFromFirebase { [weak self] _ in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
                self?.updateEmptyState()
            }
        }
    }
    
    private func updateEmptyState() {
        emptyStateLabel.isHidden = !currentGroups.isEmpty
    }

    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GroupCardCell.self, forCellReuseIdentifier: GroupCardCell.reuseIdentifier)

        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Filter",
            style: .plain,
            target: self,
            action: #selector(filterTapped)
        )
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
            self?.userContentStore.addJoinedGroup(group)
            self?.tableView.reloadData()
            self?.updateEmptyState()
        }
        navigationController?.pushViewController(controller, animated: true)
    }

    private func openDetail(for group: Group) {
        let detailController = GroupDetailViewController(groupID: group.id, dataStore: dataStore)
        detailController.onGroupChanged = { [weak self] _ in
            self?.tableView.reloadData()
        }
        detailController.onMembershipChanged = { [weak self] updatedGroup, isMember in
            guard let self else { return }
            if isMember {
                self.userContentStore.addJoinedGroup(updatedGroup)
            } else {
                self.userContentStore.removeJoinedGroup(with: updatedGroup.id)
            }
        }
        detailController.onGroupDeleted = { [weak self] deletedGroup in
            guard let self else { return }
            self.userContentStore.removeJoinedGroup(with: deletedGroup.id)
            self.tableView.reloadData()
            self.updateEmptyState()
        }
        navigationController?.pushViewController(detailController, animated: true)
    }

    @objc private func filterTapped() {
        let controller = GroupFilterViewController(options: filterOptions)
        controller.onApply = { [weak self] options in
            self?.filterOptions = options
            self?.tableView.reloadData()
            self?.updateEmptyState()
        }
        controller.onClear = { [weak self] in
            self?.filterOptions.clear()
            self?.tableView.reloadData()
            self?.updateEmptyState()
        }
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .pageSheet
        present(nav, animated: true)
    }
}

extension TravelGroupsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentGroups.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupCardCell.reuseIdentifier, for: indexPath) as? GroupCardCell else {
            return UITableViewCell()
        }
        let group = currentGroups[indexPath.row]
        cell.configure(with: group, formatter: dateFormatter)
        return cell
    }
}

extension TravelGroupsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = currentGroups[indexPath.row]
        openDetail(for: group)
    }
}
