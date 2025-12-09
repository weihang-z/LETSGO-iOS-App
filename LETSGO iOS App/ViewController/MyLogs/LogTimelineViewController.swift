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
    private var filteredLogs: [TravelLogEntry] = []
    private var selectedYear: Int?
    private var selectedCity: String?
    
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
        applyFilters()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if allowsCreation {
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineView.tableView.delegate = self
        timelineView.tableView.dataSource = self
        timelineView.tableView.register(LogCardCell.self, forCellReuseIdentifier: LogCardCell.identifier)
        timelineView.emptyStateView.isHidden = true
        
        timelineView.newLogButton.addTarget(self, action: #selector(newLogTapped), for: .touchUpInside)
        timelineView.newLogButton.isHidden = allowsCreation == false
        timelineView.newLogButton.isEnabled = allowsCreation
        
        timelineView.yearFilterButton.addTarget(self, action: #selector(yearFilterTapped), for: .touchUpInside)
        timelineView.locationFilterButton.addTarget(self, action: #selector(locationFilterTapped), for: .touchUpInside)
        
        updateFilterButtonTitles()
        
        if allowsCreation == false {
            title = "My Logs"
        }
        
        applyFilters()
    }
    
    private func applyFilters() {
        filteredLogs = dataStore.logs.filter { log in
            let matchesYear = selectedYear.map { $0 == log.year } ?? true
            let matchesCity = selectedCity.map { $0 == log.city } ?? true
            return matchesYear && matchesCity
        }
        timelineView.tableView.reloadData()
        timelineView.emptyStateView.isHidden = !filteredLogs.isEmpty
    }
    
    private func updateFilterButtonTitles() {
        let yearTitle = selectedYear.map { "\($0)" } ?? "All Years"
        let cityTitle = selectedCity ?? "All Places"
        timelineView.yearFilterButton.setTitle("\(yearTitle) ▼", for: .normal)
        timelineView.locationFilterButton.setTitle("\(cityTitle) ▼", for: .normal)
    }
    
    @objc private func yearFilterTapped() {
        let years = Array(Set(dataStore.logs.map { $0.year })).sorted(by: >)
        let alert = UIAlertController(title: "Filter by Year", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "All Years", style: .default, handler: { [weak self] _ in
            self?.selectedYear = nil
            self?.updateFilterButtonTitles()
            self?.applyFilters()
        }))
        years.forEach { year in
            alert.addAction(UIAlertAction(title: "\(year)", style: .default, handler: { [weak self] _ in
                self?.selectedYear = year
                self?.updateFilterButtonTitles()
                self?.applyFilters()
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc private func locationFilterTapped() {
        let cities = Array(Set(dataStore.logs.map { $0.city })).sorted()
        let alert = UIAlertController(title: "Filter by City", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "All Places", style: .default, handler: { [weak self] _ in
            self?.selectedCity = nil
            self?.updateFilterButtonTitles()
            self?.applyFilters()
        }))
        cities.forEach { city in
            alert.addAction(UIAlertAction(title: city, style: .default, handler: { [weak self] _ in
                self?.selectedCity = city
                self?.updateFilterButtonTitles()
                self?.applyFilters()
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc func newLogTapped() {
        let createVC = CreateEditLogViewController()
        createVC.onSave = { [weak self] newEntry in
            self?.dataStore.add(newEntry)
            self?.applyFilters()
        }
        let navController = UINavigationController(rootViewController: createVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}

extension LogTimelineViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LogCardCell.identifier, for: indexPath) as! LogCardCell
        let entry = filteredLogs[indexPath.row]
        cell.configure(with: entry, formatter: dateFormatter)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let entry = filteredLogs[indexPath.row]
        let detailVC = LogDetailViewController()
        detailVC.logLocation = entry.location
        detailVC.logDate = "\(dateFormatter.string(from: entry.startDate)) - \(dateFormatter.string(from: entry.endDate))"
        detailVC.logTitle = entry.title
        detailVC.logContent = entry.summary
        detailVC.logIsPrivate = entry.isPrivate
        detailVC.logTags = entry.tags
        detailVC.logPhotoCount = entry.photoCount
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
