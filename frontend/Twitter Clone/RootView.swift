//
//  ContentView.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 03/09/2026.
//

import SwiftUI
import Combine

struct RootView: View {
        
    @StateObject private var alertManager = AlertManager.shared
    
    @StateObject var authVM: AuthViewModel
    
    let authService: AuthServiceProtocol
    
    var body: some View {
        
        ZStack {
            if authVM.isAuthenticated {
                MainView()
            }
            else {
                LogInView(authService: authService)
            }
            
            if authVM.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .alert(alertManager.errorMsg, isPresented: $alertManager.isPresented) {
            Button("OK") {
                alertManager.isPresented = false
                alertManager.errorMsg.removeAll()
            }
        }
    }
}

final class AuthViewModel: ObservableObject {
    
    @Published private(set) var isAuthenticated = false
    @Published private(set) var currentUser: UserResponse? = nil
    @Published private(set) var isLoading = false
    
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.isAuthenticated = UserDefaults.jwt != nil
        self.userService = userService
        if let userID = UserDefaults.userID {
            self.fetchUser(id: userID)
        }
    }
    
    private func fetchUser(id: String) {
        self.isLoading = true
        Task { @MainActor in
            if let user = try? await userService.getUser(id: id) {
                self.currentUser = user
            }
            self.isLoading = false
        }
    }
}
