//
//  AddFriendViewController.swift
//  LETSGO ios App
//

import UIKit

class AddFriendViewController: UIViewController {
    
    private let searchHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Search for users by username or email"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter username or email"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .search
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let searchResultsTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "SearchResultCell")
        table.layer.cornerRadius = 12
        table.layer.borderWidth = 1
        table.layer.borderColor = UIColor.systemGray4.cgColor
        return table
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Search for friends to add them"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private var searchResults: [AppUser] = [] {
        didSet {
            searchResultsTableView.reloadData()
            updateEmptyState()
        }
    }
    
    private var hasSearched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        title = "Add Friend"
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchHeaderLabel)
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        view.addSubview(searchResultsTableView)
        view.addSubview(emptyStateLabel)
        view.addSubview(activityIndicator)
        
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        searchTextField.delegate = self
        
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        updateEmptyState()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchHeaderLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            searchHeaderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchHeaderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            searchTextField.topAnchor.constraint(equalTo: searchHeaderLabel.bottomAnchor, constant: 24),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            
            searchButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            
            searchResultsTableView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 24),
            searchResultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchResultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchResultsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: searchResultsTableView.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: searchResultsTableView.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: searchResultsTableView.leadingAnchor, constant: 20),
            emptyStateLabel.trailingAnchor.constraint(equalTo: searchResultsTableView.trailingAnchor, constant: -20),
            
            activityIndicator.centerXAnchor.constraint(equalTo: searchButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: searchButton.centerYAnchor)
        ])
    }
    
    private func updateEmptyState() {
        if searchResults.isEmpty {
            emptyStateLabel.isHidden = false
            if hasSearched {
                emptyStateLabel.text = "No users found\nTry searching with a different username or email"
            } else {
                emptyStateLabel.text = "Search for friends to add them"
            }
        } else {
            emptyStateLabel.isHidden = true
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func textFieldDidChange() {
        let hasText = !(searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        searchButton.isEnabled = hasText
        searchButton.alpha = hasText ? 1.0 : 0.6
    }
    
    @objc private func searchButtonTapped() {
        performSearch()
    }
    
    private func performSearch() {
        guard let query = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !query.isEmpty else {
            showAlert(message: "Please enter a username or email to search")
            return
        }
        
        view.endEditing(true)
        activityIndicator.startAnimating()
        searchButton.isEnabled = false
        hasSearched = true
        
        FirebaseService.shared.searchUsersByUsernameOrEmail(query: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.searchButton.isEnabled = true
                
                switch result {
                case .success(let users):
                    self?.searchResults = users.filter { $0.uid != FirebaseService.shared.currentUserId }
                    
                case .failure(let error):
                    self?.searchResults = []
                    self?.showAlert(message: "Search failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func addFriendFromSearch(_ user: AppUser) {
        guard let currentUserId = FirebaseService.shared.currentUserId else {
            showAlert(message: "Please sign in to add friends")
            return
        }
        
        activityIndicator.startAnimating()
        
        FirebaseService.shared.addFriend(currentUserId: currentUserId, friendId: user.uid) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                
                switch result {
                case .success:
                    let alert = UIAlertController(
                        title: "Success",
                        message: "\(user.username) added as a friend!",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                        self?.navigationController?.popViewController(animated: true)
                    })
                    self?.present(alert, animated: true)
                    
                case .failure(let error):
                    self?.showAlert(message: "Failed to add friend: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension AddFriendViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSearch()
        return true
    }
}

extension AddFriendViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        let user = searchResults[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = user.username
        config.secondaryText = user.email
        
        config.textProperties.numberOfLines = 1
        config.textProperties.font = .systemFont(ofSize: 16, weight: .medium)
        config.secondaryTextProperties.numberOfLines = 0
        config.secondaryTextProperties.font = .systemFont(ofSize: 14)
        config.secondaryTextProperties.color = .secondaryLabel
        
        config.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        
        if let avatarURL = user.avatarURL, !avatarURL.isEmpty {
            config.image = UIImage(systemName: "person.circle.fill")
            config.imageProperties.tintColor = .systemBlue
            config.imageProperties.maximumSize = CGSize(width: 40, height: 40)
            
            FirebaseService.shared.downloadImage(from: avatarURL) { image in
                if let image = image {
                    DispatchQueue.main.async {
                        if let currentCell = tableView.cellForRow(at: indexPath) {
                            var updatedConfig = currentCell.contentConfiguration as? UIListContentConfiguration ?? config
                            updatedConfig.image = image
                            updatedConfig.imageProperties.cornerRadius = 20
                            currentCell.contentConfiguration = updatedConfig
                        }
                    }
                }
            }
        } else {
            config.image = UIImage(systemName: "person.circle.fill")
            config.imageProperties.tintColor = .systemBlue
            config.imageProperties.maximumSize = CGSize(width: 40, height: 40)
        }
        
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = searchResults[indexPath.row]
        
        let alert = UIAlertController(
            title: "Add Friend",
            message: "Add \(user.username) as a friend?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            self?.addFriendFromSearch(user)
        })
        
        present(alert, animated: true)
    }
}
