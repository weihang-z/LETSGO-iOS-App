//
//  LogDetailViewController.swift
//  LETSGO iOS App
//
//  Created by Weihang Zeng on 11/17/25.
//

import UIKit

class LogDetailViewController: UIViewController {
    
    var detailView: LogDetailView!
    
    var logLocation: String = ""
    var logDate: String = ""
    var logTitle: String = ""
    var logContent: String = ""
    var logIsPrivate: Bool = true
    var logTags: [String] = []
    var logPhotoCount: Int = 0
    
    override func loadView() {
        detailView = LogDetailView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log Detail"
        
        detailView.configure(
            location: logLocation,
            date: logDate,
            title: logTitle,
            content: logContent,
            isPrivate: logIsPrivate,
            tags: logTags,
            photoCount: logPhotoCount
        )
        
        detailView.editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        detailView.deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }
    
    @objc func editTapped() {
        let editVC = CreateEditLogViewController()
        let navController = UINavigationController(rootViewController: editVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    @objc func deleteTapped() {
        navigationController?.popViewController(animated: true)
    }
}
