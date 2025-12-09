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
        textField.autocapitalizationType = .none
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

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter email address"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Phone Number"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter phone number"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .phonePad
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
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(phoneLabel)
        view.addSubview(phoneTextField)
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

            emailLabel.topAnchor.constraint(equalTo: regionTextField.bottomAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            
            phoneLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            phoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            phoneLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            phoneTextField.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 10),
            phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            phoneTextField.heightAnchor.constraint(equalToConstant: 44),
            
            noteLabel.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 20),
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
        let username = trimmedText(from: usernameTextField)
        guard username.isEmpty == false else {
            showAlert(message: "Please enter a username")
            return
        }
        
        let region = trimmedText(from: regionTextField)
        guard region.isEmpty == false else {
            showAlert(message: "Please enter a region")
            return
        }
        
        let email = trimmedText(from: emailTextField)
        guard email.isEmpty == false else {
            showAlert(message: "Please enter an email address")
            return
        }
        guard isValidEmail(email) else {
            showAlert(message: "Please enter a valid email address")
            return
        }
        
        let phoneNumberRaw = trimmedText(from: phoneTextField)
        guard phoneNumberRaw.isEmpty == false else {
            showAlert(message: "Please enter a phone number")
            return
        }
        let digits = digitsOnly(from: phoneNumberRaw)
        guard digits.count == 10 else {
            showAlert(message: "Please enter a 10-digit US phone number")
            return
        }
        let formattedPhone = formatPhoneNumber(from: digits)
        
        let note = trimmedText(from: noteTextField)
        guard note.isEmpty == false else {
            showAlert(message: "Please enter a note")
            return
        }
        
        let newFriend = Friend(username: username, region: region, email: email, note: note, phoneNumber: formattedPhone, nickname: nil)
        DataManager.shared.addFriend(newFriend)
        
        let alert = UIAlertController(title: "Success", message: "Friend added successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
    
    private func trimmedText(from textField: UITextField) -> String {
        textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: email)
    }
    
    private func digitsOnly(from string: String) -> String {
        return string.filter { $0.isNumber }
    }
    
    private func formatPhoneNumber(from digits: String) -> String {
        let area = digits.prefix(3)
        let middle = digits.dropFirst(3).prefix(3)
        let last = digits.suffix(4)
        return "(\(area)) \(middle)-\(last)"
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
