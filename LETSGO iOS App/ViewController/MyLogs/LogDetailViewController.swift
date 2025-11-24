//
//  LogDetailViewController.swift
//  LETSGO iOS App
//
//  Created by Weihang Zeng on 11/17/25.
//

import UIKit

class LogDetailViewController: UIViewController {
    
    var detailView: LogDetailView!
    
    override func loadView() {
        detailView = LogDetailView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log Detail"
        
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
