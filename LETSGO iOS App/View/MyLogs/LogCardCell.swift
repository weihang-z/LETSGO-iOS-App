//
//  LogCardCell.swift
//  LETSGO iOS App
//
//  Created by Weihang Zeng on 11/15/25.
//

import UIKit

class LogCardCell: UITableViewCell {

    static let identifier = "LogCardCell"
    
    var timelineView: UIView!
    var cardView: UIView!
    var locationLabel: UILabel!
    var titleLabel: UILabel!
    var thumbnailStackView: UIStackView!
    var morePhotosLabel: UILabel!
    var dateLabel: UILabel!
    var privacyIconView: UIImageView!
    var privacyLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
         timelineView = UIView()
         timelineView.backgroundColor = .systemGray3
         timelineView.translatesAutoresizingMaskIntoConstraints = false
        
        cardView = UIView()
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        locationLabel = UILabel()
        locationLabel.font = .systemFont(ofSize: 14, weight: .medium)
        locationLabel.textColor = .systemBlue
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = UIColor(red: 0.12, green: 0.16, blue: 0.22, alpha: 1.0)
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        thumbnailStackView = UIStackView()
        thumbnailStackView.axis = .horizontal
        thumbnailStackView.spacing = 8
        thumbnailStackView.distribution = .fillEqually
        thumbnailStackView.translatesAutoresizingMaskIntoConstraints = false
        
        morePhotosLabel = UILabel()
        morePhotosLabel.font = .systemFont(ofSize: 14, weight: .medium)
        morePhotosLabel.textColor = UIColor(red: 0.42, green: 0.45, blue: 0.50, alpha: 1.0)
        morePhotosLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1.0)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        privacyIconView = UIImageView()
        privacyIconView.image = UIImage(systemName: "lock.fill")
        privacyIconView.tintColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1.0)
        privacyIconView.contentMode = .scaleAspectFit
        privacyIconView.translatesAutoresizingMaskIntoConstraints = false
        
        privacyLabel = UILabel()
        privacyLabel.font = .systemFont(ofSize: 14)
        privacyLabel.textColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1.0)
        privacyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(timelineView)
        contentView.addSubview(cardView)
        
        cardView.addSubview(locationLabel)
        cardView.addSubview(titleLabel)
        cardView.addSubview(thumbnailStackView)
        cardView.addSubview(morePhotosLabel)
        cardView.addSubview(dateLabel)
        cardView.addSubview(privacyIconView)
        cardView.addSubview(privacyLabel)
        
        for _ in 0..<3 {
            let thumbnailView = UIImageView()
            thumbnailView.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 1.0)
            thumbnailView.contentMode = .scaleAspectFill
            thumbnailView.clipsToBounds = true
            thumbnailView.layer.cornerRadius = 6
            thumbnailView.widthAnchor.constraint(equalToConstant: 60).isActive = true
            thumbnailView.heightAnchor.constraint(equalToConstant: 60).isActive = true
            thumbnailStackView.addArrangedSubview(thumbnailView)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            timelineView.centerXAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            timelineView.topAnchor.constraint(equalTo: contentView.topAnchor),
            timelineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            timelineView.widthAnchor.constraint(equalToConstant: 2),
            
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 48),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            locationLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            locationLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            locationLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            
            titleLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            
            thumbnailStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            thumbnailStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            thumbnailStackView.heightAnchor.constraint(equalToConstant: 60),
            
            morePhotosLabel.leadingAnchor.constraint(equalTo: thumbnailStackView.trailingAnchor, constant: 8),
            morePhotosLabel.centerYAnchor.constraint(equalTo: thumbnailStackView.centerYAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: thumbnailStackView.bottomAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            
            privacyIconView.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 12),
            privacyIconView.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            privacyIconView.widthAnchor.constraint(equalToConstant: 14),
            privacyIconView.heightAnchor.constraint(equalToConstant: 14),
            
            privacyLabel.leadingAnchor.constraint(equalTo: privacyIconView.trailingAnchor, constant: 4),
            privacyLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            privacyLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
        ])
    }

    func configure(with entry: TravelLogEntry, formatter: DateFormatter) {
        locationLabel.text = entry.location
        titleLabel.text = entry.title
        dateLabel.text = "\(formatter.string(from: entry.startDate)) - \(formatter.string(from: entry.endDate))"
        privacyIconView.image = UIImage(systemName: entry.isPrivate ? "lock.fill" : "globe")
        privacyLabel.text = entry.isPrivate ? "Private" : "Public"
        morePhotosLabel.text = entry.photoCount > 0 ? "+\(entry.photoCount)" : ""
    }

}
