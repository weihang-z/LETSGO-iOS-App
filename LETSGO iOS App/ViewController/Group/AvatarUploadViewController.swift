//
// AvatarUploadViewController.swift
//  LETSGO iOS App
//
//  Created by zft on 22/11/2025.
//
import UIKit

final class AvatarUploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var onSave: ((UIImage?) -> Void)?

    private let previewImageView = UIImageView()
    private let statusLabel = UILabel()
    private let chooseButton = UIButton(type: .system)
    private let saveButton = UIButton(type: .system)
    private let clearButton = UIButton(type: .system)

    private var selectedImage: UIImage? {
        didSet { updatePreview() }
    }
    init(currentImage: UIImage?) {
        self.selectedImage = currentImage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Upload Avatar"
        view.backgroundColor = .systemBackground
        configurePreview()
        configureButtons()
        layoutContent()
        updatePreview()
    }

    private func configurePreview() {
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.clipsToBounds = true
        previewImageView.backgroundColor = UIColor.systemGray5
        previewImageView.layer.cornerRadius = 80
        previewImageView.translatesAutoresizingMaskIntoConstraints = false

        statusLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        statusLabel.textColor = .secondaryLabel
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
    }

    private func configureButtons() {
        chooseButton.setTitle("Choose Photo", for: .normal)
        chooseButton.addTarget(self, action: #selector(choosePhotoTapped), for: .touchUpInside)
        chooseButton.heightAnchor.constraint(equalToConstant: 48).isActive = true

        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 14
        saveButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        clearButton.setTitle("Remove Photo", for: .normal)
        clearButton.setTitleColor(.systemRed, for: .normal)
        clearButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
    }

    private func layoutContent() {
        let stack = UIStackView(arrangedSubviews: [
            previewImageView,
            statusLabel,
            chooseButton,
            saveButton,
            clearButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            previewImageView.widthAnchor.constraint(equalToConstant: 160),
            previewImageView.heightAnchor.constraint(equalTo: previewImageView.widthAnchor),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])

        chooseButton.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        saveButton.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        clearButton.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
    }

    private func updatePreview() {
        previewImageView.image = selectedImage ?? UIImage(systemName: "person.crop.circle.fill")
        previewImageView.tintColor = selectedImage == nil ? .systemGray : .clear
        if selectedImage == nil {
            statusLabel.text = "No photo selected."
        } else {
            statusLabel.text = "Preview ready. Tap Save to update."
        }
    }

    @objc private func choosePhotoTapped() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc private func saveTapped() {
        onSave?(selectedImage)
        navigationController?.popViewController(animated: true)
    }

    @objc private func clearTapped() {
        selectedImage = nil
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        let image = info[.originalImage] as? UIImage
        selectedImage = image
    }
}
