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
        
        searchButton = UIButton(type: .system)
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        newLogButton = UIButton(type: .system)
        newLogButton.setTitle("+ New Travel Log", for: .normal)
        newLogButton.backgroundColor = .systemGreen
        newLogButton.setTitleColor(.white, for: .normal)
        newLogButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        newLogButton.layer.cornerRadius = 12
        newLogButton.translatesAutoresizingMaskIntoConstraints = false
        
        filterContainerView = UIView()
        filterContainerView.backgroundColor = .white
        filterContainerView.layer.cornerRadius = 8
        filterContainerView.layer.borderWidth = 1
        filterContainerView.layer.borderColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 1.0).cgColor
        filterContainerView.translatesAutoresizingMaskIntoConstraints = false
        
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        addSubview(newLogButton)
        addSubview(filterContainerView)
        filterContainerView.addSubview(yearFilterButton)
        filterContainerView.addSubview(filterDivider)
        filterContainerView.addSubview(locationFilterButton)
        addSubview(tableView)
        
        addSubview(emptyStateView)
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
        emptyStateView.addSubview(emptyStateSubLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            newLogButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            newLogButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            newLogButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            newLogButton.heightAnchor.constraint(equalToConstant: 48),
            
            filterContainerView.topAnchor.constraint(equalTo: newLogButton.bottomAnchor, constant: 16),
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
            
            tableView.topAnchor.constraint(equalTo: filterContainerView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
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
