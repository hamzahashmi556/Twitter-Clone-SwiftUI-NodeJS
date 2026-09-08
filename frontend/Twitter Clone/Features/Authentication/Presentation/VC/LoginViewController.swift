//
//  LoginViewController.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//

import UIKit

final class LoginViewController: UIViewController {
    
    private let viewModel: AuthViewModel
    private var isPasswordVisible = false
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let passwordToggleButton = UIButton(type: .system)
    private let loginButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let formStack = UIStackView()
    private let loadingOverlay = UIView()
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupActions()
        observeLoadingState()
    }
    
    private func setupUI() {
        let twitterImageView = UIImageView(image: UIImage(named: "Twitter"))
        twitterImageView.contentMode = .scaleAspectFit
        twitterImageView.translatesAutoresizingMaskIntoConstraints = false
        twitterImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        twitterImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        navigationItem.titleView = twitterImageView
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(didTapCancel)
        )
        
        titleLabel.text = "Log in to Twitter"
        titleLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        subtitleLabel.text = "Enter your email and password to continue."
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        
        configureTextField(emailTextField, placeholder: "Phone, email, or username")
        configureTextField(passwordTextField, placeholder: "Password", isSecure: true)
        configurePasswordToggle()
        
        loginButton.setTitle("Log in", for: .normal)
        stylePrimaryButton(loginButton)
        
        formStack.axis = .vertical
        formStack.spacing = 16
        formStack.translatesAutoresizingMaskIntoConstraints = false
        formStack.addArrangedSubview(titleLabel)
        formStack.addArrangedSubview(subtitleLabel)
        formStack.addArrangedSubview(emailTextField)
        formStack.addArrangedSubview(passwordTextField)
        formStack.addArrangedSubview(loginButton)
        
        loadingOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        loadingOverlay.translatesAutoresizingMaskIntoConstraints = false
        loadingOverlay.isHidden = true
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(formStack)
        view.addSubview(loadingOverlay)
        loadingOverlay.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            formStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            formStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            formStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            loadingOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            loadingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: loadingOverlay.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loadingOverlay.centerYAnchor)
        ])
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        passwordToggleButton.addTarget(self, action: #selector(didTapPasswordToggle), for: .touchUpInside)
    }
    
    private func observeLoadingState() {
        updateLoadingUI(viewModel.isLoading)
        
        // The view model currently exposes loading state through @Published.
        // Hooking up live observation is outside this UI cleanup.
    }
    
    private func updateLoadingUI(_ isLoading: Bool) {
        loadingOverlay.isHidden = !isLoading
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = !isLoading
    }
    
    @objc private func didTapCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapLogin() {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty,
              let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !password.isEmpty else {
            presentAlert(title: "Missing Info", message: "Please enter your email and password.")
            return
        }
        
        viewModel.login(email: email, password: password)
    }
    
    @objc private func didTapPasswordToggle() {
        isPasswordVisible.toggle()
        passwordTextField.isSecureTextEntry = !isPasswordVisible
        passwordToggleButton.setImage(
            UIImage(systemName: isPasswordVisible ? "eye" : "eye.slash"),
            for: .normal
        )
    }
    
    private func configureTextField(_ textField: UITextField, placeholder: String, isSecure: Bool = false) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = isSecure
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    private func configurePasswordToggle() {
        let imageName = isPasswordVisible ? "eye" : "eye.slash"
        passwordToggleButton.setImage(UIImage(systemName: imageName), for: .normal)
        passwordToggleButton.tintColor = .secondaryLabel
        passwordToggleButton.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        passwordTextField.rightView = passwordToggleButton
        passwordTextField.rightViewMode = .always
    }
    
    private func stylePrimaryButton(_ button: UIButton) {
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 24
        button.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }
    
    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
