//
//  AuthViewModel.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 03/09/2026.
//

import Foundation
import Combine

class RegisterViewModel: ObservableObject {
    
    @Published var name = ""
    @Published var userName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    
    let service: AuthServiceProtocol
    
    init(service: AuthServiceProtocol) {
        self.service = service
    }
    
    func register() {
        isLoading = true
        Task { @MainActor in
            do {
                let value = UserRequest(
                    name: name,
                    userName: userName,
                    email: email,
                    password: password,
                )
                let response = try await service.register(value: value)
                print("Register Complete: \(response)")
                AlertManager.shared.showAlert(message: "User Registered.")
                
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
}
