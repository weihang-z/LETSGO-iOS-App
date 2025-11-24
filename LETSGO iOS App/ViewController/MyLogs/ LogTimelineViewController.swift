//
//   LogTimelineViewController.swift
//  LETSGO iOS App
//
//  Created by Weihang Zeng on 11/17/25.
//

import UIKit

class LogTimelineViewController: UIViewController {
    
    var timelineView: LogTimelineView!
    
    override func loadView() {
        timelineView = LogTimelineView()
        view = timelineView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Logs"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        timelineView.tableView.delegate = self
        timelineView.tableView.dataSource = self
        timelineView.tableView.register(LogCardCell.self, forCellReuseIdentifier: LogCardCell.identifier)
        timelineView.emptyStateView.isHidden = true
        
        timelineView.newLogButton.addTarget(self, action: #selector(newLogTapped), for: .touchUpInside)
    }
    
    @objc func newLogTapped() {
        let createVC = CreateEditLogViewController()
        let navController = UINavigationController(rootViewController: createVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}

extension LogTimelineViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LogCardCell.identifier, for: indexPath) as! LogCardCell
        cell.locationLabel.text = "Paris, France"
        cell.titleLabel.text = "Trip to Eiffel Tower"
        cell.dateLabel.text = "Nov 10-15, 2024"
        cell.morePhotosLabel.text = "+5"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = LogDetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
