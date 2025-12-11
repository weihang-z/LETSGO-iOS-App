//
//  MyPostsViewController.swift
//  LETSGO iOS App
//
//  Created by zft on 17/11/2025.
//

import UIKit
import FirebaseAuth

final class MyPostsViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let dataStore: UserContentDataStore
    private let groupDataStore: GroupDataStore
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    private var myGroups: [Group] = []
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "You haven't joined or created any groups yet."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    init(dataStore: UserContentDataStore) {
        self.dataStore = dataStore
        self.groupDataStore = GroupDataStore()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "My Groups"
        configureTableView()
        fetchMyGroups()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMyGroups()
    }
    
    private func fetchMyGroups() {
        activityIndicator.startAnimating()
        emptyStateLabel.isHidden = true
        
        guard let currentUsername = FirebaseService.shared.currentUser?.displayName ?? FirebaseService.shared.currentUser?.email else {
            self.myGroups = []
            self.tableView.reloadData()
            self.updateEmptyState()
            self.activityIndicator.stopAnimating()
            return
        }
        
        groupDataStore.fetchGroupsFromFirebase { [weak self] success in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                
                if success, let groups = self?.groupDataStore.groups {
                    
                    self?.myGroups = groups.filter { group in
                        let isOrganizer = group.organizer == currentUsername
                        let isMember = group.members.contains { $0.name == currentUsername }
                        return isOrganizer || isMember
                    }
                    
                    self?.tableView.reloadData()
                    self?.updateEmptyState()
                } else {
                    self?.myGroups = []
                    self?.tableView.reloadData()
                    self?.updateEmptyState()
                }
            }
        }
    }
    
    private func updateEmptyState() {
        emptyStateLabel.isHidden = !myGroups.isEmpty
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
    }
}

extension MyPostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGroups.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupCardCell.reuseIdentifier, for: indexPath) as? GroupCardCell else {
            return UITableViewCell()
        }
        let group = myGroups[indexPath.row]
        cell.configure(with: group, formatter: dateFormatter)
        return cell
    }
}

extension MyPostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = myGroups[indexPath.row]
        let detailController = GroupDetailViewController(groupID: group.id, dataStore: groupDataStore)
        detailController.onGroupChanged = { [weak self] _ in
            self?.fetchMyGroups()
        }
        detailController.onGroupDeleted = { [weak self] _ in
            self?.fetchMyGroups()
        }
        navigationController?.pushViewController(detailController, animated: true)
    }
}
