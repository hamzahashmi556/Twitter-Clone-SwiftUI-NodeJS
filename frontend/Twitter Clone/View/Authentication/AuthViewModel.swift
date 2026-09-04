//
//  AuthViewModel.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 04/09/2026.
//

import Combine
import Foundation

final class AuthViewModel: ObservableObject {
    
    @Published private(set) var isAuthenticated = false
    @Published private(set) var currentUser: UserModel? = nil
    @Published private(set) var isLoading = false
    
    private let authService: AuthServiceProtocol
    private let userService: UserServiceProtocol
    
    init(
        authService: AuthServiceProtocol,
        userService: UserServiceProtocol
    ) {
        self.authService = authService
        self.userService = userService
        self.isAuthenticated = UserDefaults.jwt != nil
        if let userID = UserDefaults.userID {
            self.fetchUser(id: userID)
        }
    }
    
    func login(email: String, password: String) {
        isLoading = true

        Task { @MainActor in
            defer {
                isLoading = false
            }

            do {
                let request = LoginRequest(email: email, password: password)
                let response = try await authService.login(request: request)
                UserDefaults.jwt = response.token
                UserDefaults.userID = response.user.id
                self.isAuthenticated = true
                self.currentUser = response.user
//                AlertManager.shared.showAlert(message: "Logged in successfully.")
                print("Login Complete: \(response)")
            } catch {
                AlertManager.shared.showAlert(
                    message: error.localizedDescription.isEmpty ? "Login failed. Please try again." : error.localizedDescription
                )
                print("Login Error: \(error)")
            }
        }
    }
    
    func register(name: String, userName: String, email: String, password: String) {
        isLoading = true
        Task { @MainActor in
            do {
                let value = UserRequest(
                    name: name,
                    userName: userName,
                    email: email,
                    password: password,
                )
                let response = try await authService.register(value: value)
                self.isAuthenticated = true
                self.currentUser = response
                print("Register Completed: \(response)")
//                AlertManager.shared.showAlert(message: "User Registered.")
                
            }
            catch {
                AlertManager.shared.showAlert(
                    message: error.localizedDescription.isEmpty ? "Registration failed. Please try again." : error.localizedDescription
                )
                print("Register Error: \(error)")
            }
            isLoading = false
        }
    }
    
    func logout() {
        
        // remove jwt & userid cache
        UserDefaults.standard.dictionaryRepresentation().keys.forEach({ key in
            UserDefaults.standard.removeObject(forKey: key)
        })
        
        self.isAuthenticated = false
        self.currentUser = nil
    }
    
    private func fetchUser(id: String) {
        self.isLoading = true
        Task.detached { @MainActor in
            if let user = try? await self.userService.getUser(id: id) {
                self.currentUser = user
            }
            self.isLoading = false
        }
    }
}
