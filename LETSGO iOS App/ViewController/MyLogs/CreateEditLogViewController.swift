//
//  CreateEditLogViewController.swift
//  LETSGO iOS App
//
//  Created by Weihang Zeng on 11/17/25.
//

import UIKit
import PhotosUI

class CreateEditLogViewController: UIViewController {
    
    var createEditView: CreateEditLogView!
    var onSave: ((TravelLogEntry) -> Void)?
    
    private var existingEntry: TravelLogEntry?
    private var coverImage: UIImage?
    private var photos: [UIImage] = []
    private var isEditMode: Bool { existingEntry != nil }
    
    private enum PhotoPickerContext {
        case cover
        case gallery
    }
    private var currentPickerContext: PhotoPickerContext = .gallery
    
    init(entry: TravelLogEntry? = nil) {
        self.existingEntry = entry
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        createEditView = CreateEditLogView()
        view = createEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupCollectionView()
        setupActions()
        setupKeyboardDismissal()
        
        if let entry = existingEntry {
            configureForEdit(entry)
        }
    }
    
    private func setupNavigationBar() {
        title = isEditMode ? "Edit Travel Log" : "New Travel Log"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(closeTapped)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = .systemGreen
    }
    
    private func setupCollectionView() {
        createEditView.photosCollectionView.delegate = self
        createEditView.photosCollectionView.dataSource = self
        createEditView.photosCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        createEditView.photosCollectionView.register(AddPhotoCell.self, forCellWithReuseIdentifier: AddPhotoCell.identifier)
    }
    
    private func setupActions() {
        createEditView.addCoverPhotoButton.addTarget(self, action: #selector(addCoverPhotoTapped), for: .touchUpInside)
        createEditView.removeCoverPhotoButton.addTarget(self, action: #selector(removeCoverPhotoTapped), for: .touchUpInside)
    }
    
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func configureForEdit(_ entry: TravelLogEntry) {
        createEditView.configure(
            title: entry.title,
            location: entry.location,
            date: entry.startDate,
            isPrivate: entry.isPrivate,
            content: entry.summary,
            tags: entry.tags
        )
        
        if let cover = entry.coverImage {
            coverImage = cover
            createEditView.setCoverPhoto(cover)
        }
        
        photos = entry.photos
        updatePhotosCollectionHeight()
        createEditView.photosCollectionView.reloadData()
    }
    
    private func updatePhotosCollectionHeight() {
        let itemCount = photos.count + 1
        let itemSize: CGFloat = 100
        let spacing: CGFloat = 8
        let itemsPerRow = max(1, Int((createEditView.bounds.width - 32) / (itemSize + spacing)))
        let rows = ceil(Double(itemCount) / Double(itemsPerRow))
        let height = CGFloat(rows) * itemSize + CGFloat(max(0, rows - 1)) * spacing
        createEditView.photosCollectionHeightConstraint.constant = max(100, height)
    }
    
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        createEditView.scrollView.contentInset = contentInsets
        createEditView.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        createEditView.scrollView.contentInset = .zero
        createEditView.scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc func closeTapped() {
        if hasUnsavedChanges() {
            let alert = UIAlertController(
                title: "Discard Changes?",
                message: "You have unsaved changes. Are you sure you want to discard them?",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Keep Editing", style: .cancel))
            alert.addAction(UIAlertAction(title: "Discard", style: .destructive) { [weak self] _ in
                self?.dismiss(animated: true)
            })
            present(alert, animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    private func hasUnsavedChanges() -> Bool {
        let hasTitle = !(createEditView.titleTextField.text?.isEmpty ?? true)
        let hasLocation = !(createEditView.locationTextField.text?.isEmpty ?? true)
        let hasContent = !(createEditView.contentTextView.text?.isEmpty ?? true)
        let hasPhotos = !photos.isEmpty || coverImage != nil
        
        return hasTitle || hasLocation || hasContent || hasPhotos
    }
    
    @objc func saveTapped() {
        let titleText = createEditView.titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !titleText.isEmpty else {
            showAlert(message: "Please enter a title.")
            return
        }
        
        let locationText = createEditView.locationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !locationText.isEmpty else {
            showAlert(message: "Please enter a location.")
            return
        }
        
        let contentText = createEditView.contentTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !contentText.isEmpty else {
            showAlert(message: "Please enter details for this log.")
            return
        }
        
        let city = locationText.components(separatedBy: ",").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? locationText
        let startDate = createEditView.datePicker.date
        let isPrivate = createEditView.privacySegmentedControl.selectedSegmentIndex == 1
        let tagsText = createEditView.tagsTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let tags = tagsText.isEmpty ? [] : tagsText.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        let entry = TravelLogEntry(
            id: existingEntry?.id ?? UUID(),
            title: titleText,
            location: locationText,
            city: city,
            startDate: startDate,
            endDate: startDate,
            summary: contentText,
            isPrivate: isPrivate,
            tags: tags,
            coverImage: coverImage,
            photos: photos
        )
        
        onSave?(entry)
        dismiss(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Missing Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    @objc private func addCoverPhotoTapped() {
        currentPickerContext = .cover
        presentPhotoPicker(selectionLimit: 1)
    }
    
    @objc private func removeCoverPhotoTapped() {
        coverImage = nil
        createEditView.setCoverPhoto(nil)
    }
    
    @objc private func addPhotosTapped() {
        currentPickerContext = .gallery
        presentPhotoPicker(selectionLimit: 10 - photos.count)
    }
    
    private func presentPhotoPicker(selectionLimit: Int) {
        var config = PHPickerConfiguration()
        config.selectionLimit = max(1, selectionLimit)
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func removePhoto(at index: Int) {
        guard index < photos.count else { return }
        photos.remove(at: index)
        updatePhotosCollectionHeight()
        createEditView.photosCollectionView.reloadData()
    }
}

extension CreateEditLogViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard !results.isEmpty else { return }
        
        let group = DispatchGroup()
        var loadedImages: [UIImage] = []
        
        for result in results {
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                defer { group.leave() }
                guard let image = object as? UIImage else { return }
                loadedImages.append(image)
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            switch self.currentPickerContext {
            case .cover:
                if let image = loadedImages.first {
                    self.coverImage = image
                    self.createEditView.setCoverPhoto(image)
                }
            case .gallery:
                self.photos.append(contentsOf: loadedImages)
                self.updatePhotosCollectionHeight()
                self.createEditView.photosCollectionView.reloadData()
            }
        }
    }
}

extension CreateEditLogViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == photos.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPhotoCell.identifier, for: indexPath) as! AddPhotoCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as! PhotoCell
            cell.configure(with: photos[indexPath.item], showDeleteButton: true)
            cell.onDelete = { [weak self] in
                self?.removePhoto(at: indexPath.item)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == photos.count {
            addPhotosTapped()
        } else {
            let imageVC = FullScreenImageViewController(images: photos, startIndex: indexPath.item)
            imageVC.modalPresentationStyle = .fullScreen
            present(imageVC, animated: true)
        }
    }
}

extension CreateEditLogViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentCameraOption() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showAlert(message: "Camera is not available on this device.")
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        let image = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        guard let selectedImage = image else { return }
        
        switch currentPickerContext {
        case .cover:
            coverImage = selectedImage
            createEditView.setCoverPhoto(selectedImage)
        case .gallery:
            photos.append(selectedImage)
            updatePhotosCollectionHeight()
            createEditView.photosCollectionView.reloadData()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
