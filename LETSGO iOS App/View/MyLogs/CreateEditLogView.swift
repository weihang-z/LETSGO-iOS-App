//
//  CreateEditLogView.swift
//  LETSGO iOS App
//
//  Created by Weihang Zeng on 11/17/25.
//

import UIKit

class CreateEditLogView: UIView {
    
    var titleTextField: UITextField!
    var locationTextField: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        setupViews()
        initConstraints()
    }
    
    func setupViews() {
        titleTextField = UITextField()
        titleTextField.placeholder = "Title"
        titleTextField.borderStyle = .roundedRect
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleTextField)
        
        locationTextField = UITextField()
        locationTextField.placeholder = "Location"
        locationTextField.borderStyle = .roundedRect
        locationTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(locationTextField)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            locationTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            locationTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            locationTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
