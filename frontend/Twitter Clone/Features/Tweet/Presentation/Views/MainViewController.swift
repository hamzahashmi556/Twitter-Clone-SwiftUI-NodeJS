//
//  MainViewController.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//


import UIKit
import Combine

final class MainViewController: BaseViewController {
    private let container: AppContainer
    private let authVM: AuthViewModel
    
    private let slideMenuViewController: SlideMenuViewController
    private let homeViewController: HomeViewController
    
    private var slideMenuWidthConstraint: NSLayoutConstraint?
    private var isMenuOpen = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(container: AppContainer, authVM: AuthViewModel) {
        self.container = container
        self.authVM = authVM
        self.homeViewController = HomeViewController(container: container, authVM: authVM)
        self.slideMenuViewController = SlideMenuViewController(authVM: authVM)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Twitter"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.horizontal.3"),
            style: .plain,
            target: self,
            action: #selector(didTapMenu)
        )
        setupChildren()
        
        setupGestures()
        
        self.slideMenuViewController.onProfileTapped = { [weak self] in
            guard let self, let user = authVM.currentUser else { return }
            let profileVC = ProfileViewController(
                user: user,
                otherUser: nil,
                container: container
            )
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
        slideMenuViewController.onLogoutTapped = { [weak self] in
            self?.authVM.logout()
        }
        
        
        homeViewController.onDimmerTapped = { [weak self] in
            self?.closeMenu()
        }
        homeViewController.onComposeTapped = { [weak self] in
            guard let self, let user = authVM.currentUser else { return }
            let createSheet = CreateTweetViewController(
                tweetService: container.tweetService,
                user: user
            )
            self.present(createSheet, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let menuWidth = max(view.bounds.width - 90, 240)
        slideMenuWidthConstraint?.constant = menuWidth
    }
    
    private func setupChildren() {
        addChild(slideMenuViewController)
        view.addSubview(slideMenuViewController.view)
        slideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false
        slideMenuViewController.didMove(toParent: self)
        
        addChild(homeViewController)
        view.addSubview(homeViewController.view)
        homeViewController.view.translatesAutoresizingMaskIntoConstraints = false
        homeViewController.didMove(toParent: self)
        
        slideMenuWidthConstraint = slideMenuViewController.view.widthAnchor.constraint(equalToConstant: 280)
        slideMenuWidthConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            slideMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            slideMenuViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            slideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            homeViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            homeViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func didTapMenu() {
        isMenuOpen ? closeMenu() : openMenu()
    }
    
    @objc private func didTapDimmer() {
        closeMenu()
    }
    
    private func openMenu() {
        isMenuOpen = true
        let menuWidth = slideMenuWidthConstraint?.constant ?? 280
        homeViewController.openMenuAction(menuWidth: menuWidth)
    }
    
    private func closeMenu() {
        isMenuOpen = false
        homeViewController.closeMenuAction()
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view).x
        let menuWidth = slideMenuWidthConstraint?.constant ?? 280
        
        switch gesture.state {
        case .changed:
            let targetX: CGFloat
            if isMenuOpen {
                targetX = max(0, min(menuWidth, menuWidth + translation))
            } else {
                targetX = max(0, min(menuWidth, translation))
            }
            homeViewController.updateTransormation(targetX: targetX, menuWidth: menuWidth)
        case .ended, .cancelled:
            let shouldOpen = homeViewController.view.transform.tx > menuWidth / 2
            shouldOpen ? openMenu() : closeMenu()
        default:
            break
        }
    }
    
    private func presentComposeAlert() {
        let alert = UIAlertController(title: "Create Tweet", message: "Wire this to your compose screen next.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
