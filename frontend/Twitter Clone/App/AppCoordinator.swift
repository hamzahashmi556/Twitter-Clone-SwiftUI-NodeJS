//
//  AppCoordinator.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//

import UIKit
import Combine

final class AppCoordinator {
    private let window: UIWindow
    private let container: AppContainer
    private var cancellables = Set<AnyCancellable>()
    private var authVM: AuthViewModel

    init(window: UIWindow, container: AppContainer) {
        self.window = window
        self.container = container
        self.authVM = AuthViewModel(
            authService: container.authService,
            userService: container.userService
        )
    }

    func start() {
        
        authVM.$isAuthenticated
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] isAuthenticated in
                guard let self else { return }
                if isAuthenticated {
                    self.showMainFlow(user: authVM.currentUser)
                }
            }
            .store(in: &cancellables)
        
        if UserDefaults.jwt != nil {
            showMainFlow(user: authVM.currentUser)
        } else {
            showAuthFlow()
        }
    }

    private func showAuthFlow() {
        
        let welcomeVC = WelcomeViewController()
        let navVC = UINavigationController(rootViewController: welcomeVC)
        
        welcomeVC.onLoginTapped = { [weak self] in
            guard let self = self else { return }
            self.showLogin(authVM: self.authVM, navigationController: navVC)
        }
        welcomeVC.onRegisterTapped = { [weak self] in
            guard let self = self else { return }
            self.showRegister(authVM: self.authVM, navigationController: navVC)
        }
        
        
        window.rootViewController = navVC
        window.makeKeyAndVisible()
    }
    
    private func showLogin(authVM: AuthViewModel, navigationController: UINavigationController) {
        let loginVC = LoginViewController(viewModel: authVM)
        navigationController.pushViewController(loginVC, animated: true)
    }
    
    private func showRegister(authVM: AuthViewModel, navigationController: UINavigationController) {
        let registerVC = RegisterViewController(viewModel: authVM)
        navigationController.pushViewController(registerVC, animated: true)
    }

    private func showMainFlow(user: UserModel?) {
        let mainVC = MainViewController(user: user, container: container, authVM: authVM)
        let navVC = UINavigationController(rootViewController: mainVC)
        window.rootViewController = navVC
        window.makeKeyAndVisible()
    }
}
