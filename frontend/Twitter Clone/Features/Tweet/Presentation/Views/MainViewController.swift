//
//  MainViewController.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//


import UIKit
import Combine

final class MainViewController: UIViewController {
    private var user: UserModel?
    private let container: AppContainer
    
    private let slideMenuViewController: SlideMenuViewController
    private let homeViewController: HomeViewController
    private let dimmingView = UIView()
    private var slideMenuWidthConstraint: NSLayoutConstraint?
    private var isMenuOpen = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(user: UserModel?, container: AppContainer, authVM: AuthViewModel) {
        self.user = user
        self.container = container
        self.slideMenuViewController = SlideMenuViewController(user: user)
        self.homeViewController = HomeViewController(tweetService: container.tweetService)
        super.init(nibName: nil, bundle: nil)
        authVM.$currentUser
            .receive(on: RunLoop.main)
            .sink { [weak self] currentUser in
                self?.user = currentUser
            }
            .store(in: &cancellables)
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
        setupDimmingView()
        setupGestures()
        homeViewController.onComposeTapped = { [weak self] in
            guard let self, let user else { return }
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
    
    func bindData(user: UserModel?) {
        self.user = user
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapDimmer))
        dimmingView.addGestureRecognizer(tap)
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
        
        UIView.animate(withDuration: 0.25) {
            self.homeViewController.view.transform = CGAffineTransform(translationX: menuWidth, y: 0)
            self.dimmingView.alpha = 1
        }
    }
    
    private func closeMenu() {
        isMenuOpen = false
        UIView.animate(withDuration: 0.25) {
            self.homeViewController.view.transform = .identity
            self.dimmingView.alpha = 0
        }
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
            homeViewController.view.transform = CGAffineTransform(translationX: targetX, y: 0)
            dimmingView.alpha = targetX / menuWidth
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
