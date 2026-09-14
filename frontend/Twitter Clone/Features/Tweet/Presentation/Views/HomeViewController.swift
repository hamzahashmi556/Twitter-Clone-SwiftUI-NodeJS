//
//  HomeViewController.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//


import UIKit

final class HomeViewController: UIViewController {
    private let contentTabBarController = UITabBarController()
    private let composeButton = UIButton(type: .system)
    private let container: AppContainer
    private let authVM: AuthViewModel
    private let dimmingView = UIView()
    
    var onDimmerTapped: (() -> Void)?
    var onComposeTapped: (() -> Void)?
    
    init(container: AppContainer, authVM: AuthViewModel) {
        self.container = container
        self.authVM = authVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTabs()
        setupComposeButton()
        setupDimmingView()
    }
    
    private func setupTabs() {
        let feedVC = FeedViewController(container: container, authVM: authVM)
        let searchVC = SearchViewController(container: container, authVM: authVM)
        let notificationsVC = PlaceholderViewController(title: "Notifications")
        let messagesVC = PlaceholderViewController(title: "Messages")
        
        feedVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Home") ?? UIImage(systemName: "house"), selectedImage: UIImage(named: "Home"))
        searchVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Search") ?? UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(named: "Search"))
        notificationsVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Notifications") ?? UIImage(systemName: "bell"), selectedImage: UIImage(named: "Notifications"))
        messagesVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Messages") ?? UIImage(systemName: "message"), selectedImage: UIImage(named: "Messages"))
        
        contentTabBarController.viewControllers = [feedVC, searchVC, notificationsVC, messagesVC]
        contentTabBarController.selectedIndex = 0
        contentTabBarController.tabBar.tintColor = UIColor(red: 29 / 255, green: 161 / 255, blue: 242 / 255, alpha: 1)
        contentTabBarController.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(contentTabBarController)
        view.addSubview(contentTabBarController.view)
        contentTabBarController.didMove(toParent: self)
                
        NSLayoutConstraint.activate([
            contentTabBarController.view.topAnchor.constraint(equalTo: view.topAnchor),
            contentTabBarController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentTabBarController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentTabBarController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupDimmingView() {
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmingView.alpha = 0
        dimmingView.isUserInteractionEnabled = true
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dimmingView)
        
        NSLayoutConstraint.activate([
            dimmingView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dimmerAction))
        dimmingView.addGestureRecognizer(tap)
    }
    
    @objc func dimmerAction() {
        self.onDimmerTapped?()
    }
    
    private func setupComposeButton() {
        composeButton.translatesAutoresizingMaskIntoConstraints = false
        composeButton.setImage(UIImage(named: "tweet") ?? UIImage(systemName: "plus"), for: .normal)
        composeButton.imageView?.contentMode = .scaleAspectFit
        composeButton.tintColor = .white
        composeButton.backgroundColor = UIColor(red: 29 / 255, green: 161 / 255, blue: 242 / 255, alpha: 1)
        composeButton.layer.cornerRadius = 28
        composeButton.layer.shadowColor = UIColor.black.cgColor
        composeButton.layer.shadowOpacity = 0.18
        composeButton.layer.shadowRadius = 8
        composeButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        composeButton.addTarget(self, action: #selector(didTapCompose), for: .touchUpInside)
        
        view.addSubview(composeButton)
        NSLayoutConstraint.activate([
            composeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            composeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -58),
            composeButton.widthAnchor.constraint(equalToConstant: 56),
            composeButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    func updateTransormation(targetX: CGFloat, menuWidth: CGFloat) {
        view.transform = CGAffineTransform(translationX: targetX, y: 0)
//        dimmingView.transform = CGAffineTransform(translationX: targetX, y: 0)
        dimmingView.alpha = targetX / menuWidth

    }
    
    func closeMenuAction() {
        UIView.animate(withDuration: 0.25) {
//            self.dimmingView.transform = .identity
            self.view.transform = .identity
            self.dimmingView.alpha = 0
        }
    }
    
    func openMenuAction(menuWidth: CGFloat) {
        UIView.animate(withDuration: 0.25) {
//            self.dimmingView.transform = CGAffineTransform(translationX: menuWidth, y: 0)
            self.view.transform = CGAffineTransform(translationX: menuWidth, y: 0)
            self.dimmingView.alpha = 1
        }
    }
    
    func updateOpacity(alpha: CGFloat) {
        self.dimmingView.alpha = alpha
    }
    
    @objc private func didTapCompose() {
        onComposeTapped?()
    }
}
