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
    
    var body: some View {
        
        ZStack {
            if authVM.isAuthenticated {
                MainView(user: authVM.currentUser)
            }
            else {
                NavigationStack {
                    WelcomeView()
                        .navigationDestination(for: AuthRoute.self) { destination in
                            switch destination {
                            case .login:
                                LogInView(vm: authVM)
                            case .register:
                                RegisterView(vm: authVM)
                            }
                        }
                }
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
