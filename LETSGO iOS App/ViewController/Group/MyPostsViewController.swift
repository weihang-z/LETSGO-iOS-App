//
//  MyPostsViewController.swift
//  LETSGO iOS App
//
//  Created by zft on 17/11/2025.
//
import UIKit

final class MyPostsViewController: UIViewController {
    private let groups: [UserGroupSummary]
    private let journals: [JournalEntry]
    private var selectedSegment: Segment = .groups {
        didSet { tableView.reloadData() }
    }

    private let segmentedControl = UISegmentedControl(items: ["Groups", "Journals"])
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    init(groups: [UserGroupSummary], journals: [JournalEntry]) {
        self.groups = groups
        self.journals = journals
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Posts"
        view.backgroundColor = .systemBackground
        configureSegmentedControl()
        configureTableView()
        layoutContent()
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
        selectedSegment = Segment(rawValue: segmentedControl.selectedSegmentIndex) ?? .groups
    }
}

extension MyPostsViewController {
    private enum Segment: Int {
        case groups
        case journals
    }
}

extension MyPostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedSegment {
        case .groups:
            return groups.count
        case .journals:
            return journals.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .none

        switch selectedSegment {
        case .groups:
            let item = groups[indexPath.row]
            cell.textLabel?.text = item.destination
            cell.detailTextLabel?.text = nil
            cell.contentConfiguration = groupConfiguration(for: item)
        case .journals:
            let item = journals[indexPath.row]
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = nil
            cell.contentConfiguration = journalConfiguration(for: item)
        }
        return cell
    }

    private func groupConfiguration(for group: UserGroupSummary) -> UIListContentConfiguration {
        var config = UIListContentConfiguration.subtitleCell()
        config.text = group.destination
        let details = "\(dateFormatter.string(from: group.departureDate))  ·  \(group.peopleCount) people  ·  $\(group.budget)"
        config.secondaryText = details
        config.image = UIImage(systemName: "person.3.fill")
        config.imageProperties.tintColor = .systemBlue
        return config
    }

    private func journalConfiguration(for journal: JournalEntry) -> UIListContentConfiguration {
        var config = UIListContentConfiguration.subtitleCell()
        config.text = journal.title
        config.secondaryText = dateFormatter.string(from: journal.date)
        config.image = journal.coverImage ?? UIImage(systemName: "book")
        config.imageProperties.tintColor = .systemPink
        return config
    }
}

extension MyPostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message: String
        switch selectedSegment {
        case .groups:
            let group = groups[indexPath.row]
            message = "Open group detail for \(group.destination)."
        case .journals:
            let journal = journals[indexPath.row]
            message = "Open journal detail for \(journal.title)."
        }

        let alert = UIAlertController(title: "Coming Soon", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

