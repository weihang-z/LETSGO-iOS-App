//
//  AddFriendViewController.swift
//  LETSGO ios App
//

import UIKit

class AddFriendViewController: UIViewController {
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter username"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let regionLabel: UILabel = {
        let label = UILabel()
        label.text = "Region"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let regionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter region"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.text = "Note"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let noteTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter note"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Add Friend"
        view.backgroundColor = .systemBackground
        
        view.addSubview(usernameLabel)
        view.addSubview(usernameTextField)
        view.addSubview(regionLabel)
        view.addSubview(regionTextField)
        view.addSubview(noteLabel)
        view.addSubview(noteTextField)
        view.addSubview(saveButton)
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            usernameTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            usernameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            regionLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            regionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            regionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            regionTextField.topAnchor.constraint(equalTo: regionLabel.bottomAnchor, constant: 10),
            regionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            regionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            regionTextField.heightAnchor.constraint(equalToConstant: 44),
            
            noteLabel.topAnchor.constraint(equalTo: regionTextField.bottomAnchor, constant: 20),
            noteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            noteTextField.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 10),
            noteTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noteTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            noteTextField.heightAnchor.constraint(equalToConstant: 44),
            
            saveButton.topAnchor.constraint(equalTo: noteTextField.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func saveButtonTapped() {
        guard let username = usernameTextField.text, !username.isEmpty else {
            showAlert(message: "Please enter a username")
            return
        }
        
        guard let region = regionTextField.text, !region.isEmpty else {
            showAlert(message: "Please enter a region")
            return
        }
        
        let note = noteTextField.text ?? ""
        
        let newFriend = Friend(username: username, region: region, note: note)
        DataManager.shared.addFriend(newFriend)
        
        let alert = UIAlertController(title: "Success", message: "Friend added successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            let friendListVC = FriendListViewController()
            self?.navigationController?.pushViewController(friendListVC, animated: true)
        })
        present(alert, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
