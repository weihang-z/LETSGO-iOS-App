//
//  CreateEditLogViewController.swift
//  LETSGO iOS App
//
//  Created by Weihang Zeng on 11/17/25.
//

import UIKit

class CreateEditLogViewController: UIViewController {
    
    var createEditView: CreateEditLogView!
    
    override func loadView() {
        createEditView = CreateEditLogView()
        view = createEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Travel Log"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(closeTapped)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveTapped)
        )
        
    }
    
    @objc func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc func saveTapped() {
        dismiss(animated: true)
    }
    
}
