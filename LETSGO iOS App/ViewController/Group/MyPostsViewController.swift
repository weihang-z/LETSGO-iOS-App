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
    private var logs: [JournalEntry] { [] }
    private var selectedSegment: Segment = .joinedGroups {
        didSet { tableView.reloadData() }
    }

    private let segmentedControl = UISegmentedControl(items: ["Joined Groups", "My Logs"])
    private let tableView = UITableView(frame: .zero, style: .grouped)
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
        title = "My Groups & Logs"
        view.backgroundColor = .systemBackground
        configureSegmentedControl()
        configureTableView()
        layoutContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    private func configureSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    private func layoutContent() {
        view.addSubview(segmentedControl)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func segmentChanged() {
        selectedSegment = Segment(rawValue: segmentedControl.selectedSegmentIndex) ?? .joinedGroups
    }
}

extension MyPostsViewController {
    private enum Segment: Int {
        case joinedGroups
        case logs
    }
}

extension MyPostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedSegment {
        case .joinedGroups:
            return joinedGroups.count
        case .logs:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .none

        switch selectedSegment {
        case .joinedGroups:
            let group = joinedGroups[indexPath.row]
            cell.contentConfiguration = joinedGroupConfiguration(for: group)
        case .logs:
            break
        }
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
        switch selectedSegment {
        case .joinedGroups:
            let group = joinedGroups[indexPath.row]
            let controller = JoinedGroupDetailViewController(group: group)
            controller.onLeave = { [weak self] removedGroup in
                self?.dataStore.removeJoinedGroup(with: removedGroup.id)
                self?.tableView.reloadData()
            }
            navigationController?.pushViewController(controller, animated: true)
        case .logs:
            break
        }
    }
}

