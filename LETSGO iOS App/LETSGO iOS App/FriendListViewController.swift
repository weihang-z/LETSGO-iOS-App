//
//  FriendListViewController.swift
//  LETSGO ios App
//

import UIKit

class FriendListViewController: UIViewController {
    
    // MARK: - UI Elements
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(FriendCell.self, forCellReuseIdentifier: "FriendCell")
        return table
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Friend List"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate & DataSource
extension FriendListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell else {
            return UITableViewCell()
        }
        
        let friend = DataManager.shared.friends[indexPath.row]
        cell.configure(with: friend)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let friend = DataManager.shared.friends[indexPath.row]
        let detailVC = FriendDetailViewController()
        detailVC.friend = friend
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - Custom Cell
class FriendCell: UITableViewCell {
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let regionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(usernameLabel)
        contentView.addSubview(regionLabel)
        contentView.addSubview(noteLabel)
        
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            regionLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5),
            regionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            regionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            noteLabel.topAnchor.constraint(equalTo: regionLabel.bottomAnchor, constant: 5),
            noteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            noteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            noteLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with friend: Friend) {
        usernameLabel.text = friend.username
        regionLabel.text = friend.region
        noteLabel.text = friend.note
    }
}
