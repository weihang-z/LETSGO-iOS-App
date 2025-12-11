//
//  LogDetailViewController.swift
//  LETSGO iOS App
//
//  Created by Weihang Zeng on 11/17/25.
//

import UIKit

class LogDetailViewController: UIViewController {
    
    var detailView: LogDetailView!
    
    private var entry: TravelLogEntry
    private let allowEditing: Bool
    
    var onUpdate: ((TravelLogEntry) -> Void)?
    var onDelete: ((TravelLogEntry) -> Void)?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    init(entry: TravelLogEntry, allowEditing: Bool = true) {
        self.entry = entry
        self.allowEditing = allowEditing
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        detailView = LogDetailView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log Detail"
        
        setupNavigationBar()
        setupCollectionView()
        setupActions()
        configureView()
        updateEditingVisibility()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(shareTapped)
        )
    }
    
    private func setupCollectionView() {
        detailView.photoCollectionView.delegate = self
        detailView.photoCollectionView.dataSource = self
        detailView.photoCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
    }
    
    private func setupActions() {
        detailView.editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        detailView.deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }
    
    private func updateEditingVisibility() {
        detailView.editButton.isHidden = !allowEditing
        detailView.deleteButton.isHidden = !allowEditing
        detailView.actionButtonsContainer.isHidden = !allowEditing
        detailView.actionButtonsHeightConstraint.constant = allowEditing ? 70 : 0
    }
    
    private func configureView() {
        let start = dateFormatter.string(from: entry.startDate)
        let end = dateFormatter.string(from: entry.endDate)
        let dateString = (start == end) ? start : "\(start) - \(end)"
        
        detailView.configure(
            location: entry.location,
            date: dateString,
            title: entry.title,
            content: entry.summary,
            isPrivate: entry.isPrivate,
            tags: entry.tags,
            photoCount: entry.photos.count
        )
        
        if let coverImage = entry.coverImage {
            detailView.coverImageView.image = coverImage
        } else if let firstPhoto = entry.photos.first {
            detailView.coverImageView.image = firstPhoto
        } else {
            detailView.coverImageView.image = UIImage(systemName: "photo.fill")
            detailView.coverImageView.tintColor = UIColor(red: 0.75, green: 0.77, blue: 0.79, alpha: 1.0)
            detailView.coverImageView.contentMode = .center
        }
        
        updatePhotoCollectionHeight()
        detailView.photoCollectionView.reloadData()
    }
    
    private func updatePhotoCollectionHeight() {
        let itemsPerRow: CGFloat = 3
        let spacing: CGFloat = 8
        let totalSpacing = spacing * (itemsPerRow - 1)
        let availableWidth = UIScreen.main.bounds.width - 32
        let itemWidth = (availableWidth - totalSpacing) / itemsPerRow
        
        let numberOfRows = ceil(CGFloat(entry.photos.count) / itemsPerRow)
        let height = numberOfRows * itemWidth + (numberOfRows - 1) * spacing
        
        detailView.photoCollectionHeightConstraint.constant = max(height, 100)
        
        if entry.photos.isEmpty {
            detailView.photosHeaderLabel.text = "No Photos"
            detailView.photoCollectionHeightConstraint.constant = 0
        }
    }
    
    
    @objc private func shareTapped() {
        var shareItems: [Any] = [
            "Check out my travel log: \(entry.title) at \(entry.location)",
            entry.summary
        ]
        
        if let coverImage = entry.coverImage ?? entry.photos.first {
            shareItems.append(coverImage)
        }
        
        let activityVC = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        
        if let popover = activityVC.popoverPresentationController {
            popover.barButtonItem = navigationItem.rightBarButtonItem
        }
        
        present(activityVC, animated: true)
    }
    
    @objc func editTapped() {
        let editVC = CreateEditLogViewController(entry: entry)
        editVC.onSave = { [weak self] updatedEntry in
            self?.entry = updatedEntry
            self?.configureView()
            self?.onUpdate?(updatedEntry)
        }
        let navController = UINavigationController(rootViewController: editVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    @objc func deleteTapped() {
        let alert = UIAlertController(
            title: "Delete Log",
            message: "Are you sure you want to delete \"\(entry.title)\"? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.onDelete?(self.entry)
            self.navigationController?.popViewController(animated: true)
        })
        
        present(alert, animated: true)
    }
}

extension LogDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return entry.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as! PhotoCell
        cell.configure(with: entry.photos[indexPath.item], showDeleteButton: false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let spacing: CGFloat = 8
        let totalSpacing = spacing * (itemsPerRow - 1)
        let availableWidth = collectionView.bounds.width - totalSpacing
        let itemWidth = availableWidth / itemsPerRow
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageVC = FullScreenImageViewController(images: entry.photos, startIndex: indexPath.item)
        imageVC.modalPresentationStyle = .fullScreen
        present(imageVC, animated: true)
    }
}

class FullScreenImageViewController: UIViewController {
    
    private let images: [UIImage]
    private var currentIndex: Int
    
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    private var closeButton: UIButton!
    
    init(images: [UIImage], startIndex: Int) {
        self.images = images
        self.currentIndex = startIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupScrollView()
        setupPageControl()
        setupCloseButton()
        
        scrollView.setContentOffset(CGPoint(x: CGFloat(currentIndex) * view.bounds.width, y: 0), animated: false)
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        let contentWidth = CGFloat(images.count) * view.bounds.width
        scrollView.contentSize = CGSize(width: contentWidth, height: view.bounds.height)
        
        for (index, image) in images.enumerated() {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(
                x: CGFloat(index) * view.bounds.width,
                y: 0,
                width: view.bounds.width,
                height: view.bounds.height
            )
            scrollView.addSubview(imageView)
        }
    }
    
    private func setupPageControl() {
        pageControl = UIPageControl()
        pageControl.numberOfPages = images.count
        pageControl.currentPage = currentIndex
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
    private func setupCloseButton() {
        closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = .white
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32),
        ])
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}

extension FullScreenImageViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / view.bounds.width)
        pageControl.currentPage = page
    }
}
