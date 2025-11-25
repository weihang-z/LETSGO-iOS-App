//
//  CreateEditLogView.swift
//  LETSGO iOS App
//
//  Created by Weihang Zeng on 11/17/25.
//

import UIKit

class CreateEditLogView: UIView {
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    var coverPhotoContainer: UIView!
    var coverPhotoImageView: UIImageView!
    var addCoverPhotoButton: UIButton!
    var removeCoverPhotoButton: UIButton!
    
    var titleLabel: UILabel!
    var titleTextField: UITextField!
    
    var locationLabel: UILabel!
    var locationTextField: UITextField!
    
    var dateLabel: UILabel!
    var datePicker: UIDatePicker!
    
    var privacyLabel: UILabel!
    var privacySegmentedControl: UISegmentedControl!
    
    var contentLabel: UILabel!
    var contentTextView: UITextView!
    
    var tagsLabel: UILabel!
    var tagsTextField: UITextField!
    var tagsHintLabel: UILabel!
    
    var photosLabel: UILabel!
    var photosCollectionView: UICollectionView!
    var addPhotoButton: UIButton!
    var photosCollectionHeightConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        setupScrollView()
        setupContentView()
        setupCoverPhotoSection()
        setupTitleSection()
        setupLocationSection()
        setupDateSection()
        setupPrivacySection()
        setupContentSection()
        setupTagsSection()
        setupPhotosSection()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
    }
    
    func setupContentView() {
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
    }
    
    func setupCoverPhotoSection() {
        coverPhotoContainer = UIView()
        coverPhotoContainer.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1.0)
        coverPhotoContainer.layer.cornerRadius = 12
        coverPhotoContainer.layer.borderWidth = 2
        coverPhotoContainer.layer.borderColor = UIColor(red: 0.85, green: 0.87, blue: 0.89, alpha: 1.0).cgColor
        coverPhotoContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(coverPhotoContainer)
        
        coverPhotoImageView = UIImageView()
        coverPhotoImageView.contentMode = .scaleAspectFill
        coverPhotoImageView.clipsToBounds = true
        coverPhotoImageView.layer.cornerRadius = 10
        coverPhotoImageView.isHidden = true
        coverPhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        coverPhotoContainer.addSubview(coverPhotoImageView)
        
        var addConfig = UIButton.Configuration.plain()
        addConfig.image = UIImage(systemName: "camera.fill")
        addConfig.title = "Add Cover Photo"
        addConfig.imagePadding = 8
        addConfig.imagePlacement = .top
        addConfig.baseForegroundColor = .systemBlue
        addCoverPhotoButton = UIButton(configuration: addConfig)
        addCoverPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        coverPhotoContainer.addSubview(addCoverPhotoButton)
        
        removeCoverPhotoButton = UIButton(type: .system)
        removeCoverPhotoButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        removeCoverPhotoButton.tintColor = .white
        removeCoverPhotoButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        removeCoverPhotoButton.layer.cornerRadius = 14
        removeCoverPhotoButton.isHidden = true
        removeCoverPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        coverPhotoContainer.addSubview(removeCoverPhotoButton)
    }
    
    func setupTitleSection() {
        titleLabel = createSectionLabel(text: "Title")
        contentView.addSubview(titleLabel)
        
        titleTextField = createTextField(placeholder: "Enter a title for your travel log")
        contentView.addSubview(titleTextField)
    }
    
    func setupLocationSection() {
        locationLabel = createSectionLabel(text: "Location")
        contentView.addSubview(locationLabel)
        
        locationTextField = createTextField(placeholder: "Where did you go?")
        locationTextField.leftViewMode = .always
        contentView.addSubview(locationTextField)
    }
    
    func setupDateSection() {
        dateLabel = createSectionLabel(text: "Date")
        contentView.addSubview(dateLabel)
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.maximumDate = Date()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(datePicker)
    }
    
    func setupPrivacySection() {
        privacyLabel = createSectionLabel(text: "Privacy")
        contentView.addSubview(privacyLabel)
        
        privacySegmentedControl = UISegmentedControl(items: ["Public", "Private"])
        privacySegmentedControl.selectedSegmentIndex = 0
        privacySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(privacySegmentedControl)
    }
    
    func setupContentSection() {
        contentLabel = createSectionLabel(text: "Description")
        contentView.addSubview(contentLabel)
        
        contentTextView = UITextView()
        contentTextView.font = .systemFont(ofSize: 16)
        contentTextView.textColor = UIColor(red: 0.12, green: 0.16, blue: 0.22, alpha: 1.0)
        contentTextView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1.0)
        contentTextView.layer.cornerRadius = 10
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 1.0).cgColor
        contentTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentTextView)
    }
    
    func setupTagsSection() {
        tagsLabel = createSectionLabel(text: "Tags")
        contentView.addSubview(tagsLabel)
        
        tagsTextField = createTextField(placeholder: "adventure, beach, hiking")
        tagsTextField.leftView = createTextFieldIcon(systemName: "tag")
        tagsTextField.leftViewMode = .always
        contentView.addSubview(tagsTextField)
        
        tagsHintLabel = UILabel()
        tagsHintLabel.text = "Separate tags with commas"
        tagsHintLabel.font = .systemFont(ofSize: 13)
        tagsHintLabel.textColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1.0)
        tagsHintLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tagsHintLabel)
    }
    
    func setupPhotosSection() {
        photosLabel = createSectionLabel(text: "Photos")
        contentView.addSubview(photosLabel)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: 100, height: 100)
        
        photosCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        photosCollectionView.backgroundColor = .clear
        photosCollectionView.showsHorizontalScrollIndicator = false
        photosCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(photosCollectionView)
        
        var addPhotoConfig = UIButton.Configuration.tinted()
        addPhotoConfig.title = "Add Photos"
        addPhotoConfig.image = UIImage(systemName: "photo.on.rectangle.angled")
        addPhotoConfig.imagePadding = 8
        addPhotoConfig.baseBackgroundColor = .systemBlue
        addPhotoConfig.baseForegroundColor = .systemBlue
        addPhotoConfig.cornerStyle = .medium
        addPhotoButton = UIButton(configuration: addPhotoConfig)
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addPhotoButton)
    }
    
    func createSectionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = UIColor(red: 0.42, green: 0.45, blue: 0.50, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.font = .systemFont(ofSize: 16)
        textField.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1.0)
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 1.0).cgColor
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 44))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 44))
        textField.rightView = rightPaddingView
        textField.rightViewMode = .always
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    func createTextFieldIcon(systemName: String) -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        let iconView = UIImageView(image: UIImage(systemName: systemName))
        iconView.tintColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1.0)
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(x: 12, y: 12, width: 20, height: 20)
        containerView.addSubview(iconView)
        return containerView
    }
    
    func initConstraints() {
        photosCollectionHeightConstraint = photosCollectionView.heightAnchor.constraint(equalToConstant: 100)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            coverPhotoContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            coverPhotoContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            coverPhotoContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            coverPhotoContainer.heightAnchor.constraint(equalToConstant: 180),
            
            coverPhotoImageView.topAnchor.constraint(equalTo: coverPhotoContainer.topAnchor, constant: 4),
            coverPhotoImageView.leadingAnchor.constraint(equalTo: coverPhotoContainer.leadingAnchor, constant: 4),
            coverPhotoImageView.trailingAnchor.constraint(equalTo: coverPhotoContainer.trailingAnchor, constant: -4),
            coverPhotoImageView.bottomAnchor.constraint(equalTo: coverPhotoContainer.bottomAnchor, constant: -4),
            
            addCoverPhotoButton.centerXAnchor.constraint(equalTo: coverPhotoContainer.centerXAnchor),
            addCoverPhotoButton.centerYAnchor.constraint(equalTo: coverPhotoContainer.centerYAnchor),
            
            removeCoverPhotoButton.topAnchor.constraint(equalTo: coverPhotoContainer.topAnchor, constant: 12),
            removeCoverPhotoButton.trailingAnchor.constraint(equalTo: coverPhotoContainer.trailingAnchor, constant: -12),
            removeCoverPhotoButton.widthAnchor.constraint(equalToConstant: 28),
            removeCoverPhotoButton.heightAnchor.constraint(equalToConstant: 28),
            
            titleLabel.topAnchor.constraint(equalTo: coverPhotoContainer.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 48),
            
            locationLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            locationTextField.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            locationTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            locationTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            locationTextField.heightAnchor.constraint(equalToConstant: 48),
            
            dateLabel.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            datePicker.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            privacyLabel.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            privacyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            privacySegmentedControl.topAnchor.constraint(equalTo: privacyLabel.bottomAnchor, constant: 8),
            privacySegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            privacySegmentedControl.widthAnchor.constraint(equalToConstant: 200),
            
            contentLabel.topAnchor.constraint(equalTo: privacySegmentedControl.bottomAnchor, constant: 20),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            contentTextView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
            contentTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentTextView.heightAnchor.constraint(equalToConstant: 150),
            
            tagsLabel.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 20),
            tagsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            tagsTextField.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 8),
            tagsTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tagsTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tagsTextField.heightAnchor.constraint(equalToConstant: 48),
            
            tagsHintLabel.topAnchor.constraint(equalTo: tagsTextField.bottomAnchor, constant: 4),
            tagsHintLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            photosLabel.topAnchor.constraint(equalTo: tagsHintLabel.bottomAnchor, constant: 20),
            photosLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            addPhotoButton.centerYAnchor.constraint(equalTo: photosLabel.centerYAnchor),
            addPhotoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            photosCollectionView.topAnchor.constraint(equalTo: photosLabel.bottomAnchor, constant: 12),
            photosCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            photosCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            photosCollectionHeightConstraint,
            photosCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
        ])
    }
    
    func setCoverPhoto(_ image: UIImage?) {
        if let image = image {
            coverPhotoImageView.image = image
            coverPhotoImageView.isHidden = false
            addCoverPhotoButton.isHidden = true
            removeCoverPhotoButton.isHidden = false
        } else {
            coverPhotoImageView.image = nil
            coverPhotoImageView.isHidden = true
            addCoverPhotoButton.isHidden = false
            removeCoverPhotoButton.isHidden = true
        }
    }
    
    func configure(title: String?, location: String?, date: Date?, isPrivate: Bool, content: String?, tags: [String]?) {
        titleTextField.text = title
        locationTextField.text = location
        
        if let date = date {
            datePicker.date = date
        }
        
        privacySegmentedControl.selectedSegmentIndex = isPrivate ? 1 : 0
        contentTextView.text = content
        
        if let tags = tags, !tags.isEmpty {
            tagsTextField.text = tags.joined(separator: ", ")
        }
    }
}
