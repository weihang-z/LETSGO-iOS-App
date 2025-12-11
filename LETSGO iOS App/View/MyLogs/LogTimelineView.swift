//
//  LogTimelineView.swift
//  LETSGO iOS App
//
//  Created by Weihang Zeng on 11/15/25.
//

import UIKit

class LogTimelineView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var titleLabel: UILabel!
    var searchButton: UIButton!
    var newLogButton: UIButton!
    var filterContainerView: UIView!
    var yearFilterButton: UIButton!
    var locationFilterButton: UIButton!
    var filterDivider: UIView!
    var tableView: UITableView!
    var emptyStateView: UIView!
    var emptyStateImageView: UIImageView!
    var emptyStateLabel: UILabel!
    var emptyStateSubLabel: UILabel!
    var loadingIndicator: UIActivityIndicatorView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        
        titleLabel = UILabel()
        titleLabel.text = "My Logs"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.12, green: 0.16, blue: 0.22, alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        searchButton = UIButton(type: .system)
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = UIColor(red: 0.42, green: 0.45, blue: 0.50, alpha: 1.0)
        searchButton.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1.0)
        searchButton.layer.cornerRadius = 18
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        newLogButton = UIButton(type: .system)
        newLogButton.setTitle("+ New Travel Log", for: .normal)
        newLogButton.backgroundColor = UIColor(red: 0.20, green: 0.78, blue: 0.35, alpha: 1.0)
        newLogButton.setTitleColor(.white, for: .normal)
        newLogButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        newLogButton.layer.cornerRadius = 12
        newLogButton.layer.shadowColor = UIColor(red: 0.20, green: 0.78, blue: 0.35, alpha: 1.0).cgColor
        newLogButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        newLogButton.layer.shadowRadius = 8
        newLogButton.layer.shadowOpacity = 0.3
        newLogButton.translatesAutoresizingMaskIntoConstraints = false
        
        filterContainerView = UIView()
        filterContainerView.backgroundColor = .white
        filterContainerView.layer.cornerRadius = 8
        filterContainerView.layer.borderWidth = 1
        filterContainerView.layer.borderColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 1.0).cgColor
        filterContainerView.translatesAutoresizingMaskIntoConstraints = false
        filterContainerView.isHidden = true // Hide filter controls
        
        yearFilterButton = UIButton(type: .system)
        yearFilterButton.setTitle("2024 ▼", for: .normal)
        yearFilterButton.setTitleColor(.darkGray, for: .normal)
        yearFilterButton.titleLabel?.font = .systemFont(ofSize: 16)
        yearFilterButton.translatesAutoresizingMaskIntoConstraints = false
        
        locationFilterButton = UIButton(type: .system)
        locationFilterButton.setTitle("All Places ▼", for: .normal)
        locationFilterButton.setTitleColor(.darkGray, for: .normal)
        locationFilterButton.titleLabel?.font = .systemFont(ofSize: 16)
        locationFilterButton.translatesAutoresizingMaskIntoConstraints = false
        
        filterDivider = UIView()
        filterDivider.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 1.0)
        filterDivider.translatesAutoresizingMaskIntoConstraints = false
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        tableView.clipsToBounds = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        emptyStateView = UIView()
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.isHidden = true
        
        emptyStateImageView = UIImageView()
        emptyStateImageView.image = UIImage(systemName: "map.fill")
        emptyStateImageView.tintColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1.0)
        emptyStateImageView.contentMode = .scaleAspectFit
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
        
        emptyStateLabel = UILabel()
        emptyStateLabel.text = "No travel logs yet"
        emptyStateLabel.font = .systemFont(ofSize: 18, weight: .medium)
        emptyStateLabel.textColor = UIColor(red: 0.42, green: 0.45, blue: 0.50, alpha: 1.0)
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emptyStateSubLabel = UILabel()
        emptyStateSubLabel.text = "Start documenting your adventures"
        emptyStateSubLabel.font = .systemFont(ofSize: 14)
        emptyStateSubLabel.textColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1.0)
        emptyStateSubLabel.textAlignment = .center
        emptyStateSubLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(searchButton)
        addSubview(newLogButton)
        addSubview(filterContainerView)
        filterContainerView.addSubview(yearFilterButton)
        filterContainerView.addSubview(filterDivider)
        filterContainerView.addSubview(locationFilterButton)
        addSubview(tableView)
        addSubview(loadingIndicator)
        
        addSubview(emptyStateView)
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
        emptyStateView.addSubview(emptyStateSubLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            searchButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            searchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            searchButton.widthAnchor.constraint(equalToConstant: 36),
            searchButton.heightAnchor.constraint(equalToConstant: 36),
            
            newLogButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            newLogButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            newLogButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            newLogButton.heightAnchor.constraint(equalToConstant: 44),
            
            filterContainerView.topAnchor.constraint(equalTo: newLogButton.bottomAnchor, constant: 10),
            filterContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            filterContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            filterContainerView.heightAnchor.constraint(equalToConstant: 44),
            
            yearFilterButton.leadingAnchor.constraint(equalTo: filterContainerView.leadingAnchor, constant: 12),
            yearFilterButton.centerYAnchor.constraint(equalTo: filterContainerView.centerYAnchor),
            yearFilterButton.widthAnchor.constraint(equalTo: filterContainerView.widthAnchor, multiplier: 0.45),
            
            filterDivider.centerXAnchor.constraint(equalTo: filterContainerView.centerXAnchor),
            filterDivider.centerYAnchor.constraint(equalTo: filterContainerView.centerYAnchor),
            filterDivider.widthAnchor.constraint(equalToConstant: 1),
            filterDivider.heightAnchor.constraint(equalToConstant: 24),
            
            locationFilterButton.trailingAnchor.constraint(equalTo: filterContainerView.trailingAnchor, constant: -12),
            locationFilterButton.centerYAnchor.constraint(equalTo: filterContainerView.centerYAnchor),
            locationFilterButton.widthAnchor.constraint(equalTo: filterContainerView.widthAnchor, multiplier: 0.45),
            
            tableView.topAnchor.constraint(equalTo: newLogButton.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            emptyStateView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50),
            emptyStateView.widthAnchor.constraint(equalTo: widthAnchor, constant: -64),
            
            emptyStateImageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            emptyStateImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 80),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 16),
            emptyStateLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            
            emptyStateSubLabel.topAnchor.constraint(equalTo: emptyStateLabel.bottomAnchor, constant: 8),
            emptyStateSubLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateSubLabel.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor),
        ])
    }
}
