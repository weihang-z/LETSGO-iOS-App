//
//  CreateEditLogViewController.swift
//  LETSGO iOS App
//
//  Created by Weihang Zeng on 11/17/25.
//

import UIKit

class CreateEditLogViewController: UIViewController {
    
    var createEditView: CreateEditLogView!
    var onSave: ((TravelLogEntry) -> Void)?
    
    override func loadView() {
        createEditView = CreateEditLogView()
        view = createEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Travel Log"
        
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
    }
    
    @objc func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc func saveTapped() {
        let titleText = createEditView.titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard titleText.isEmpty == false else {
            showAlert(message: "Please enter a title.")
            return
        }
        
        let locationText = createEditView.locationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard locationText.isEmpty == false else {
            showAlert(message: "Please enter a location.")
            return
        }
        
        let contentText = createEditView.contentTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard contentText.isEmpty == false else {
            showAlert(message: "Please enter details for this log.")
            return
        }
        
        let city = locationText.components(separatedBy: ",").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? locationText
        let startDate = createEditView.datePicker.date
        let isPrivate = createEditView.privacySegmentedControl.selectedSegmentIndex == 1
        let tagsText = createEditView.tagsTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let tags = tagsText.isEmpty ? [] : tagsText.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        let entry = TravelLogEntry(
            id: UUID(),
            title: titleText,
            location: locationText,
            city: city,
            startDate: startDate,
            endDate: startDate,
            summary: contentText,
            isPrivate: isPrivate,
            tags: tags,
            photoCount: 0
        )
        onSave?(entry)
        dismiss(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Missing Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
