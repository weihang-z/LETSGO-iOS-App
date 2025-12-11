//
//  AuthView.swift
//  LETSGO iOS App
//
//  Created by Weihang Zeng on 12/10/25.
//

import UIKit

class AuthView: UIView {
    
    var logoImageView: UIImageView!
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var usernameTextField: UITextField!
    var confirmPasswordTextField: UITextField!
    var primaryButton: UIButton!
    var secondaryButton: UIButton!
    var errorLabel: UILabel!
    var demoHintLabel: UILabel!
    var activityIndicator: UIActivityIndicatorView!
    
    private let isSignUp: Bool
    
    init(isSignUp: Bool) {
        self.isSignUp = isSignUp
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 0.99, alpha: 1.0)
        
        logoImageView = UIImageView()
        logoImageView.image = UIImage(systemName: "book.closed")
        logoImageView.tintColor = UIColor(red: 0.20, green: 0.78, blue: 0.35, alpha: 1.0)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logoImageView)
        
        titleLabel = UILabel()
        titleLabel.text = isSignUp ? "Create Account" : "Welcome Back"
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.12, green: 0.16, blue: 0.22, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        subtitleLabel = UILabel()
        subtitleLabel.text = isSignUp ? "Start your travel journey today" : "Sign in to continue your adventures"
        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.textColor = UIColor(red: 0.45, green: 0.48, blue: 0.53, alpha: 1.0)
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subtitleLabel)
        
        if isSignUp {
            usernameTextField = createTextField(placeholder: "Username", icon: "person")
            usernameTextField.autocapitalizationType = .none
            addSubview(usernameTextField)
        }
        
        emailTextField = createTextField(placeholder: "Email", icon: "envelope")
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        addSubview(emailTextField)
        
        passwordTextField = createTextField(placeholder: "Password", icon: "lock")
        passwordTextField.isSecureTextEntry = true
        addSubview(passwordTextField)
        
        if isSignUp {
            confirmPasswordTextField = createTextField(placeholder: "Confirm Password", icon: "lock.fill")
            confirmPasswordTextField.isSecureTextEntry = true
            addSubview(confirmPasswordTextField)
        }
        
        errorLabel = UILabel()
        errorLabel.font = .systemFont(ofSize: 14)
        errorLabel.textColor = .systemRed
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(errorLabel)
        
        primaryButton = UIButton(type: .system)
        primaryButton.setTitle(isSignUp ? "Create Account" : "Sign In", for: .normal)
        primaryButton.backgroundColor = UIColor(red: 0.20, green: 0.78, blue: 0.35, alpha: 1.0)
        primaryButton.setTitleColor(.white, for: .normal)
        primaryButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        primaryButton.layer.cornerRadius = 14
        primaryButton.layer.shadowColor = UIColor(red: 0.20, green: 0.78, blue: 0.35, alpha: 1.0).cgColor
        primaryButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        primaryButton.layer.shadowRadius = 8
        primaryButton.layer.shadowOpacity = 0.3
        primaryButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(primaryButton)
        
        secondaryButton = UIButton(type: .system)
        let secondaryText = isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up"
        secondaryButton.setTitle(secondaryText, for: .normal)
        secondaryButton.setTitleColor(UIColor(red: 0.20, green: 0.78, blue: 0.35, alpha: 1.0), for: .normal)
        secondaryButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        secondaryButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(secondaryButton)
        
        if !isSignUp {
            demoHintLabel = UILabel()
            demoHintLabel.font = .systemFont(ofSize: 13)
            demoHintLabel.textColor = UIColor(red: 0.55, green: 0.58, blue: 0.63, alpha: 1.0)
            demoHintLabel.textAlignment = .center
            demoHintLabel.numberOfLines = 0
            demoHintLabel.text = """
For TAs and graders: you can sign in with the demo account
email amy@gmail.com and password 123456 to explore pre-filled travel logs.
"""
            demoHintLabel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(demoHintLabel)
        }
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = UIColor(red: 0.20, green: 0.78, blue: 0.35, alpha: 1.0)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
    }
    
    private func createTextField(placeholder: String, icon: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.font = .systemFont(ofSize: 16)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.88, green: 0.89, blue: 0.91, alpha: 1.0).cgColor
        
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 50))
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = UIColor(red: 0.55, green: 0.58, blue: 0.63, alpha: 1.0)
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(x: 14, y: 15, width: 20, height: 20)
        iconContainer.addSubview(iconView)
        textField.leftView = iconContainer
        textField.leftViewMode = .always
        
        let rightPadding = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 50))
        textField.rightView = rightPadding
        textField.rightViewMode = .always
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    private func setupConstraints() {
        var constraints: [NSLayoutConstraint] = [
            logoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
        ]
        
        if isSignUp {
            constraints.append(contentsOf: [
                usernameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
                usernameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
                usernameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
                usernameTextField.heightAnchor.constraint(equalToConstant: 50),
                
                emailTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 16),
                emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
                emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
                emailTextField.heightAnchor.constraint(equalToConstant: 50),
                
                passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
                passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
                passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
                passwordTextField.heightAnchor.constraint(equalToConstant: 50),
                
                confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
                confirmPasswordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
                confirmPasswordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
                confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
                
                errorLabel.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 16),
            ])
        } else {
            constraints.append(contentsOf: [
                emailTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
                emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
                emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
                emailTextField.heightAnchor.constraint(equalToConstant: 50),
                
                passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
                passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
                passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
                passwordTextField.heightAnchor.constraint(equalToConstant: 50),
                
                errorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            ])
        }
        
        constraints.append(contentsOf: [
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            primaryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 24),
            primaryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            primaryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            primaryButton.heightAnchor.constraint(equalToConstant: 54),
            
            secondaryButton.topAnchor.constraint(equalTo: primaryButton.bottomAnchor, constant: 20),
            secondaryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        if !isSignUp {
            constraints.append(contentsOf: [
                demoHintLabel.topAnchor.constraint(equalTo: secondaryButton.bottomAnchor, constant: 16),
                demoHintLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
                demoHintLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            ])
        }
        
        constraints.append(contentsOf: [
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    func hideError() {
        errorLabel.isHidden = true
    }
    
    func setLoading(_ loading: Bool) {
        if loading {
            activityIndicator.startAnimating()
            primaryButton.isEnabled = false
            primaryButton.alpha = 0.6
        } else {
            activityIndicator.stopAnimating()
            primaryButton.isEnabled = true
            primaryButton.alpha = 1.0
        }
    }
}
