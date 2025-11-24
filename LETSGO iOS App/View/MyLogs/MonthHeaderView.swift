//
//  MonthHeaderView.swift
//  LETSGO iOS App
//
//  Created by Weihang Zeng on 11/17/25.
//

import UIKit

import UIKit

class MonthHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "MonthHeaderView"
    
    var monthLabel: UILabel!
    var leftLine: UIView!
    var rightLine: UIView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        
        monthLabel = UILabel()
        monthLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        monthLabel.textColor = UIColor(red: 0.42, green: 0.45, blue: 0.50, alpha: 1.0)
        monthLabel.textAlignment = .center
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        
        leftLine = UIView()
        leftLine.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 1.0)
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        
        rightLine = UIView()
        rightLine.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 1.0)
        rightLine.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(leftLine)
        contentView.addSubview(monthLabel)
        contentView.addSubview(rightLine)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            monthLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            monthLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            leftLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 48),
            leftLine.trailingAnchor.constraint(equalTo: monthLabel.leadingAnchor, constant: -12),
            leftLine.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            leftLine.heightAnchor.constraint(equalToConstant: 1),
            
            rightLine.leadingAnchor.constraint(equalTo: monthLabel.trailingAnchor, constant: 12),
            rightLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rightLine.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightLine.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
}
