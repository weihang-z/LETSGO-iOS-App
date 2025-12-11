//
//   LogTimelineViewController.swift
//  LETSGO iOS App
//
//  Created by Weihang Zeng on 11/17/25.
//

import UIKit

class LogTimelineViewController: UIViewController {
    
    var timelineView: LogTimelineView!
    private let allowsCreation: Bool
    private let dataStore = TravelLogDataStore.shared
    
    private var groupedLogs: [(monthYear: String, logs: [TravelLogEntry])] = []
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    init(allowsCreation: Bool = true) {
        self.allowsCreation = allowsCreation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.allowsCreation = true
        super.init(coder: coder)
    }
    
    override func loadView() {
        timelineView = LogTimelineView()
        view = timelineView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if allowsCreation {
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }
        reloadLogs()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if allowsCreation {
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupActions()
        setupDataStoreCallback()
        
        if allowsCreation == false {
            title = "My Logs"
            timelineView.titleLabel.isHidden = true
        }
        
        fetchLogsIfNeeded()
    }
    
    private func setupDataStoreCallback() {
        dataStore.onLogsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.reloadLogs()
            }
        }
    }
    
    private func fetchLogsIfNeeded() {
        if FirebaseService.shared.isLoggedIn {
            timelineView.loadingIndicator.startAnimating()
            timelineView.tableView.isUserInteractionEnabled = false
            dataStore.fetchLogsFromFirebase { [weak self] success in
                DispatchQueue.main.async {
                    self?.timelineView.loadingIndicator.stopAnimating()
                    self?.timelineView.tableView.isUserInteractionEnabled = true
                    self?.reloadLogs()
                }
            }
        } else {
            reloadLogs()
        }
    }
    
    private func reloadLogs() {
        groupedLogs = dataStore.logsGroupedByMonth()
        timelineView.tableView.reloadData()
        
        let totalLogs = groupedLogs.reduce(0) { $0 + $1.logs.count }
        timelineView.emptyStateView.isHidden = totalLogs > 0
        timelineView.tableView.isHidden = totalLogs == 0
    }
    
    private func setupTableView() {
        timelineView.tableView.delegate = self
        timelineView.tableView.dataSource = self
        timelineView.tableView.register(LogCardCell.self, forCellReuseIdentifier: LogCardCell.identifier)
        timelineView.tableView.register(MonthHeaderView.self, forHeaderFooterViewReuseIdentifier: MonthHeaderView.identifier)
        timelineView.tableView.sectionHeaderHeight = 44
        timelineView.emptyStateView.isHidden = true
    }
    
    private func setupActions() {
        timelineView.newLogButton.addTarget(self, action: #selector(newLogTapped), for: .touchUpInside)
        timelineView.newLogButton.isHidden = !allowsCreation
        timelineView.newLogButton.isEnabled = allowsCreation
        
        timelineView.searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
    }
    
    
    @objc private func searchTapped() {
        let alert = UIAlertController(title: "Search Logs", message: "Enter a keyword to search", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Search by title, location, tags..."
            textField.clearButtonMode = .whileEditing
        }
        
        alert.addAction(UIAlertAction(title: "Search", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let query = alert.textFields?.first?.text ?? ""
            if query.isEmpty {
                self.reloadLogs()
            } else {
                let results = self.dataStore.search(query: query)
                let grouped = Dictionary(grouping: results) { $0.monthYearKey }
                let sortedKeys = grouped.keys.sorted { key1, key2 in
                    guard let log1 = grouped[key1]?.first, let log2 = grouped[key2]?.first else { return false }
                    return log1.startDate > log2.startDate
                }
                self.groupedLogs = sortedKeys.map { (monthYear: $0, logs: grouped[$0] ?? []) }
                self.timelineView.tableView.reloadData()
            }
        })
        
        alert.addAction(UIAlertAction(title: "Show All", style: .default) { [weak self] _ in
            self?.reloadLogs()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc func newLogTapped() {
        let createVC = CreateEditLogViewController()
        createVC.onSave = { [weak self] newEntry in
            self?.dataStore.add(newEntry) { success in
                if success {
                    self?.reloadLogs()
                } else {
                    self?.showSaveError(message: "We couldn't save this log to the cloud. Please try again.")
                }
            }
        }
        let navController = UINavigationController(rootViewController: createVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}

extension LogTimelineViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedLogs.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedLogs[section].logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LogCardCell.identifier, for: indexPath) as! LogCardCell
        let entry = groupedLogs[indexPath.section].logs[indexPath.row]
        cell.configure(with: entry, formatter: dateFormatter)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MonthHeaderView.identifier) as? MonthHeaderView
        header?.monthLabel.text = groupedLogs[section].monthYear
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let entry = groupedLogs[indexPath.section].logs[indexPath.row]
        
        let detailVC = LogDetailViewController(entry: entry)
        detailVC.onUpdate = { [weak self] updatedEntry in
            self?.dataStore.update(updatedEntry) { success in
                if success {
                    self?.reloadLogs()
                } else {
                    self?.showSaveError(message: "Couldn't update this log right now. Please try again.")
                }
            }
        }
        detailVC.onDelete = { [weak self] deletedEntry in
            self?.dataStore.delete(deletedEntry)
            self?.reloadLogs()
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func showSaveError(message: String) {
        let alert = UIAlertController(
            title: "Sync Issue",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            guard let self = self else {
                completionHandler(false)
                return
            }
            
            let entry = self.groupedLogs[indexPath.section].logs[indexPath.row]
            self.showDeleteConfirmation(for: entry) { confirmed in
                if confirmed {
                    self.dataStore.delete(entry)
                    self.reloadLogs()
                }
                completionHandler(confirmed)
            }
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func showDeleteConfirmation(for entry: TravelLogEntry, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(
            title: "Delete Log",
            message: "Are you sure you want to delete \"\(entry.title)\"? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false)
        })
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            completion(true)
        })
        
        present(alert, animated: true)
    }
}
