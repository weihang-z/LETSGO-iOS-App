//
//  SignUpViewController.swift
//  LETSGO iOS App
//
//  Created by Weihang Zeng on 12/10/25.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private var authView: AuthView!
    var onSignUpSuccess: (() -> Void)?
    
    override func loadView() {
        authView = AuthView(isSignUp: true)
        view = authView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupKeyboardDismissal()
    }
    
    private func setupActions() {
        authView.primaryButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        authView.secondaryButton.addTarget(self, action: #selector(switchToSignIn), for: .touchUpInside)
    }
    
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func signUpTapped() {
        authView.hideError()
        
        guard let username = authView.usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !username.isEmpty else {
            authView.showError("Please enter a username")
            return
        }
        
        guard username.count >= 3 else {
            authView.showError("Username must be at least 3 characters")
            return
        }
        
        guard let email = authView.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty else {
            authView.showError("Please enter your email")
            return
        }
        
        guard isValidEmail(email) else {
            authView.showError("Please enter a valid email address")
            return
        }
        
        guard let password = authView.passwordTextField.text,
              !password.isEmpty else {
            authView.showError("Please enter a password")
            return
        }
        
        guard password.count >= 6 else {
            authView.showError("Password must be at least 6 characters")
            return
        }
        
        guard let confirmPassword = authView.confirmPasswordTextField.text,
              confirmPassword == password else {
            authView.showError("Passwords do not match")
            return
        }
        
        authView.setLoading(true)
        
        FirebaseService.shared.signUp(email: email, password: password, username: username) { [weak self] result in
            DispatchQueue.main.async {
                self?.authView.setLoading(false)
                
                switch result {
                case .success:
                    self?.onSignUpSuccess?()
                case .failure(let error):
                    self?.authView.showError(error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func switchToSignIn() {
        dismiss(animated: true)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

