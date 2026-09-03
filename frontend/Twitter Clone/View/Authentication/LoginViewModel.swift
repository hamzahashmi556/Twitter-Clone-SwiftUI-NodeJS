//
//  LoginViewModel.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 03/09/2026.
//

import Foundation
import Combine
import SwiftUI

final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var emailDone = false
    @Published var isLoading = false

    let service: AuthServiceProtocol

    init(service: AuthServiceProtocol) {
        self.service = service
    }

    func continueToPasswordStep() {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            AlertManager.shared.showAlert(message: "Please enter your email or username.")
            return
        }

        withAnimation {
            emailDone = true
        }
    }

    func login() {
        isLoading = true

        Task { @MainActor in
            defer {
                isLoading = false
            }

            do {
                let request = LoginRequest(email: email, password: password)
                let response = try await service.login(request: request)
                UserDefaults.jwt = response.token
                AlertManager.shared.showAlert(message: "Logged in successfully.")
                print("Login Complete: \(response)")
            } catch {
                AlertManager.shared.showAlert(
                    message: error.localizedDescription.isEmpty ? "Login failed. Please try again." : error.localizedDescription
                )
                print("Login Error: \(error)")
            }
        }
    }
}
