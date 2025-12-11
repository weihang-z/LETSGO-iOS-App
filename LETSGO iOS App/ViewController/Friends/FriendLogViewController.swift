//
//  FriendLogViewController.swift
//  LETSGO ios App
//

import UIKit

class FriendLogViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(FriendLogCell.self, forCellReuseIdentifier: "FriendLogCell")
        return table
    }()
    
    private let addFriendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Friend", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let refreshControl = UIRefreshControl()
    private let firebaseService = FirebaseService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupDataManagerCallback()
        fetchFriendLogs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupUI() {
        title = "Friend's Log"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "My Friends",
            style: .plain,
            target: self,
            action: #selector(showFriendList)
        )
        
        view.addSubview(addFriendButton)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        addFriendButton.addTarget(self, action: #selector(addFriendButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            addFriendButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            addFriendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addFriendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addFriendButton.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: addFriendButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupDataManagerCallback() {
        DataManager.shared.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func fetchFriendLogs() {
        activityIndicator.startAnimating()
        
        DataManager.shared.fetchFriends { [weak self] _ in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc private func handleRefresh() {
        DataManager.shared.fetchFriendsTravelLogs { [weak self] _ in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc private func addFriendButtonTapped() {
        let addFriendVC = AddFriendViewController()
        navigationController?.pushViewController(addFriendVC, animated: true)
    }
    
    @objc private func showFriendList() {
        let friendListVC = FriendListViewController()
        navigationController?.pushViewController(friendListVC, animated: true)
    }
}

extension FriendLogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.friendTravelLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendLogCell", for: indexPath) as? FriendLogCell else {
            return UITableViewCell()
        }
        
        let log = DataManager.shared.friendTravelLogs[indexPath.row]
        cell.configure(with: log)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let log = DataManager.shared.friendTravelLogs[indexPath.row]
        
        activityIndicator.startAnimating()
        loadEntry(for: log) { [weak self] entry in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                guard let entry = entry else { return }
                let detailVC = LogDetailViewController(entry: entry, allowEditing: false)
                self?.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
}

class FriendLogCell: UITableViewCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = .systemGray2
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
        contentView.addSubview(nameLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(activityLabel)
        contentView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            activityLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 5),
            activityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            activityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            timeLabel.topAnchor.constraint(equalTo: activityLabel.bottomAnchor, constant: 5),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            timeLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with log: FriendTravelLog) {
        nameLabel.text = "📍 \(log.authorName)"
        locationLabel.text = log.city
        activityLabel.text = log.title
        timeLabel.text = log.timeAgo
    }
}

private extension FriendLogViewController {
    func loadEntry(for log: FriendTravelLog, completion: @escaping (TravelLogEntry?) -> Void) {
        let group = DispatchGroup()
        var coverImage: UIImage?
        var photos: [UIImage] = []
        
        if let coverURL = log.coverImageURL {
            group.enter()
            firebaseService.downloadImage(from: coverURL) { image in
                coverImage = image
                group.leave()
            }
        }
        
        for url in log.photoURLs {
            group.enter()
            firebaseService.downloadImage(from: url) { image in
                if let image = image {
                    photos.append(image)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard self != nil else { completion(nil); return }
            let entry = TravelLogEntry(
                id: UUID(uuidString: log.id) ?? UUID(),
                title: log.title,
                location: log.location,
                city: log.city,
                startDate: log.startDate,
                endDate: log.endDate,
                summary: log.summary,
                isPrivate: false,
                tags: log.tags,
                coverImage: coverImage ?? photos.first,
                photos: photos,
                coverImageURL: log.coverImageURL,
                photoURLs: log.photoURLs
            )
            completion(entry)
        }
    }
}
