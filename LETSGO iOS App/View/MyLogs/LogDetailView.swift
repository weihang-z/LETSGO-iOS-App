//
//  LogDetailView.swift
//  LETSGO iOS App
//
//  Created by Weihang Zeng on 11/17/25.
//

import UIKit

class LogDetailView: UIView {
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    var coverImageView: UIImageView!
    var locationLabel: UILabel!
    var dateLabel: UILabel!
    var privacyIconView: UIImageView!
    var privacyLabel: UILabel!
    var divider1: UIView!
    var titleLabel: UILabel!
    var contentTextView: UITextView!
    var divider2: UIView!
    var photosHeaderLabel: UILabel!
    var photoCollectionView: UICollectionView!
    var divider3: UIView!
    var tagsLabel: UILabel!
    var actionButtonsContainer: UIView!
    var editButton: UIButton!
    var deleteButton: UIButton!
    var photoCollectionHeightConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupScrollView()
        setupContentView()
        setupCoverImageView()
        setupLocationLabel()
        setupDateLabel()
        setupPrivacyViews()
        setupDivider1()
        setupTitleLabel()
        setupContentTextView()
        setupDivider2()
        setupPhotosSection()
        setupDivider3()
        setupTagsLabel()
        setupActionButtonsContainer()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
    }
    
    func setupContentView() {
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
    }
    
    func setupCoverImageView() {
        coverImageView = UIImageView()
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        coverImageView.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 1.0)
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(coverImageView)
    }
    
    func setupLocationLabel() {
        locationLabel = UILabel()
        locationLabel.font = .systemFont(ofSize: 16, weight: .medium)
        locationLabel.textColor = .systemBlue
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(locationLabel)
    }
    
    func setupDateLabel() {
        dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 15)
        dateLabel.textColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1.0)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateLabel)
    }
    
    func setupPrivacyViews() {
        privacyIconView = UIImageView()
        privacyIconView.image = UIImage(systemName: "lock.fill")
        privacyIconView.tintColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1.0)
        privacyIconView.contentMode = .scaleAspectFit
        privacyIconView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(privacyIconView)
        
        privacyLabel = UILabel()
        privacyLabel.font = .systemFont(ofSize: 15)
        privacyLabel.textColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1.0)
        privacyLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(privacyLabel)
    }
    
    func setupDivider1() {
        divider1 = UIView()
        divider1.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 1.0)
        divider1.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(divider1)
    }
    
    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        titleLabel.textColor = UIColor(red: 0.12, green: 0.16, blue: 0.22, alpha: 1.0)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
    }
    
    func setupContentTextView() {
        contentTextView = UITextView()
        contentTextView.font = .systemFont(ofSize: 16)
        contentTextView.textColor = UIColor(red: 0.12, green: 0.16, blue: 0.22, alpha: 1.0)
        contentTextView.isEditable = false
        contentTextView.isScrollEnabled = false
        contentTextView.textContainer.lineFragmentPadding = 0
        contentTextView.textContainerInset = .zero
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentTextView)
    }
    
    func setupDivider2() {
        divider2 = UIView()
        divider2.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 1.0)
        divider2.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(divider2)
    }
    
    func setupPhotosSection() {
        photosHeaderLabel = UILabel()
        photosHeaderLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        photosHeaderLabel.textColor = UIColor(red: 0.12, green: 0.16, blue: 0.22, alpha: 1.0)
        photosHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(photosHeaderLabel)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        photoCollectionView.backgroundColor = .clear
        photoCollectionView.isScrollEnabled = false
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(photoCollectionView)
    }
    
    func setupDivider3() {
        divider3 = UIView()
        divider3.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 1.0)
        divider3.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(divider3)
    }
    
    func setupTagsLabel() {
        tagsLabel = UILabel()
        tagsLabel.font = .systemFont(ofSize: 15)
        tagsLabel.textColor = UIColor(red: 0.96, green: 0.62, blue: 0.04, alpha: 1.0)
        tagsLabel.numberOfLines = 0
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tagsLabel)
    }
    
    func setupActionButtonsContainer() {
        actionButtonsContainer = UIView()
        actionButtonsContainer.backgroundColor = .white
        actionButtonsContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(actionButtonsContainer)
        
        editButton = UIButton(type: .system)
        var editConfig = UIButton.Configuration.filled()
        editConfig.title = "Edit"
        editConfig.image = UIImage(systemName: "pencil")
        editConfig.imagePadding = 6
        editConfig.baseBackgroundColor = .systemBlue
        editConfig.baseForegroundColor = .white
        editConfig.cornerStyle = .medium
        editButton.configuration = editConfig
        editButton.translatesAutoresizingMaskIntoConstraints = false
        actionButtonsContainer.addSubview(editButton)
        
        deleteButton = UIButton(type: .system)
        var deleteConfig = UIButton.Configuration.tinted()
        deleteConfig.title = "Delete"
        deleteConfig.image = UIImage(systemName: "trash")
        deleteConfig.imagePadding = 6
        deleteConfig.baseBackgroundColor = .systemRed
        deleteConfig.baseForegroundColor = .systemRed
        deleteConfig.cornerStyle = .medium
        deleteButton.configuration = deleteConfig
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        actionButtonsContainer.addSubview(deleteButton)
    }
    
    func setupConstraints() {
        photoCollectionHeightConstraint = photoCollectionView.heightAnchor.constraint(equalToConstant: 300)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: actionButtonsContainer.topAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: 180),
            
            locationLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 16),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            dateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            privacyIconView.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 12),
            privacyIconView.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            privacyIconView.widthAnchor.constraint(equalToConstant: 14),
            privacyIconView.heightAnchor.constraint(equalToConstant: 14),
            
            privacyLabel.leadingAnchor.constraint(equalTo: privacyIconView.trailingAnchor, constant: 4),
            privacyLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            
            divider1.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            divider1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            divider1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            divider1.heightAnchor.constraint(equalToConstant: 1),
            
            titleLabel.topAnchor.constraint(equalTo: divider1.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            contentTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            contentTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            divider2.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 16),
            divider2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            divider2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            divider2.heightAnchor.constraint(equalToConstant: 1),
            
            photosHeaderLabel.topAnchor.constraint(equalTo: divider2.bottomAnchor, constant: 16),
            photosHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            photoCollectionView.topAnchor.constraint(equalTo: photosHeaderLabel.bottomAnchor, constant: 12),
            photoCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            photoCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            photoCollectionHeightConstraint,
            
            divider3.topAnchor.constraint(equalTo: photoCollectionView.bottomAnchor, constant: 16),
            divider3.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            divider3.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            divider3.heightAnchor.constraint(equalToConstant: 1),
            
            tagsLabel.topAnchor.constraint(equalTo: divider3.bottomAnchor, constant: 16),
            tagsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tagsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tagsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            actionButtonsContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            actionButtonsContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            actionButtonsContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            actionButtonsContainer.heightAnchor.constraint(equalToConstant: 70),
            
            editButton.leadingAnchor.constraint(equalTo: actionButtonsContainer.leadingAnchor, constant: 16),
            editButton.centerYAnchor.constraint(equalTo: actionButtonsContainer.centerYAnchor),
            editButton.widthAnchor.constraint(equalTo: actionButtonsContainer.widthAnchor, multiplier: 0.44),
            editButton.heightAnchor.constraint(equalToConstant: 44),
            
            deleteButton.trailingAnchor.constraint(equalTo: actionButtonsContainer.trailingAnchor, constant: -16),
            deleteButton.centerYAnchor.constraint(equalTo: actionButtonsContainer.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalTo: actionButtonsContainer.widthAnchor, multiplier: 0.44),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    func configure(location: String, date: String, title: String, content: String, isPrivate: Bool, tags: [String], photoCount: Int) {
        locationLabel.text = location
        dateLabel.text = date
        titleLabel.text = title
        contentTextView.text = content
        
        if isPrivate {
            privacyIconView.image = UIImage(systemName: "lock.fill")
            privacyLabel.text = "Private"
        } else {
            privacyIconView.image = UIImage(systemName: "globe")
            privacyLabel.text = "Public"
        }
        
        if tags.isEmpty {
            tagsLabel.text = ""
        } else {
            tagsLabel.text = tags.map { "#\($0)" }.joined(separator: " ")
        }
        
        photosHeaderLabel.text = "Photos (\(photoCount))"
    }
}
