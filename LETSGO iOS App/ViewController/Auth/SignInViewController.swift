//
//  SignInViewController.swift
//  LETSGO iOS App
//
//  Created by Weihang Zeng on 12/10/25.
//

import UIKit

class SignInViewController: UIViewController {
    
    private var authView: AuthView!
    var onSignInSuccess: (() -> Void)?
    
    override func loadView() {
        authView = AuthView(isSignUp: false)
        view = authView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupKeyboardDismissal()
    }
    
    private func setupActions() {
        authView.primaryButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        authView.secondaryButton.addTarget(self, action: #selector(switchToSignUp), for: .touchUpInside)
    }
    
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func signInTapped() {
        authView.hideError()
        
        guard let email = authView.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty else {
            authView.showError("Please enter your email")
            return
        }
        
        guard let password = authView.passwordTextField.text,
              !password.isEmpty else {
            authView.showError("Please enter your password")
            return
        }
        
        authView.setLoading(true)
        
        FirebaseService.shared.signIn(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.authView.setLoading(false)
                
                switch result {
                case .success:
                    self?.onSignInSuccess?()
                case .failure(let error):
                    self?.authView.showError(error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func switchToSignUp() {
        let signUpVC = SignUpViewController()
        signUpVC.onSignUpSuccess = onSignInSuccess
        signUpVC.modalPresentationStyle = .fullScreen
        present(signUpVC, animated: true)
    }
}

