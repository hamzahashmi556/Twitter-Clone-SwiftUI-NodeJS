//
//  WelcomeViewController.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//


import UIKit

final class WelcomeViewController: UIViewController {
    
    var onLoginTapped: (() -> Void)?
    var onRegisterTapped: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "See what's happening in the world right now."
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create account", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        button.layer.cornerRadius = 30
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        let title = NSMutableAttributedString(
            string: "Have an account already? ",
            attributes: [.foregroundColor: UIColor.label]
        )
        title.append(NSAttributedString(
            string: "Log in",
            attributes: [.foregroundColor: UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)]
        ))
        button.setAttributedTitle(title, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupActions()
    }
    
    private func setupActions() {
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    }
    
    private func setupUI() {
        let imgView = UIImageView(image: UIImage(named: "Twitter"))
        imgView.contentMode = .scaleAspectFit
        let stack = UIStackView(arrangedSubviews: [
            imgView,
            titleLabel,
            createAccountButton,
            loginButton
        ])
        
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 24
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        createAccountButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    @objc private func didTapCreateAccount() {
        onRegisterTapped?()
    }
    
    @objc private func didTapLogin() {
        onLoginTapped?()
    }
}
